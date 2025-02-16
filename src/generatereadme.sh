#!/usr/bin/env python3

import os
import argparse
import json
import requests
import time

# Set API_KEY and GOOGLE_MODEL
API_KEY=""    #YOUR_GOOGLE_API
GOOGLE_MODEL="https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent"

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

def create_readme(src_folder, language='english'):
    """
    Generates a README.md file based on the content of the source folder.
    """
    if not os.path.isdir(src_folder):
        raise ValueError("Error: The source folder does not exist.")

    file_summaries = []
    for filename in os.listdir(src_folder):
        if filename.startswith(".") or filename.startswith("~$"):
            continue  # Skip hidden files and temporary files
        filepath = os.path.join(src_folder, filename)
        if os.path.isfile(filepath):
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                file_url = f"[{filename}](./{os.path.basename(src_folder)}/{filename})"
                file_summaries.append(f"File: {file_url}\nContent Preview:\n{content}\n")

    summary_text = "\n".join(file_summaries)
    prompt = (
        f"You are an AI assistant specialized in generating README files for projects. "
        f"Analyze the following project files and generate a detailed and well-structured "
        f"README file in {language}. Include the following sections: \n\n"
        f"## Introduction\nProvide an overview of the project.\n\n"
        f"## Features\nList the main features of the project.\n\n"
        f"## Installation\nProvide installation steps.\n\n"
        f"## Usage\nExplain how to use the project. Include example commands with expected input and output.\n\n"
        f"## Project Structure\nDescribe the purpose of each file with hyperlinks to them.\n\n"
        f"## Example Usage\nGive an example of how to run or use the project, including input and expected output.\n\n"
        f"Here is the project content:\n{summary_text}"
    )
    response = send_request_to_api(prompt)

    readme_path = os.path.join(os.path.dirname(src_folder), "README.md")
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(response)

    print(f"README.md successfully created at {readme_path}")

def main():
    parser = argparse.ArgumentParser(description='Generates a README.md file for a project.')
    parser.add_argument('path_src', help='Path to the source folder.')
    parser.add_argument('language', nargs='?', default='english', help='Language of the README (default: English).')

    args = parser.parse_args()
    create_readme(args.path_src, args.language)

if __name__ == '__main__':
    main()