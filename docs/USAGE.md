# 📖 Usage Guide

Complete guide on how to use YouTube MP3 Queue Downloader.

---

## 📋 Table of Contents

- [Getting Started](#-getting-started)
- [Basic Usage](#-basic-usage)
- [Advanced Features](#-advanced-features)
- [Queue Management](#-queue-management)
- [Tips & Tricks](#-tips--tricks)
- [FAQ](#-faq)
- [Troubleshooting](#-troubleshooting)

---

## 🚀 Getting Started

### Starting the Application

**Windows**:
```
Double-click: scripts/start.bat
```

**Linux/Mac**:
```bash
./scripts/start.sh
```

**Manual**:
```bash
python src/app.py
```

The application will:
1. Start the server on `http://localhost:5000`
2. Automatically open your default browser
3. Display the main interface

### Stopping the Application

**Windows**:
- Close the "YouTube MP3 Downloader - Server" window
- Or run: `scripts/stop.bat`

**Linux/Mac**:
- Press `Ctrl+C` in the terminal
- Or close the terminal window

---

## 📝 Basic Usage

### Downloading a Single Video

**Step 1**: Copy YouTube URL
```
Example: https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

**Step 2**: Paste in Input Field
- Click in the text area
- Paste the URL (Ctrl+V or Cmd+V)

**Step 3**: Add to Queue
- Click the **"➕ Add to Queue"** button
- You'll see: "✓ 1 video added to queue!"

**Step 4**: Start Download
- Click the **"▶️ Start Download"** button
- Watch the progress in real-time

**Step 5**: File Downloads Automatically
- The MP3 file downloads to your browser automatically!
- Default name: `[Video Title].mp3`
- Quality: 192kbps

### Downloading Multiple Videos

**Step 1**: Paste Multiple URLs (one per line)
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ
https://www.youtube.com/watch?v=9bZkp7q19f0
https://www.youtube.com/watch?v=kJQP7kiw5Fk
```

**Step 2**: Add All at Once
- Click **"➕ Add to Queue"**
- All videos are added simultaneously

**Step 3**: Start Download
- Click **"▶️ Start Download"**
- Videos download **sequentially** (one after another)

**Step 4**: Files Auto-Download
- Each MP3 downloads automatically when ready
- No need to click anything!

---

## 🎬 Advanced Features

### Downloading Entire Playlists

**YouTube Playlist URLs**:
```
https://www.youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf
```

**Or video with playlist**:
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=PLxxxxxx
```

**How it works**:
1. Paste the playlist URL
2. Click "Add to Queue"
3. System **automatically extracts** all videos from playlist
4. All videos added to queue (could be 10, 50, 100+ videos!)
5. Click "Start Download"
6. All videos download sequentially in MP3 format

**Example**:
```
Playlist with 50 videos →
System extracts all 50 URLs →
Adds all to queue →
Downloads all as MP3 automatically!
```

### Mixing Videos and Playlists

You can add everything together:
```
https://www.youtube.com/watch?v=xxxxx           ← Single video
https://www.youtube.com/playlist?list=yyyyy     ← Entire playlist
https://www.youtube.com/watch?v=zzzzz           ← Another video
https://www.youtube.com/playlist?list=wwwww     ← Another playlist
```

All will be processed and added to queue!

---

## 📊 Queue Management

### Understanding the Interface

The interface shows **4 main sections**:

#### 1. **Statistics**
```
┌─────────────┬──────────────┬──────────────┬─────────────┐
│  In Queue   │ In Download  │  Completed   │   Failed    │
│     12      │      1       │      5       │      0      │
└─────────────┴──────────────┴──────────────┴─────────────┘
```

- **In Queue**: Videos waiting to be downloaded
- **In Download**: Currently downloading (0 or 1)
- **Completed**: Successfully downloaded MP3s
- **Failed**: Videos that had errors

#### 2. **Current Download**
Shows the video being downloaded right now:
```
⚡ [Current Title] - Downloading...
   https://youtube.com/watch?v=xxxxx
```

#### 3. **Queue List**
Shows videos waiting to be downloaded:
```
⏳ Video Title 1
⏳ Video Title 2
⏳ Video Title 3
```

#### 4. **Completed List**
Shows successfully downloaded videos:
```
✅ Video Title A
   🔄 Re-download (button)
```

### Queue Controls

**Start Download** (`▶️`)
- Begins processing the queue
- Downloads videos one by one
- Disabled when queue is empty

**Stop** (`⏸️`)
- Pauses the download queue
- Current download continues
- Can resume later

**Clear Queue** (`🗑️`)
- Removes all pending videos
- Does NOT delete completed downloads
- Requires confirmation

---

## 💡 Tips & Tricks

### 1. Batch Downloading

For maximum efficiency:
```
1. Collect all URLs first (in a text file)
2. Paste all at once
3. Add to queue
4. Start download
5. Let it run overnight if needed!
```

### 2. Playlist Organization

Download entire albums or compilations:
```
Example: "Lo-fi Hip Hop Mix - Complete Playlist"
1. Find playlist on YouTube
2. Copy playlist URL
3. Paste and add to queue
4. Get entire album as individual MP3s!
```

### 3. Quality Control

The default quality is **192kbps** (high quality). This is a good balance between:
- File size (~3-5 MB per song)
- Audio quality (very good)
- Download speed (fast)

To change quality, edit `src/app.py`:
```python
'preferredquality': '192',  # Options: '128', '192', '256', '320'
```

### 4. Keyboard Shortcuts

- **Paste URL**: `Ctrl+V` (Windows/Linux) or `Cmd+V` (Mac)
- **Add to Queue**: `Enter` (when in text field)
- **Select All Text**: `Ctrl+A` or `Cmd+A`

### 5. Organizing Downloads

Downloads go to your browser's download folder by default:
- **Windows**: `C:\Users\YourName\Downloads\`
- **Mac**: `/Users/YourName/Downloads/`
- **Linux**: `/home/yourname/Downloads/`

Create folders to organize:
```
Downloads/
├── Music/
│   ├── Rock/
│   ├── Jazz/
│   └── Classical/
└── Podcasts/
```

### 6. Handling Long Queues

For 50+ videos:
- Start download before leaving
- Let it run in background
- Check back later
- All files will be in Downloads folder

### 7. Re-downloading

If a download was interrupted:
- Check "Completed" section
- If there, use "🔄 Re-download" button
- If not there, add URL again

---

## ❓ FAQ

### Q: How many videos can I download at once?
**A**: No hard limit! Tested with 100+ videos successfully. However, YouTube may rate-limit you if downloading too aggressively.

### Q: Can I close the browser while downloading?
**A**: Yes! The downloads continue in the background. Just don't close the server window.

### Q: Where are the files saved?
**A**: Files download directly to your browser's default download location (usually `Downloads` folder).

### Q: What's the file quality?
**A**: 192kbps MP3 by default. This is high quality and suitable for most uses.

### Q: Can I download videos instead of MP3?
**A**: Currently only MP3 (audio) is supported. This is by design for simplicity.

### Q: How do I download age-restricted videos?
**A**: Update yt-dlp: `pip install --upgrade yt-dlp`. This usually resolves age-restriction issues.

### Q: Can I download from other sites (not YouTube)?
**A**: Currently only YouTube is supported. yt-dlp supports other sites, but the UI is designed for YouTube.

### Q: What if a video fails to download?
**A**: The queue continues! Failed videos appear in the "Failed" section with error details. You can retry them later.

### Q: Can multiple people use this at once?
**A**: No, it's designed for single-user local use. Each person should run their own instance.

### Q: Is there a file size limit?
**A**: No hard limit, but very long videos (3+ hours) may take time to convert to MP3.

---

## 🐛 Common Issues

### "Video unavailable"

**Cause**: Video is private, deleted, or geo-blocked

**Solutions**:
1. Check if video is accessible in browser
2. Try a different video
3. Update yt-dlp: `pip install --upgrade yt-dlp`

### "Sign in to confirm you're not a bot"

**Cause**: YouTube's anti-bot detection

**Solutions**:
1. Update yt-dlp: `pip install --upgrade yt-dlp`
2. Wait a few minutes before trying again
3. Try fewer videos at once

### Downloads are slow

**Cause**: Internet speed or YouTube throttling

**Tips**:
- This is normal, YouTube limits download speeds
- Average: 1-2 videos per minute
- Patience is key for large queues!

### FFmpeg errors

**Cause**: FFmpeg not properly installed

**Solution**:
```bash
pip install --upgrade yt-dlp[default]
```

### Browser doesn't open automatically

**Solution**:
Manually open browser and go to: `http://localhost:5000`

### Port 5000 in use

**Solution**:
```bash
# Stop existing instance
# Windows: scripts/stop.bat
# Linux/Mac: killall python

# Or change port in src/app.py
```

---

## 📊 Best Practices

### DO ✅

- Start with a few videos to test
- Use playlists for batch downloads
- Keep yt-dlp updated
- Let long queues run overnight
- Organize downloads into folders

### DON'T ❌

- Download copyrighted content without permission
- Download 1000+ videos at once (rate limiting)
- Close the server window during downloads
- Use on public/shared computers (privacy)
- Distribute downloaded content

---

## 🎯 Use Cases

### Personal Music Library
```
1. Find your favorite artists' official channels
2. Copy playlist URLs
3. Download entire discographies
4. Organize by artist/album
```

### Podcast Archiving
```
1. Find podcast episodes on YouTube
2. Add all episodes to queue
3. Download for offline listening
4. Sync to phone/MP3 player
```

### Study Materials
```
1. Educational video playlists
2. Lecture series
3. Language learning audio
4. Convert to audio for commute listening
```

### Workout Mixes
```
1. Fitness/workout playlists
2. Motivational speeches
3. Running music compilations
4. Create custom workout MP3s
```

---

## 🔗 Related Resources

- [Installation Guide](INSTALL.md) - How to install
- [README](README.md) - Project overview
- [GitHub Issues](https://github.com/Waide17/youtube-mp3-downloader/issues) - Report bugs
- [yt-dlp Documentation](https://github.com/yt-dlp/yt-dlp) - Advanced options

---

## 📞 Support

Need help? Found a bug?

- **GitHub Issues**: [Report here](https://github.com/Waide17/youtube-mp3-downloader/issues)
- **Discussions**: [Ask questions](https://github.com/Waide17/youtube-mp3-downloader/discussions)

---

**Enjoy downloading!** 🎵🎶🎧