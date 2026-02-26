import os
import requests
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

# Load environment variables
load_dotenv(override=True)

# Configure Application
app = Flask(__name__)
CORS(app)

@app.route("/chat", methods=["POST"])
def chat():
    # Priority: GROQ key first, then fallback to GROK (xAI)
    actual_key = os.getenv("GROQ_API_KEY") or os.getenv("GROK_API_KEY")

    if not actual_key or len(actual_key) < 10:
        return jsonify({"reply": "Backend Error: API Key missing in .env"}), 500

    data = request.json
    user_message = data.get("message", "")
    goal = data.get("goal", "Fitness")
    activity = data.get("activityLevel", "Moderate")
    weekly_days = data.get("weeklyDays", 3)

    # Safety Filter
    blocked_words = ["medicine", "steroids", "prescription", "heart pain", "injury"]
    if any(word in user_message.lower() for word in blocked_words):
        return jsonify({"reply": "For medical concerns, please consult a healthcare professional."})

    # Determine Provider based on Key Prefix
    if actual_key.startswith("gsk_"):
        # Groq Cloud (FREE - uses Llama 3)
        url = "https://api.groq.com/openai/v1/chat/completions"
        model = "llama-3.3-70b-versatile"
        print(f"DEBUG: Using GROQ (Llama 3 70B)")
    elif actual_key.startswith("xai-"):
        # xAI Grok (Paid)
        url = "https://api.x.ai/v1/chat/completions"
        model = "grok-2"
        print(f"DEBUG: Using xAI (Grok)")
    else:
        return jsonify({"reply": "Backend Error: Unknown API key format. Must start with gsk_ (Groq) or xai- (Grok)."}), 500

    headers = {
        "Authorization": f"Bearer {actual_key}",
        "Content-Type": "application/json"
    }

    system_prompt = (
        "You are a certified professional fitness coach. "
        "Only answer questions related to fitness, workouts, muscle building, fat loss, and basic nutrition. "
        "Do not provide medical advice. Be concise, motivating, and science-based."
    )

    user_context = (
        f"User Profile: Goal={goal}, Activity Level={activity}, Training {weekly_days} days/week.\n\n"
        f"Question: {user_message}"
    )

    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_context}
        ],
        "temperature": 0.7,
        "max_tokens": 1024
    }

    try:
        response = requests.post(url, headers=headers, json=payload, timeout=20)

        if response.status_code == 200:
            result = response.json()
            reply = result["choices"][0]["message"]["content"]
            return jsonify({"reply": reply})
        else:
            try:
                error_data = response.json()
                if isinstance(error_data, dict) and "error" in error_data:
                    error_msg = error_data["error"].get("message", response.text)
                else:
                    error_msg = response.text
            except:
                error_msg = response.text
            print(f"API ERROR ({response.status_code}): {error_msg}")
            return jsonify({"reply": f"AI Engine Error ({response.status_code}): {error_msg}"}), response.status_code

    except requests.exceptions.Timeout:
        return jsonify({"reply": "The AI took too long to respond. Please try again."}), 504
    except Exception as e:
        print(f"INTERNAL ERROR: {str(e)}")
        return jsonify({"reply": f"Internal Error: {str(e)}"}), 500

if __name__ == "__main__":
    print(f"Starting FitAssist Backend...")
    key = os.getenv("GROQ_API_KEY") or os.getenv("GROK_API_KEY")
    if key:
        prefix = "GROQ" if key.startswith("gsk_") else "xAI"
        print(f"API Provider: {prefix} | Key: {key[:8]}...")
    else:
        print("WARNING: No API key found!")
    app.run(host="0.0.0.0", port=5000, debug=True)