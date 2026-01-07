# 🎵 YouTube MP3 Queue Downloader

<div align="center">

![Python](https://img.shields.io/badge/python-3.8+-blue.svg)
![Flask](https://img.shields.io/badge/flask-3.0+-green.svg)
![License](https://img.shields.io/badge/license-MIT-purple.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20Mac-lightgrey.svg)

**Download YouTube videos as MP3 with an intelligent queue system**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage)

</div>

---

## ✨ Features

- 🎵 **High-Quality MP3** - Convert videos to 192kbps MP3
- 📋 **Queue System** - Add multiple videos and download in sequence
- 🎬 **Playlist Support** - Extract and download entire YouTube playlists
- ⚡ **Auto-Download** - Files download automatically as soon as they're ready
- 📊 **Real-Time Monitoring** - Track download progress live
- 🔄 **Smart Retry** - Automatically retry failed downloads
- 🎯 **No Duplicates** - Prevents adding the same video twice
- 💾 **Lightweight** - Runs locally on your machine

## 🚀 Quick Start

### Windows

1. **Download** the repository
2. **Extract** the ZIP file
3. **Run** `scripts/install.bat` (first time only)
4. **Run** `scripts/start.bat`
5. Browser opens automatically at `http://localhost:5000`

### Linux / macOS

```bash
# Clone the repository
git clone https://github.com/Waide17/youtube-mp3-downloader.git
cd youtube-mp3-downloader

# First time setup
chmod +x scripts/*.sh
./scripts/install.sh

# Run the application
./scripts/start.sh
```

## 📋 Manual Installation

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- FFmpeg (installed automatically)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/Waide17/youtube-mp3-downloader.git
cd youtube-mp3-downloader

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Run the server
python src/app.py

# 4. Open your browser
# Navigate to: http://localhost:5000
```

## 📖 Usage

### Single Videos

```
1. Paste a YouTube URL in the input field
   Example: https://www.youtube.com/watch?v=dQw4w9WgXcQ

2. Click "Add to Queue"

3. Click "Start Download"

4. File downloads automatically!
```

### Playlists

```
1. Paste a playlist URL
   Example: https://www.youtube.com/playlist?list=PLxxxxx

2. Click "Add to Queue"
   → All videos are automatically extracted

3. Click "Start Download"

4. All videos download sequentially!
```

### Multiple Videos

```
Paste multiple URLs (one per line):
https://www.youtube.com/watch?v=xxxxx
https://www.youtube.com/watch?v=yyyyy
https://www.youtube.com/playlist?list=zzzzz

Click "Add to Queue" → All added at once!
```

## 🔧 Configuration

### Change MP3 Quality

Edit `src/app.py`, line ~180:

```python
'preferredquality': '192',  # Change to '128', '256', or '320'
```

### Change Server Port

Edit `src/app.py`, last line:

```python
app.run(debug=True, port=5000)  # Change 5000 to your preferred port
```

## 📂 Project Structure

```
youtube-mp3-downloader/
├── src/
│   ├── app.py              # Main Flask server
│   └── templates/
│       └── index.html      # Frontend interface
├── scripts/
│   ├── install.bat         # Windows installer
│   ├── start.bat           # Windows launcher
│   ├── install.sh          # Linux/Mac installer
│   └── start.sh            # Linux/Mac launcher
├── docs/
│   └── screenshots/        # Application screenshots
├── downloads/              # Downloaded MP3 files (auto-created)
├── requirements.txt        # Python dependencies
├── .gitignore
├── LICENSE
└── README.md
```

## 🔒 Privacy & Security

- ✅ **Runs locally** - No data sent to external servers
- ✅ **No tracking** - No analytics or telemetry
- ✅ **Open source** - Review the code yourself
- ✅ **No ads** - Completely free

## ⚠️ Legal Disclaimer

This tool is intended for **personal use only**. Users are responsible for complying with:

- YouTube's Terms of Service
- Copyright laws in their jurisdiction
- Content creators' rights

**Only download content you have permission to download.**

## 🐛 Troubleshooting

### "Video unavailable"
- Video might be private, age-restricted, or geo-blocked
- Solution: Update yt-dlp with `pip install --upgrade yt-dlp`

### "FFmpeg not found"
- Solution: Run `pip install yt-dlp[default]`

### "Port 5000 already in use"
- Solution: Run `scripts/stop.bat` (Windows) or kill the process
- Or change the port in `src/app.py`

### Downloads are slow
- This depends on your internet connection
- YouTube throttles download speeds

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) - YouTube downloader
- [Flask](https://flask.palletsprojects.com/) - Web framework
- [FFmpeg](https://ffmpeg.org/) - Audio conversion

## 📧 Contact

Created by [@Waide17](https://github.com/Waide17)

Found a bug? [Open an issue](https://github.com/Waide17/youtube-mp3-downloader/issues)

---

<div align="center">
Made with ❤️ and Python
</div>