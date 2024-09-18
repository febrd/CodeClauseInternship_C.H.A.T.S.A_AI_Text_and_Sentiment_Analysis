from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import random

# Set up Chrome driver
driver = webdriver.Chrome()
driver.maximize_window()  # Open the browser in full screen
driver.get("DEV_URL")
time.sleep(5)

# Define diverse and random conversations including Indonesian
conversations = [
    ("Hello, what are your plans for today?", "en"),
    ("¿Qué planes tienes para hoy?", "es"),
    ("Quel est ton programme pour aujourd'hui ?", "fr"),
    ("Was sind deine Pläne für heute?", "de"),
    ("今日はどんな予定がありますか？", "ja"),
    ("Какие у вас планы на сегодня?", "ru"),
    ("Cosa hai in programma per oggi?", "it"),
    ("O que você tem planejado para hoje?", "pt"),
    ("Vad har du för planer idag?", "sv"),
    ("Ce ai de gând să faci astăzi?", "ro"),
    ("چه برنامه‌هایی برای امروز داری؟", "fa"),
    ("Apa rencanamu hari ini?", "id"),
    ("Apa hobimu yang paling disukai?", "id"),
    ("Apa yang kamu makan untuk makan siang?", "id")
]

Hello, what are your plans for today?
¿Qué planes tienes para hoy?
Quel est ton programme pour aujourd'hui ?
Was sind deine Pläne für heute?
今日はどんな予定がありますか？
Какие у вас планы на сегодня?
Cosa hai in programma per oggi?
O que você tem planejado para hoje?
Vad har du för planer idag?
Ce ai de gând să faci astăzi?
چه برنامه‌هایی برای امروز داری؟
Apa rencanamu hari ini?
Apa hobimu yang paling disukai?
Apa yang kamu makan untuk makan siang?


# List of bad words to test
bad_words = [
    "damn", "awful"
]

# Function to send a message
def send_message(message):
    input_box = driver.find_element(By.CSS_SELECTOR, '#message-form input[name="message"]')
    input_box.send_keys(message)
    send_button = driver.find_element(By.CSS_SELECTOR, '#message-form button[type="submit"]')
    send_button.click()

# Function to get a response
def get_response():
    while True:
        time.sleep(2)
        messages_elements = driver.find_elements(By.CSS_SELECTOR, '#messages .message.bot-message p')
        thinking_present = any(
            msg.text.lower() in ["thinking...", "thingking..."]
            for msg in messages_elements
        )
        if not thinking_present:
            if messages_elements:
                return messages_elements[-1].text

try:
     # Test bad words
    for bad_word in bad_words:
        bad_message = f"This is a test with a bad word: {bad_word}"
        send_message(bad_message)
        response = get_response()
        print(f"Sent (bad word test): {bad_message}")
        print(f"Received: {response}")
    # Perform conversation tests with diverse questions
    for _ in range(10):  # Generate 10 random conversations
        message, lang = random.choice(conversations)
        send_message(message)
        response = get_response()
        print(f"Sent ({lang}): {message}")
        print(f"Received ({lang}): {response}")

       

finally:
    driver.quit()
