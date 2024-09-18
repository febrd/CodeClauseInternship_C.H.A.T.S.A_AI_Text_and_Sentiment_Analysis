import spacy
from langdetect import detect, DetectorFactory
from textblob import TextBlob
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from transformers import MBartTokenizer, MBartForConditionalGeneration
import warnings

warnings.filterwarnings("ignore", category=UserWarning, module='transformers')
DetectorFactory.seed = 0

# Initialize MBart model for multilingual generation
tokenizer = MBartTokenizer.from_pretrained("facebook/mbart-large-50")
model = MBartForConditionalGeneration.from_pretrained("facebook/mbart-large-50")

# Load spaCy model
nlp = spacy.load('en_core_web_sm')

# Forbidden words list
forbidden_words = ['badword1', 'badword2']  # Add any forbidden words here

def contains_forbidden_words(text):
    return any(word in text.lower() for word in forbidden_words)

def detect_language(text):
    try:
        language_code = detect(text)
        language_map = {
            'id': 'Indonesian',
            'en': 'English',
            'fr': 'French',
            'ar': 'Arabic',
            'cs': 'Czech',
            'de': 'German',
            'es': 'Spanish',
            'et': 'Estonian',
            'fi': 'Finnish',
            'gu': 'Gujarati',
            'hi': 'Hindi',
            'it': 'Italian',
            'ja': 'Japanese',
            'kk': 'Kazakh',
            'ko': 'Korean',
            'lt': 'Lithuanian',
            'lv': 'Latvian',
            'my': 'Burmese',
            'ne': 'Nepali',
            'nl': 'Dutch',
            'ro': 'Romanian',
            'ru': 'Russian',
            'si': 'Sinhala',
            'tr': 'Turkish',
            'vi': 'Vietnamese',
            'zh': 'Chinese',
            'af': 'Afrikaans',
            'az': 'Azerbaijani',
            'bn': 'Bengali',
            'fa': 'Persian',
            'he': 'Hebrew',
            'hr': 'Croatian',
            'ka': 'Georgian',
            'km': 'Khmer',
            'mk': 'Macedonian',
            'ml': 'Malayalam',
            'mn': 'Mongolian',
            'mr': 'Marathi',
            'pl': 'Polish',
            'ps': 'Pashto',
            'pt': 'Portuguese',
            'sv': 'Swedish',
            'sw': 'Swahili',
            'ta': 'Tamil',
            'te': 'Telugu',
            'th': 'Thai',
            'tl': 'Tagalog',
            'uk': 'Ukrainian',
            'ur': 'Urdu',
            'xh': 'Xhosa',
            'gl': 'Galician',
            'sl': 'Slovene'
        }
        return language_map.get(language_code, 'unknown')
    except Exception as e:
        print(f"Error detecting language: {e}")
        return 'unknown'

def analyze_sentiment(text, language):
    if language == 'English':
        analyzer = SentimentIntensityAnalyzer()
        sentiment = analyzer.polarity_scores(text)
        if sentiment['compound'] > 0.05:
            return 'positive'
        elif sentiment['compound'] < -0.05:
            return 'negative'
        else:
            return 'neutral'
    else:
        blob = TextBlob(text)
        if blob.sentiment.polarity > 0:
            return 'positive'
        elif blob.sentiment.polarity < 0:
            return 'negative'
        else:
            return 'neutral'

def generate_response(message, language):
    lang_code_map = {
        'English': 'en_XX',
        'Indonesian': 'id_ID',
        'French': 'fr_XX',
        'Arabic': 'ar_AR',
        'Czech': 'cs_CZ',
        'German': 'de_DE',
        'Spanish': 'es_XX',
        'Estonian': 'et_EE',
        'Finnish': 'fi_FI',
        'Gujarati': 'gu_IN',
        'Hindi': 'hi_IN',
        'Italian': 'it_IT',
        'Japanese': 'ja_XX',
        'Kazakh': 'kk_KZ',
        'Korean': 'ko_KR',
        'Lithuanian': 'lt_LT',
        'Latvian': 'lv_LV',
        'Burmese': 'my_MM',
        'Nepali': 'ne_NP',
        'Dutch': 'nl_XX',
        'Romanian': 'ro_RO',
        'Russian': 'ru_RU',
        'Sinhala': 'si_LK',
        'Turkish': 'tr_TR',
        'Vietnamese': 'vi_VN',
        'Chinese': 'zh_CN',
        'Afrikaans': 'af_ZA',
        'Azerbaijani': 'az_AZ',
        'Bengali': 'bn_IN',
        'Persian': 'fa_IR',
        'Hebrew': 'he_IL',
        'Croatian': 'hr_HR',
        'Georgian': 'ka_GE',
        'Khmer': 'km_KH',
        'Macedonian': 'mk_MK',
        'Malayalam': 'ml_IN',
        'Mongolian': 'mn_MN',
        'Marathi': 'mr_IN',
        'Polish': 'pl_PL',
        'Pashto': 'ps_AF',
        'Portuguese': 'pt_XX',
        'Swedish': 'sv_SE',
        'Swahili': 'sw_KE',
        'Tamil': 'ta_IN',
        'Telugu': 'te_IN',
        'Thai': 'th_TH',
        'Tagalog': 'tl_XX',
        'Ukrainian': 'uk_UA',
        'Urdu': 'ur_PK',
        'Xhosa': 'xh_ZA',
        'Galician': 'gl_ES',
        'Slovene': 'sl_SI'
    }
    
    lang_code = lang_code_map.get(language, 'en_XX')

    inputs = tokenizer(message, return_tensors="pt", padding=True, truncation=True)
    
    try:
        generated_ids = model.generate(inputs['input_ids'],
                                       decoder_start_token_id=tokenizer.lang_code_to_id[lang_code],
                                       max_length=50,
                                       num_return_sequences=1,
                                       no_repeat_ngram_size=2,
                                       early_stopping=True,
                                       temperature=0.7,
                                       top_p=0.9)
        reply = tokenizer.decode(generated_ids[0], skip_special_tokens=True)
    except KeyError:
        lang_code = 'en_XX'
        generated_ids = model.generate(inputs['input_ids'],
                                       decoder_start_token_id=tokenizer.lang_code_to_id[lang_code],
                                       max_length=50,
                                       num_return_sequences=1,
                                       no_repeat_ngram_size=2,
                                       early_stopping=True,
                                       temperature=0.7,
                                       top_p=0.9)
        reply = tokenizer.decode(generated_ids[0], skip_special_tokens=True)
    
    reply = reply.strip()
    
    return reply

def process_message(message, language=None):
    if language == 'auto':
        language = detect_language(message)
    elif language is None:
        language = 'English'  # Default language if none provided

    if contains_forbidden_words(message):
        return {'response': "Sorry, your message contains inappropriate content.", 'language': language}

    response = generate_response(message, language)
    return {'response': response, 'language': language}

if __name__ == "__main__":
    import sys
    message = sys.argv[1]
    languages = detect_language(message)
    result = process_message(message, languages)
    print(f"Response: {result['response']}")
    print(f"Detected Language: {result['language']}")
