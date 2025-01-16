# C.H.A.T.S.A

C.H.A.T.S.A is a lightweight Natural Language Processing (NLP) chatbot built with Python. The bot detects the language of user input, performs sentiment analysis, and checks for inappropriate content based on a predefined list of forbidden words. It leverages libraries like `spaCy`, `langdetect`, `TextBlob`, and `vaderSentiment`.

## Features

- **Language Detection**: Detects the language of the input message using `langdetect`.
- **Sentiment Analysis**: 
  - Uses VADER for English sentiment analysis.
  - Falls back to `TextBlob` for non-English text.
- **Forbidden Words Filter**: Identifies and blocks messages containing inappropriate content.
- **Extensibility**: Easily customizable for additional features or language support.

---

## Installation

1. **Clone the repository**:
   ```bash
   git clone [https://github.com/yourusername/febrid-bot.git](https://github.com/febrd/CodeClauseInternship_C.H.A.T.S.A_AI_Text_and_Sentiment_Analysis) C.H.A.T.S.A
   cd C.H.A.T.S.A
   ```

2. **Install dependencies**:
   ```bash
   chmod +x INSTALL/init.sh
   ./INSTALL/init.sh
   ```

---

## Dependencies

This project requires the following libraries and tools:

### Tools
- **Elixir**: Version `1.16.0`
- **Phoenix**: Version `1.7.0`

### Python Libraries
- [`spaCy`](https://spacy.io/): NLP framework.
- [`langdetect`](https://pypi.org/project/langdetect/): Language detection library.
- [`TextBlob`](https://textblob.readthedocs.io/): Sentiment analysis for non-English text.
- [`vaderSentiment`](https://github.com/cjhutto/vaderSentiment): Sentiment analysis specifically for English text.


---

## Usage

Run the script directly from the command line with the message as an argument:
```bash
iex -S mix phx.server
`


---

## Configuration

### Language Mapping
Language detection is powered by `langdetect`. To map language codes to full names, modify the `language_map` in the `detect_language` function:
```python
language_map = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    # Add more mappings as needed
}
```

---

## Customization

### Adding New Features
The bot's modular design allows for easy extension. For example, you can add support for additional NLP tasks, such as:
- Named Entity Recognition (NER) using spaCy.
- Advanced language processing with custom machine learning models.

### Extending Sentiment Analysis
You can integrate other sentiment analysis tools or APIs for languages not well-supported by TextBlob or VADER.

---

## Error Handling

The bot includes basic error handling for:
- Language detection failures (returns `'unknown'`).
- Unexpected issues with external libraries (logs the error to the console).

---

## Contribution

Contributions are welcome! Follow these steps to contribute:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Submit a pull request with a detailed explanation of your changes.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Acknowledgments

Special thanks to the developers of:
- `spaCy` for its powerful NLP capabilities.
- `langdetect` for lightweight language detection.
- `TextBlob` and `vaderSentiment` for their sentiment analysis libraries.

