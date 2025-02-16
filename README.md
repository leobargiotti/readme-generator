# README Generator

This project contains a script, `generatereadme.sh`, that automatically generates a README.md file for a given project directory.  It leverages the Google Gemini API to analyze the project's files and structure, then constructs a comprehensive README file in Markdown format.

## Features

- Automatically generates a README.md file.
- Analyzes the contents of source code files.
- Uses the Google Gemini API for natural language processing.
- Supports multiple languages (currently defaults to English).
- Includes sections for Introduction, Features, Installation, Usage, Project Structure, and Example Usage.
- Handles potential errors, such as network issues and API rate limits.


## Installation

1.  Install Python 3: Ensure you have Python 3 installed on your system.
2.  Install required libraries:  Install the necessary Python packages using pip:
    ```bash
    pip install requests
    ```
3.  Obtain a Google Gemini API Key:  You need a valid API key to use the Google Gemini API.  Follow the instructions on the Google Cloud Platform to create a project and obtain an API key.
4.  Set API Key and Model: Replace `"YOUR_GOOGLE_API"` in `generatereadme.sh` with your actual API key.  The GOOGLE_MODEL variable points to the Gemini model; you may need to adjust this depending on the model you are using.
5.  Save the script: Save `generatereadme.sh` to your local machine.  Make it executable: `chmod +x generatereadme.sh`


## Usage

The script takes the path to your project's source folder as an argument. Optionally, you can specify the language for the README.

```bash
./generatereadme.sh <path_to_source_folder> [language]
```

 `<path_to_source_folder>`: The path to the directory containing your project files.
 `[language]`: (Optional) The language for the generated README (e.g., "english", "spanish"). Defaults to "english".

Example:

```bash
./generatereadme.sh ./myproject spanish
```

This will generate a `README.md` file in the parent directory of `./myproject`, written in Spanish.


## Project Structure

- [generatereadme.sh](./src/generatereadme.sh): The main Python script that generates the README.md file.


## Example Usage

Let's assume you have a project folder named `myproject` with a few files. After running the script:

```bash
./generatereadme.sh ./myproject
```

A `README.md` file will be created in the parent directory of `myproject`, containing a well-formatted README based on the contents of the `myproject` folder.  The exact content of the README will depend on the files within `myproject`.


## Error Handling

The script includes error handling for:

- Invalid API key or model configuration.
- Network errors during API requests.
- API rate limits (retries with exponential backoff).
- Unexpected responses from the Gemini API.
- Non-existent source folder.


## Contributing

Contributions are welcome! Please open an issue or submit a pull request.


## License

[Specify your license here]
