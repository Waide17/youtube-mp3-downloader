# 📦 Installation Guide

Complete installation instructions for YouTube MP3 Queue Downloader.

---

## 📋 Table of Contents

- [System Requirements](#-system-requirements)
- [Windows Installation](#-windows-installation)
- [Linux Installation](#-linux-installation)
- [macOS Installation](#-macos-installation)
- [Manual Installation](#-manual-installation)
- [Troubleshooting](#-troubleshooting)
- [Updating](#-updating)
- [Uninstalling](#-uninstalling)

---

## 💻 System Requirements

### Minimum Requirements
- **OS**: Windows 10/11, Linux (Ubuntu 20.04+), macOS 10.15+
- **RAM**: 2 GB
- **Storage**: 500 MB free space
- **Internet**: Required for downloading

### Software Requirements
- **Python**: 3.8 or higher
- **pip**: Python package manager (included with Python)
- **FFmpeg**: Automatically installed by the script

---

## 🪟 Windows Installation

### Method 1: Automatic Installation (Recommended)

**Step 1: Download**
```
1. Download the latest release from GitHub
2. Extract the ZIP file to a folder
   Example: C:\Users\YourName\YouTubeMP3Downloader
```

**Step 2: Install**
```
1. Open the extracted folder
2. Double-click on: scripts/install.bat
3. Wait for installation (5-10 minutes)
4. Installation complete! ✅
```

**Step 3: Run**
```
1. Double-click on: scripts/start.bat
2. Browser opens automatically
3. Start downloading! 🎵
```

### Method 2: Manual Installation

**Step 1: Install Python**
```
1. Download Python from: https://www.python.org/downloads/
2. Run the installer
3. ✅ CHECK: "Add Python to PATH"
4. Click "Install Now"
5. Verify installation:
   - Open Command Prompt (cmd)
   - Type: python --version
   - Should show: Python 3.x.x
```

**Step 2: Install Dependencies**
```cmd
# Open Command Prompt in project folder
cd C:\path\to\youtube-mp3-downloader

# Install requirements
pip install -r requirements.txt

# Install FFmpeg for MP3 conversion
pip install yt-dlp[default]
```

**Step 3: Run Application**
```cmd
# Start the server
python src/app.py

# Open browser and go to:
# http://localhost:5000
```

### Method 3: Using Git

```cmd
# Install Git from: https://git-scm.com/download/win

# Clone repository
git clone https://github.com/yourusername/youtube-mp3-downloader.git
cd youtube-mp3-downloader

# Run installer
scripts\install.bat

# Start application
scripts\start.bat
```

---

## 🐧 Linux Installation

### Ubuntu/Debian

**Quick Install (Recommended)**
```bash
# Download and extract
wget https://github.com/yourusername/youtube-mp3-downloader/archive/main.zip
unzip main.zip
cd youtube-mp3-downloader-main

# Make scripts executable
chmod +x scripts/*.sh

# Install
./scripts/install.sh

# Run
./scripts/start.sh
```

**Manual Install**
```bash
# 1. Install Python and pip
sudo apt update
sudo apt install python3 python3-pip python3-venv

# 2. Clone repository
git clone https://github.com/yourusername/youtube-mp3-downloader.git
cd youtube-mp3-downloader

# 3. Create virtual environment
python3 -m venv venv
source venv/bin/activate

# 4. Install dependencies
pip install -r requirements.txt

# 5. Run application
python src/app.py
```

### Fedora/RHEL/CentOS

```bash
# Install Python
sudo dnf install python3 python3-pip

# Follow same steps as Ubuntu above
```

### Arch Linux

```bash
# Install Python
sudo pacman -S python python-pip

# Follow same steps as Ubuntu above
```

---

## 🍎 macOS Installation

### Method 1: Automatic (Recommended)

```bash
# Download and extract the project
curl -L https://github.com/yourusername/youtube-mp3-downloader/archive/main.zip -o youtube-mp3-downloader.zip
unzip youtube-mp3-downloader.zip
cd youtube-mp3-downloader-main

# Make scripts executable
chmod +x scripts/*.sh

# Install
./scripts/install.sh

# Run
./scripts/start.sh
```

### Method 2: Using Homebrew

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python
brew install python3

# Clone repository
git clone https://github.com/yourusername/youtube-mp3-downloader.git
cd youtube-mp3-downloader

# Install dependencies
pip3 install -r requirements.txt

# Run
python3 src/app.py
```

---

## 🛠️ Manual Installation (All Platforms)

### Step 1: Verify Python Installation

```bash
# Check Python version
python3 --version
# or
python --version

# Should show: Python 3.8.x or higher
```

If Python is not installed:
- **Windows**: Download from [python.org](https://www.python.org/downloads/)
- **Linux**: `sudo apt install python3` (Ubuntu/Debian)
- **macOS**: `brew install python3`

### Step 2: Download Project

**Option A: Git Clone**
```bash
git clone https://github.com/yourusername/youtube-mp3-downloader.git
cd youtube-mp3-downloader
```

**Option B: Download ZIP**
```
1. Go to: https://github.com/yourusername/youtube-mp3-downloader
2. Click: Code → Download ZIP
3. Extract ZIP file
4. Open terminal/cmd in extracted folder
```

### Step 3: Create Virtual Environment (Recommended)

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
# Windows:
venv\Scripts\activate

# Linux/Mac:
source venv/bin/activate
```

### Step 4: Install Dependencies

```bash
# Upgrade pip
pip install --upgrade pip

# Install requirements
pip install -r requirements.txt

# Install FFmpeg support (for MP3 conversion)
pip install yt-dlp[default]
```

### Step 5: Verify Installation

```bash
# Check if Flask is installed
python -c "import flask; print(flask.__version__)"

# Check if yt-dlp is installed
python -c "import yt_dlp; print(yt_dlp.version.__version__)"

# Check FFmpeg
ffmpeg -version
```

### Step 6: Run Application

```bash
# Start server
python src/app.py

# You should see:
# * Running on http://localhost:5000

# Open browser and navigate to:
# http://localhost:5000
```

---

## 🔧 Troubleshooting

### Python Not Found

**Problem**: `python: command not found`

**Solutions**:
```bash
# Try python3 instead
python3 --version

# Windows: Add Python to PATH
1. Search "Environment Variables"
2. Edit "Path" variable
3. Add: C:\Users\YourName\AppData\Local\Programs\Python\Python3x

# Linux/Mac: Install Python
# Ubuntu/Debian:
sudo apt install python3

# macOS:
brew install python3
```

### pip Not Found

**Problem**: `pip: command not found`

**Solutions**:
```bash
# Try pip3
pip3 --version

# Install pip
# Windows:
python -m ensurepip --upgrade

# Linux:
sudo apt install python3-pip

# macOS:
python3 -m ensurepip --upgrade
```

### Permission Denied (Linux/Mac)

**Problem**: `Permission denied` when running scripts

**Solution**:
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Or run with bash
bash scripts/install.sh
```

### Port 5000 Already in Use

**Problem**: `Address already in use: Port 5000`

**Solutions**:
```bash
# Option 1: Stop other process
# Windows:
netstat -ano | findstr :5000
taskkill /PID <PID_NUMBER> /F

# Linux/Mac:
lsof -ti:5000 | xargs kill -9

# Option 2: Use different port
# Edit src/app.py, last line:
app.run(debug=True, port=8080)  # Change to 8080
```

### FFmpeg Not Found

**Problem**: `ERROR: ffmpeg not found`

**Solutions**:
```bash
# Automatic (recommended)
pip install yt-dlp[default]

# Manual installation:
# Windows: Download from https://www.gyan.dev/ffmpeg/builds/
# Linux: sudo apt install ffmpeg
# macOS: brew install ffmpeg
```

### Video Unavailable Errors

**Problem**: Many videos fail with "Video unavailable"

**Solution**:
```bash
# Update yt-dlp to latest version
pip install --upgrade yt-dlp

# Clear yt-dlp cache
yt-dlp --rm-cache-dir
```

### SSL Certificate Errors

**Problem**: `SSL: CERTIFICATE_VERIFY_FAILED`

**Solutions**:
```bash
# Update certificates
pip install --upgrade certifi

# Windows: Install certificates
# Run: C:\Python3x\Install Certificates.command

# Linux: Update ca-certificates
sudo apt update
sudo apt install ca-certificates
```

---

## 🔄 Updating

### Update Application

```bash
# Using Git
cd youtube-mp3-downloader
git pull origin main

# Or download latest release
# Extract and replace files
```

### Update Dependencies

```bash
# Activate virtual environment (if using)
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# Update all packages
pip install --upgrade -r requirements.txt

# Update yt-dlp specifically
pip install --upgrade yt-dlp
```

---

## 🗑️ Uninstalling

### Complete Removal

```bash
# 1. Deactivate virtual environment (if active)
deactivate

# 2. Delete project folder
# Windows:
rmdir /s youtube-mp3-downloader

# Linux/Mac:
rm -rf youtube-mp3-downloader

# 3. (Optional) Uninstall Python packages
pip uninstall flask flask-cors yt-dlp -y
```

### Keep Downloaded Files

```bash
# Before deleting, backup downloads folder:
cp -r youtube-mp3-downloader/downloads ~/Music/YouTube_Downloads
```

---

## ✅ Post-Installation Checklist

After installation, verify everything works:

- [ ] Python installed and in PATH
- [ ] Dependencies installed (`pip list`)
- [ ] FFmpeg available (`ffmpeg -version`)
- [ ] Server starts without errors
- [ ] Browser opens at http://localhost:5000
- [ ] Can add URLs to queue
- [ ] Downloads work and save to `downloads/` folder

---

## 📞 Need Help?

- **Issues**: [GitHub Issues](https://github.com/yourusername/youtube-mp3-downloader/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/youtube-mp3-downloader/discussions)
- **Email**: your.email@example.com

---

**Next**: Read [USAGE.md](USAGE.md) to learn how to use the application!