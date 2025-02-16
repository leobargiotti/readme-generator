# README Generator

This project uses the Google Gemini API to automatically generate a README file for a given project directory.  It analyzes the files within the directory and constructs a comprehensive README.md file including sections for introduction, features, installation, usage, project structure, and example usage.

## Features

- Automatically generates a README.md file.
- Analyzes the contents of source code files to provide context.
- Uses the Google Gemini API for natural language generation.
- Supports specifying output folder and filename.
- Handles potential errors during file reading and API requests.
- Customizable language for the generated README.


## Installation

1.  Install Python 3: Ensure you have Python 3 installed on your system.
2.  Install required packages:
    ```bash
    pip install requests argparse
    ```
3.  Obtain a Google Gemini API Key:  You need a valid API key to use the Google Gemini API.  Follow the instructions on the [Google Gemini API documentation](https://ai.google.dev/gemini-api/) to obtain one.
4.  Set API Key and Model: Replace `"YOUR_GOOGLE_API"` in `src/generatereadme.sh` with your actual API key.  The GOOGLE_MODEL variable should point to the correct Gemini model.


## Usage

The script takes the path to the source folder as a required argument.  Optional arguments allow specifying the output folder, language, and output filename.

```bash
python src/generatereadme.sh <path_to_source_folder> [--output_folder <path_to_output_folder>] [--language <language>] [--output_filename <filename>]
```

Example:

```bash
python src/generatereadme.sh ./myproject --output_folder ./docs --language spanish --output_filename "README_es.md"
```

This command will generate a README file named `README_es.md` in the `./docs` directory, written in Spanish, based on the contents of the `./myproject` folder.


## Project Structure

-   [src/generatereadme.sh](./src/generatereadme.sh): The main Python script that generates the README file.


## Example Usage

Let's assume you have a project folder named `myproject` with a few files. Running the script:

```bash
python src/generatereadme.sh ./myproject
```

will generate a `README.md` file in the `myproject` directory containing a structured README based on the contents of the files within `myproject`.  The exact content of the generated README will depend on the files present in `myproject`.
