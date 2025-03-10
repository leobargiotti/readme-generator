#!/usr/bin/env python3

import os
import argparse
import json
import requests
import time
import base64  # Added missing import

# Set API_KEY and GOOGLE_MODEL
API_KEY=""    #YOUR_GOOGLE_API
GOOGLE_MODEL="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent" #https://ai.google.dev/gemini-api/

def send_request_to_api(prompt, max_retries=10):
    """
    Sends a request to the Gemini API with the given prompt, retrying in case of a 429 error.
    """
    if not API_KEY or not GOOGLE_MODEL:
        raise ValueError("Error: API_KEY or GOOGLE_MODEL is not properly configured.")

    headers = {"Content-Type": "application/json"}
    data = {
        "generation_config": {"temperature": 0},
        "contents": [{"parts": [{"text": prompt}]}]
    }
    retries = 0

    while retries <= max_retries:
        try:
            response = requests.post(f"{GOOGLE_MODEL}?key={API_KEY}", headers=headers, json=data)
            if response.status_code == 200:
                result = response.json()
                try:
                    return result['candidates'][0]['content']['parts'][0]['text'].replace("*", "")
                except (KeyError, IndexError):
                    raise ValueError("Error: Unexpected response structure.")
            elif response.status_code == 429:
                retries += 1
                time.sleep(1)
            else:
                raise Exception(f"Error {response.status_code}: {response.text}")
        except requests.RequestException as e:
            raise Exception(f"Network error: {e}")

    raise Exception("Error: Maximum retry attempts exceeded.")


def send_request_to_api_with_image(prompt, image_path, max_retries=1000):
    """
    Send a request to the Gemini API with a given prompt and image, retrying if the request fails due to a 429 error.

    Parameters:
    - prompt (str): The specific prompt to include in the request.
    - image_path (str): Path to the image file to analyze.
    - max_retries (int): Maximum number of retries for the request.

    Returns:
    - str: The response text or an error message.
    """
    # Use the global variables instead of environment variables
    url = GOOGLE_MODEL
    api_key = API_KEY

    model_config = {
        "temperature": 0,
    }

    headers = {
        "Content-Type": "application/json"
    }

    # Read and encode the image
    with open(image_path, "rb") as img_file:
        image_data = base64.b64encode(img_file.read()).decode("utf-8")

    # Structure the request for Gemini Pro Vision
    data = {
        "contents": [
            {
                "parts": [
                    {"text": prompt},
                    {
                        "inline_data": {
                            "mime_type": "image/png",
                            "data": image_data
                        }
                    }
                ]
            }
        ],
        "generation_config": model_config
    }

    retries = 0
    while retries <= max_retries:
        try:
            response = requests.post(f"{url}?key={api_key}", headers=headers, data=json.dumps(data))
            if response.status_code == 200:
                result = response.json()
                try:
                    return result['candidates'][0]['content']['parts'][0]['text'].replace("*", "")
                except (KeyError, IndexError):
                    raise Exception("Error: Unexpected response structure.")
            elif response.status_code == 429:
                retries += 1
                time.sleep(1)
            else:
                raise Exception(f"Error {response.status_code}: {response.text}")
        except Exception as e:
            raise Exception(str(e))
    raise Exception("Error: Maximum retries exceeded. Could not complete the request.")


def process_folder(folder_path, base_path):
    """
    Process a folder and return summaries of its contents.
    """
    if not folder_path or not os.path.isdir(folder_path):
        return []

    file_summaries = []
    for root, _, files in os.walk(folder_path):
        for filename in files:
            if filename.startswith(".") or filename.startswith("~$"):
                continue
            filepath = os.path.join(root, filename)
            try:
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    relative_path = os.path.relpath(filepath, os.path.dirname(base_path))
                    file_url = f"[{relative_path}](./{relative_path})"
                    file_summaries.append(f"File: {file_url}\nContent Preview:\n{content}\n")
            except Exception as e:
                print(f"Warning: Could not read {filepath}: {e}")

    return file_summaries

