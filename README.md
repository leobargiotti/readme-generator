# README Generator

This project uses the Google Gemini API to automatically generate a README file for a given project folder.  It analyzes the contents of the folder, including source code, data files, and images, and creates a comprehensive README.md file in Markdown format.

## Features

- Automatically generates a README.md file.
- Supports multiple languages (currently only English is explicitly supported, but the API may handle others).
- Includes sections for introduction, features, installation, usage, project structure, example usage, data files (optional), and screenshots (optional).
- Handles various file types and content.
- Uses the Google Gemini API for natural language processing.
- Includes error handling and retry mechanisms for API requests.


## Installation

1.  Install Python 3: Ensure you have Python 3 installed on your system.
2.  Install required libraries:
    ```bash
    pip install requests argparse
    ```
3.  Set API Key: Obtain a Google Gemini API key and set the `API_KEY` variable in `src/generatereadme.sh`.  Also ensure `GOOGLE_MODEL` is correctly set.
4.  Save the script: Save `src/generatereadme.sh` to your local machine.


## Usage

The script takes the path to the source folder as a required argument.  Optional arguments allow specifying the output folder, language, output filename, data folder, and images folder.

```bash
  python src/generatereadme.sh <path_to_source_folder> [-o <output_folder>] [-l <language>] [-f <output_filename>] [-d <data_folder>] [-i <images_folder>]
```

Example:

```bash
  python src/generatereadme.sh ./myproject -o ./docs -d ./data -i ./images
```

This command will generate a README.md file in the `./docs` directory based on the contents of the `./myproject` folder, including data from `./data` and images from `./images`.


## Project Structure

-   [src/generatereadme.sh](./src/generatereadme.sh): The main Python script that generates the README file.  This script uses the Google Gemini API to generate the README content based on the provided project files.


## Example Usage

Let's assume you have a project folder structured like this:

```
myproject/
├── src/
│   └── myprogram.py
└── data/
    └── data.csv
```

Running the script:

```bash
python src/generatereadme.sh ./src -d ./data
```

Will generate a `README.md` file (in the `myproject` directory) containing a structured overview of your project, including summaries of `myprogram.py` and `data.csv`.  The exact content will depend on the files' contents and the Google Gemini API's response.


##  Disclaimer

This script requires a valid Google Gemini API key.  The functionality and output heavily rely on the capabilities of the Google Gemini API.  Ensure you understand and comply with Google's terms of service and usage guidelines.  Error handling is included, but unexpected behavior from the API is possible.
