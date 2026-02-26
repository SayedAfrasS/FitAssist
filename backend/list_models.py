import requests
from dotenv import load_dotenv
import os

load_dotenv()
API_KEY = os.getenv("GROK_API_KEY")

print(f"DEBUG: Using Key Prefix: {str(API_KEY)[:4]}...")

url = "https://api.x.ai/v1/models"
headers = {"Authorization": f"Bearer {API_KEY}"}

try:
    response = requests.get(url, headers=headers)
    print("STATUS:", response.status_code)
    print("BODY:", response.text)
except Exception as e:
    print("ERROR:", str(e))
