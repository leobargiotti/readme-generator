# README Generator

## Introduction

This project is a command-line tool that automatically generates a README.md file for a given project directory. It leverages the Google Gemini API to analyze the project's files and structure, then constructs a comprehensive README file including sections for introduction, features, installation, usage, project structure, and example usage.  The generated README is tailored to be informative and user-friendly.

## Features

 Automated README generation:  Analyzes project files and creates a structured README.md.
 Google Gemini API integration: Uses the powerful Gemini API for natural language processing to generate high-quality README content.
 Customizable language: Allows specifying the language for the generated README (defaults to English).
 Error handling: Includes robust error handling for API requests and file operations.
 Retry mechanism: Implements retries for API rate limiting to ensure reliable operation.


## Installation

1. Install Python3: Ensure you have Python 3 installed on your system.
2. Install required libraries:  Install the necessary Python packages using pip:
   ```bash
   pip install requests
   ```
3. Obtain a Google Gemini API Key: You need a valid API key for the Google Gemini API.  Follow Google's instructions to obtain one.  [Link to Google Gemini API instructions ([https://ai.google.dev/gemini-api/](https://ai.google.dev/gemini-api/)).]
4. Set API Key and Model:  Set the `API_KEY` and `GOOGLE_MODEL` variables in the `generatereadme.sh` script with your API key and the Gemini model URL.


## Usage

The script takes the path to the source folder as a command-line argument. Optionally, you can specify the language for the README.

```bash
  python generatereadme.sh <path_to_source_folder> [language]
```

 `<path_to_source_folder>`: The path to the directory containing the project files.
 `[language]`: (Optional) The language for the README (e.g., "english", "spanish"). Defaults to "english".

Example:

```bash
  python generatereadme.sh ./myproject spanish
```

This command will generate a `README.md` file in Spanish in the parent directory of `./myproject`.


## Project Structure

 [generatereadme.sh](./src/generatereadme.sh): The main Python script that handles README generation.  This script reads project files, constructs a prompt for the Gemini API, sends the request, receives the generated README content, and writes it to a file.


## Example Usage

Let's assume you have a project folder named `myproject` with a few files (e.g., `main.py`, `utils.py`).  After installing the necessary libraries and setting your API key, run the script:

```bash
  python generatereadme.sh ./myproject
```

This will create a `README.md` file in the directory above `myproject` containing a detailed description of your project based on the content of the files within `myproject`.  The generated README will include sections as described in the introduction.  The exact content will depend on the files in your `myproject` directory.  If the `myproject` directory contains files that are not easily summarized (e.g., large binary files), the generated README may not be as comprehensive.


Note:  Remember to replace placeholders like `YOUR_GOOGLE_API` with your actual API key.  The script requires an active internet connection to communicate with the Google Gemini API.  Error handling is included to manage potential issues like network errors and API rate limits.
