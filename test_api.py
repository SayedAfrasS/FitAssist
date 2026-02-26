import requests

url = "http://127.0.0.1:5000/chat"

data = {
    "message": "How to build chest muscle?",
    "goal": "Build Muscle",
    "activityLevel": "Moderate",
    "weeklyDays": 4
}

response = requests.post(url, json=data, timeout=30)

print("Status Code:", response.status_code)
print("Raw Response:", response.text)