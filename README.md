# README Generator

This project uses the Google Gemini API to automatically generate a README file for a given project folder.  It analyzes the contents of the folder, including source code, data files, and images, and constructs a comprehensive README.md file.

## Features

- Automatically generates a README.md file in Markdown format.
- Analyzes source code files and provides content previews.
- Includes sections for data files and screenshots.
- Supports specifying output folder and filename.
- Handles potential errors during file reading and API requests.
- Uses the Google Gemini API for natural language generation to create a well-structured README.


## Installation

1.  Install Python 3: Ensure you have Python 3 installed on your system.
2.  Install required libraries:
    ```bash
    pip install requests argparse
    ```
3.  Set API Key: Obtain a Google Gemini API key and set the `API_KEY` variable in `src/generatereadme.sh`.  Also ensure `GOOGLE_MODEL` is correctly set.
4.  Save the script: Save `src/generatereadme.sh` to your local machine.


## Usage

The script takes the path to the source folder as a required argument.  Optional arguments allow specifying the output folder, language, filename, data folder, and images folder.

```bash
  python src/generatereadme.sh <path_to_source_folder> [-o <output_folder>] [-l <language>] [-f <output_filename>] [-d <data_folder>] [-i <images_folder>]
```

Example:

```bash
  python src/generatereadme.sh ./myproject -o ./docs -l english -f README_en.md -d ./data -i ./images
```

This command will generate a README file named `README_en.md` in the `./docs` directory, using English as the language, including data from the `./data` folder and images from the `./images` folder.


## Project Structure

-   [src/generatereadme.sh](./src/generatereadme.sh): The main Python script that generates the README file.




