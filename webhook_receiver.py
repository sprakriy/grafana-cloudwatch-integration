from flask import Flask, request, jsonify

app = Flask(__name__)

# This matches the "Payload URL" you put in GitHub (e.g., /github-webhook)
@app.route('/github-webhook', methods=['POST'])
def github_payload():
    # 1. Get the JSON from GitHub
    data = request.json
    
    # 2. Extract the commit message (GitHub puts it in a list)
    try:
        commit_info = data.get('commits', [{}])[0]
        message = commit_info.get('message', '')
        author = commit_info.get('author', {}).get('name', 'Unknown')
        
        print(f"\n--- New Webhook Received ---")
        print(f"Author: {author}")
        print(f"Message: {message}")

        # 3. Apply your "Prepend" Logic
        if message.startswith("DECOM-"):
            print("VALIDATION SUCCESS: Jira ID found. Proceeding with Audit.")
            return jsonify({"status": "Success", "action": "Triggering Audit"}), 200
        else:
            print("VALIDATION FAILED: Missing 'DECOM-' prepend.")
            return jsonify({"status": "Failed", "reason": "No Jira ID"}), 400
            
    except Exception as e:
        print(f"Error processing payload: {e}")
        return jsonify({"status": "Error"}), 500

if __name__ == '__main__':
    # Run on port 5000 to match your ngrok command
    app.run(host='0.0.0.0', port=6000)