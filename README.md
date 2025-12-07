# 🚀 Raspberry Pi Auto Tunnel: Jupyter + VS Code (No SSH Required)

This project provides a fully automated script to:

✅ Start **Jupyter Notebook**
✅ Start **VS Code Server (code-server)**
✅ Create **Cloudflare tunnels** for both services
✅ Email the generated access URLs automatically
✅ Run everything in the **background**, no SSH login required

Perfect for remote development, Jupyter experimentation, and coding securely from anywhere.

---

## 📦 Features

### 🌐 Cloudflare Auto Tunnel

No need for SSH or port forwarding. The script auto-creates free Cloudflare tunnels for:

* **Jupyter Notebook**
* **VS Code (code-server)**

### 📧 Email Notifications

You will receive an email with:

* Jupyter URL
* VS Code URL

This allows instant remote access.

### 🧠 Auto Start Jupyter Notebook

Automatically launches Jupyter Notebook if it’s not already running.

### 💻 Auto Start VS Code Server

Automatically launches `code-server` for browser-based VS Code.

### ⚙️ Uses Python Virtual Environment

Activates your specified Python venv before starting services.

### 📝 Full Logging

Logs are stored at:

* Cloudflared: `/home/pi/cloudflared.log`
* Jupyter: `/home/pi/jupyter.log`
* VS Code: `/home/pi/vscode.log`

---

## 📁 File Structure

```
auto_tunnel.sh
/home/pi/cloudflared.log
/home/pi/jupyter.log
/home/pi/vscode.log
```

---

## 🔧 Requirements

Make sure your Raspberry Pi has:

### 1️⃣ Cloudflared

Install via:

```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared
chmod +x cloudflared
sudo mv cloudflared /usr/local/bin/
```

### 2️⃣ VS Code Server

Install:

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

### 3️⃣ Yagmail (for sending email)

```bash
pip install yagmail
```

### 4️⃣ Gmail App Password

Create one from:

👉 [https://myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
(Use it in the script as `EMAIL_PASSWORD`)

---

## 🔧 How to Use

### 1️⃣ Clone the Repo / Save the Script

Save the provided script as:

```
auto_tunnel.sh
```

### 2️⃣ Make it Executable

```bash
chmod +x auto_tunnel.sh
```

### 3️⃣ Run It

```bash
./auto_tunnel.sh
```

### 4️⃣ Wait 10–15 seconds

You will receive an email with:

* Jupyter Notebook Cloudflare URL
* VS Code Cloudflare URL

---

## ✨ Optional: Auto Start at Boot

Enable script to run automatically at boot:

```bash
crontab -e
```

Add:

```
@reboot /home/pi/auto_tunnel.sh &
```

---

## 📝 Script Summary

The script performs the following steps:

1. Activates virtual environment
2. Starts Jupyter Notebook
3. Starts VS Code Server
4. Creates Cloudflare tunnels
5. Extracts the generated URLs
6. Sends email containing both URLs
7. Runs everything in the background

---

## 🔒 Security Warning

* Cloudflare `trycloudflare.com` URLs change every reboot
* Anyone with your URL can access Jupyter / VS Code
* Add passwords or tokens for extra security

To secure Jupyter:

```bash
jupyter notebook password
```

To secure code-server:

Edit `~/.config/code-server/config.yaml`:

```yaml
password: "yourpassword"
```

---


