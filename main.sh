#!/bin/bash
# =======================================================
# Raspberry Pi Auto Tunnel: Jupyter + VS Code (No SSH)
# =======================================================

# === USER SETTINGS ===
EMAIL_SENDER="sakibdalal73@gmail.com"
EMAIL_PASSWORD="vwmy kcbe btcy yebn"
EMAIL_RECEIVER="sakibdalal73@gmail.com"

VENV_PATH="/home/pi/base"
JUPYTER_PORT=8888
VSCODE_PORT=8080

LOG_FILE="/home/pi/cloudflared.log"
JUPYTER_LOG="/home/pi/jupyter.log"
VSCODE_LOG="/home/pi/vscode.log"

echo "🚀 Starting Raspberry Pi auto tunnel setup (Jupyter + VS Code)..."

# === Activate Python virtual environment ===
if [ -f "$VENV_PATH/bin/activate" ]; then
    source "$VENV_PATH/bin/activate"
else
    echo "⚠️ Python virtual environment not found at $VENV_PATH"
fi

# === Check & Start Jupyter ===
if pgrep -f "jupyter-notebook" > /dev/null; then
    echo "🧠 Jupyter Notebook already running. Skipping start..."
else
    echo "🧩 Starting Jupyter Notebook..."
    nohup jupyter notebook --ip=0.0.0.0 --port=$JUPYTER_PORT --notebook-dir=/home/pi --no-browser > $JUPYTER_LOG 2>&1 &
    sleep 5
fi

# === Check & Start VS Code (code-server) ===
if pgrep -f "code-server" > /dev/null; then
    echo "💻 VS Code server already running. Skipping start..."
else
    echo "💻 Starting VS Code server..."
    nohup code-server --bind-addr 0.0.0.0:$VSCODE_PORT > $VSCODE_LOG 2>&1 &
    sleep 8
fi

# === Start Cloudflare Tunnel for Jupyter ===
echo "🌐 Starting Cloudflare tunnel for Jupyter..."
nohup cloudflared tunnel --url http://localhost:$JUPYTER_PORT > $LOG_FILE 2>&1 &
sleep 8
JUPYTER_URL=$(grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' $LOG_FILE | tail -n 1)
if [ -z "$JUPYTER_URL" ]; then
    echo "❌ Jupyter tunnel URL not found!"
fi

# === Start Cloudflare Tunnel for VS Code ===
echo "💻 Starting Cloudflare tunnel for VS Code..."
nohup cloudflared tunnel --url http://localhost:$VSCODE_PORT >> $LOG_FILE 2>&1 &
sleep 8
VSCODE_URL=$(grep -o 'https://[a-zA-Z0-9.-]*\.trycloudflare\.com' $LOG_FILE | tail -n 1)
if [ -z "$VSCODE_URL" ]; then
    echo "❌ VS Code tunnel URL not found!"
fi

# === Send email with both URLs ===
echo "📧 Sending email with access links..."
python3 - <<EOF
import yagmail

EMAIL_SENDER = "$EMAIL_SENDER"
EMAIL_APP_PASSWORD = "$EMAIL_PASSWORD"
EMAIL_RECEIVER = "$EMAIL_RECEIVER"
JUPYTER_URL = "$JUPYTER_URL"
VSCODE_URL = "$VSCODE_URL"

body = f"""
Your Raspberry Pi is now remotely accessible!

🌐 **Jupyter Notebook**
{JUPYTER_URL}

💻 **VS Code Web**
{VSCODE_URL}

Enjoy coding securely via Cloudflare!
"""

try:
    yag = yagmail.SMTP(EMAIL_SENDER, EMAIL_APP_PASSWORD)
    yag.send(to=EMAIL_RECEIVER, subject="Raspberry Pi Cloudflare Tunnel Links", contents=body)
    print("📩 Email sent successfully!")
except Exception as e:
    print(f"⚠️ Failed to send email: {e}")
EOF

echo "✅ All done! Tunnels for Jupyter and VS Code are live in background."
echo "📝 Logs: $LOG_FILE"