def create_readme(src_folder, language='english', output_folder=None, output_filename="README.md", data_folder=None, images_folder=None):
    """
    Generates a README.md file based on the content of the source folder and optional data and images folders.
    """
    if not os.path.isdir(src_folder):
        raise ValueError("Error: The source folder does not exist.")

    # Process main source folder
    file_summaries = process_folder(src_folder, src_folder)

    # Add data folder content if specified
    if data_folder:
        file_summaries.append("\n## Data Files:\n")
        data_summaries = process_folder(data_folder, src_folder)
        file_summaries.extend(data_summaries)

    # Add images folder content if specified
    if images_folder:
        file_summaries.append("\n## Screenshot\nBelow are screenshots of the application:\n")
        image_summaries = []
        if os.path.isdir(images_folder):
            for root, _, files in os.walk(images_folder):
                for filename in files:
                    if filename.startswith("."):
                        continue
                    filepath = os.path.join(root, filename)
                    relative_path = os.path.relpath(filepath, os.path.dirname(src_folder))

                    # Use the image processing function to get a description
                    try:
                        description = send_request_to_api_with_image(
                            "Describe this image in one sentence, focusing on its main content and purpose.",
                            filepath
                        )
                    except Exception as e:
                        description = f"Image: {filename}"
                        print(f"Warning: Could not generate description for {filepath}: {e}")

                    image_url = f"![{filename}](./{relative_path})"
                    image_summaries.append(f"{description}\n\n{image_url}")
        file_summaries.extend(image_summaries)

    summary_text = "\n".join(file_summaries)
    prompt = (
    f"You are an AI assistant specialized in generating README files for projects. "
    f"Analyze the following project files and generate a detailed and well-structured "
    f"README file in {language} using Markdown syntax. Ensure proper formatting for headings, lists, and code blocks.\n\n"
    f"## Introduction\nProvide an overview of the project.\n\n"
    f"## Features\nList the main features of the project using bullet points (`-`).\n\n"
    f"## Installation\nProvide installation steps using numbered lists (`1.` `2.` `3.` if sequential, otherwise `-`).\n\n"
    f"## Usage\nExplain how to use the project. Include example commands with expected input and output in code blocks (` ``` `).\n\n"
    f"## Project Structure\nDescribe the purpose of each file with hyperlinks to them.\n\n"
    )
    if data_folder:
        prompt += f"## Data Files\nDescribe the data files and their purpose.\n\n"
    prompt += f"## Example Usage\nGive an example of how to run or use the project, including input and expected output in code blocks (` ``` `).\n\n"
    if images_folder:
        prompt += f"## Screenshot\nEach screenshot should be preceded by its description to specify the image. Example format:\n Description of the image.\n\n![Alt text](image_path.png)\n\n"
    prompt += f"Here is the project content:\n{summary_text}"
    response = send_request_to_api(prompt)

    readme_path = os.path.join(output_folder if output_folder else os.path.dirname(src_folder), output_filename)
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(response)

    print(f"{output_filename} successfully created at {readme_path}")

def main():
    parser = argparse.ArgumentParser(description='Generates a README file for a project.')
    parser.add_argument('path_src', help='Path to the source folder.')
    parser.add_argument('-o', '--output_folder', help='Path to the folder where the README file will be saved (default: parent of source).', default=None)
    parser.add_argument('-l', '--language', help='Language of the README (default: English).', default='english')
    parser.add_argument('-f', '--output_filename', help='Name of the output README file (default: README.md).', default='README.md')
    parser.add_argument('-d', '--data_folder', help='Path to the folder containing data files (optional).', default=None)
    parser.add_argument('-i', '--images_folder', help='Path to the folder containing images (optional).', default=None)

    args = parser.parse_args()
    create_readme(
        args.path_src,
        args.language,
        args.output_folder,
        args.output_filename,
        args.data_folder,
        args.images_folder
    )

if __name__ == '__main__':
    main()
