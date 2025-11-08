import requests
import subprocess
import time
from bs4 import BeautifulSoup
import urllib3
import json
import os
import getpass  # For securely hiding password input

# --- Disable SSL Warnings ---
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# --- Config File Setup ---
CONFIG_FILE = 'config.json'

def load_credentials():
    """
    Loads credentials from config.json. If it doesn't exist,
    prompts the user and creates the file.
    """
    if os.path.exists(CONFIG_FILE):
        # Config file exists, load it
        print("Loading saved credentials from config.json...")
        with open(CONFIG_FILE, 'r') as f:
            config = json.load(f)
        return config['USERNAME'], config['PASSWORD']
    else:
        # First run, get credentials from user
        print("--- First Time Setup ---")
        print("Please enter your login details. They will be saved securely.")
        username = input("Enter Username: ")
        password = getpass.getpass("Enter Password (will be hidden): ")

        # Save credentials to config.json for next time
        config_data = {
            'USERNAME': username,
            'PASSWORD': password
        }
        with open(CONFIG_FILE, 'w') as f:
            json.dump(config_data, f, indent=4)
        
        print(f"Credentials saved to {CONFIG_FILE}. You won't be asked again.")
        return username, password

# --- Wi-Fi Setup ---
WIFI_NAME = "BOH"  # Your saved Wi-Fi name

def is_wifi_connected():
    result = subprocess.run(['netsh', 'wlan', 'show', 'interfaces'], capture_output=True, text=True, shell=True)
    return WIFI_NAME in result.stdout and "State" in result.stdout and "connected" in result.stdout.lower()

def connect_to_wifi():
    print(f"🔌 Connecting to Wi-Fi: {WIFI_NAME}")
    subprocess.run(["netsh", "wlan", "connect", f"name={WIFI_NAME}"], shell=True)
    time.sleep(5)

# --- Load Credentials ---
# This will either load from the file or ask the user if it's the first time.
USERNAME, PASSWORD = load_credentials()

# --- Login Logic ---
LOGIN_URL = "https://192.168.30.8:9998/SubscriberPortal/"
# SCRIPT BY RAMEEZ (COPYRIGHT 2025)

session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
})

def perform_login():
    try:
        print(f"Connecting to {LOGIN_URL}...")
        # Use verify=False to ignore SSL certificate errors
        response_get = session.get(LOGIN_URL, verify=False, timeout=10)
        response_get.raise_for_status()

        print("Successfully fetched the login page.")
        
        soup = BeautifulSoup(response_get.text, 'html.parser')
        
        payload = {
            'UE-Username': USERNAME,
            'UE-Password': PASSWORD,
        }
        
        login_form = soup.find('form', {'name': 'loginForm'})
        
        if not login_form:
            print("Error: Could not find the login form on the page.")
            return

        print("Found login form. Extracting hidden tokens...")
        hidden_inputs = login_form.find_all('input', {'type': 'hidden'})

        for input_tag in hidden_inputs:
            name = input_tag.get('name')
            value = input_tag.get('value')
            if name and value:
                print(f"Found hidden field: {name} = {value}")
                payload[name] = value

        # SCRIPT BY RAMEEZ (COPYRIGHT 2025)
        if 'LoginFromForm' not in payload:
            print("Warning: Could not find a 'LoginFromForm' token.")
            print("The login will likely fail, but attempting anyway...")
        
        print("\nSending POST request to log in...")
        response_post = session.post(LOGIN_URL, data=payload, verify=False, timeout=10)
        response_post.raise_for_status()

        if "Login successful" in response_post.text or "Welcome" in response_post.text:
            print("Login successful!")
            return 1
        
        elif "Login failed. Please check your login password, and then try again." in response_post.text:
            print("Login failed: Invalid username or password.")
            return -1
        
        else:
            print("Login submitted, but the outcome is unknown.\n retrying...")
            return 0

    # SCRIPT BY RAMEEZ (COPYRIGHT 2025)
    except requests.exceptions.HTTPError as errh:
        print(f"Http Error: {errh}")
    except requests.exceptions.ConnectionError as errc:
        print(f"Error Connecting: {errc}")
    except requests.exceptions.Timeout as errt:
        print(f"Timeout Error: {errt}")
    except requests.exceptions.RequestException as err:
        print(f"An unexpected error occurred: {err}")

# SCRIPT BY RAMEEZ (COPYRIGHT 2025)
if __name__ == "__main__":
    if not is_wifi_connected():
        connect_to_wifi()
    else:
        print("📶 Wi-Fi already connected.")
    
    if(perform_login() == 0):
        perform_login()