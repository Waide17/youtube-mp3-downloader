from flask import Flask, request, jsonify, send_file, send_from_directory
from flask_cors import CORS
from yt_dlp import YoutubeDL
import os
import threading
from queue import Queue
import time

app = Flask(__name__, static_folder='.')
CORS(app)

# Coda globale per i download
download_queue = Queue()
queue_status = {
    'current': None,
    'completed': [],
    'failed': [],
    'queue': [],
    'is_processing': False
}
queue_lock = threading.Lock()

# Serve index.html
@app.route('/')
def home():
    return send_from_directory('.', 'index.html')

# Serve file statici
@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory('.', path)

# Endpoint per ottenere info video (veloce)
@app.route('/api/info', methods=['POST'])
def get_info():
    data = request.json
    url = data.get('url')
    
    if not url:
        return jsonify({'success': False, 'error': 'URL non valido'})
    
    try:
        ydl_opts = {
            'quiet': True,
            'no_warnings': True,
            'skip_download': True
        }
        
        with YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=False)
            
            return jsonify({
                'success': True,
                'title': info['title'],
                'thumbnail': info['thumbnail'],
                'duration': info['duration'],
                'uploader': info.get('uploader', 'Unknown')
            })
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

# Aggiungi URL alla coda
@app.route('/api/queue/add', methods=['POST'])
def add_to_queue():
    data = request.json
    urls = data.get('urls', [])
    
    if not urls:
        return jsonify({'success': False, 'error': 'Nessun URL fornito'})
    
    added = []
    errors = []
    
    with queue_lock:
        for url in urls:
            url = url.strip()
            if not url:
                continue
            
            # Controlla se è una playlist
            if 'playlist' in url or 'list=' in url:
                try:
                    print(f"[INFO] Rilevata playlist: {url}")
                    playlist_videos = extract_playlist_urls(url)
                    
                    if playlist_videos:
                        print(f"[INFO] Trovati {len(playlist_videos)} video nella playlist")
                        for video_url, video_title in playlist_videos:
                            # Verifica se è già in coda
                            if any(item['url'] == video_url for item in queue_status['queue']):
                                continue
                            
                            item = {
                                'url': video_url,
                                'title': video_title,
                                'status': 'pending',
                                'added_at': time.time()
                            }
                            queue_status['queue'].append(item)
                            download_queue.put(item)
                            added.append(video_url)
                    else:
                        errors.append(f'{url}: Impossibile estrarre video dalla playlist')
                        
                except Exception as e:
                    errors.append(f'{url}: Errore playlist - {str(e)}')
                    print(f"[ERROR] Errore estrazione playlist: {e}")
            else:
                # Video singolo
                # Verifica se è già in coda
                if any(item['url'] == url for item in queue_status['queue']):
                    errors.append(f'{url}: Già in coda')
                    continue
                
                # Aggiungi alla coda
                item = {
                    'url': url,
                    'title': 'In attesa...',
                    'status': 'pending',
                    'added_at': time.time()
                }
                queue_status['queue'].append(item)
                download_queue.put(item)
                added.append(url)
    
    return jsonify({
        'success': True,
        'added': len(added),
        'errors': errors,
        'queue_size': download_queue.qsize()
    })

# Ottieni stato della coda
@app.route('/api/queue/status', methods=['GET'])
def get_queue_status():
    with queue_lock:
        return jsonify({
            'current': queue_status['current'],
            'queue': queue_status['queue'],
            'completed': queue_status['completed'][-10:],  # Ultimi 10
            'failed': queue_status['failed'][-10:],  # Ultimi 10
            'is_processing': queue_status['is_processing'],
            'queue_size': download_queue.qsize()
        })

# Avvia processamento coda
@app.route('/api/queue/start', methods=['POST'])
def start_queue():
    with queue_lock:
        if queue_status['is_processing']:
            return jsonify({'success': False, 'error': 'Coda già in elaborazione'})
        
        if download_queue.empty():
            return jsonify({'success': False, 'error': 'Coda vuota'})
        
        queue_status['is_processing'] = True
    
    # Avvia thread per processare la coda
    thread = threading.Thread(target=process_queue, daemon=True)
    thread.start()
    
    return jsonify({'success': True, 'message': 'Elaborazione coda avviata'})

# Ferma processamento coda
@app.route('/api/queue/stop', methods=['POST'])
def stop_queue():
    with queue_lock:
        queue_status['is_processing'] = False
    return jsonify({'success': True, 'message': 'Coda fermata'})

# Pulisci coda
@app.route('/api/queue/clear', methods=['POST'])
def clear_queue():
    with queue_lock:
        # Svuota la coda
        while not download_queue.empty():
            try:
                download_queue.get_nowait()
            except:
                break
        
        queue_status['queue'] = []
        queue_status['current'] = None
    
    return jsonify({'success': True, 'message': 'Coda pulita'})

# Funzione per estrarre URL da playlist
def extract_playlist_urls(playlist_url):
    try:
        ydl_opts = {
            'quiet': True,
            'no_warnings': True,
            'extract_flat': True,  # Non scarica, solo estrae info
            'skip_download': True
        }
        
        with YoutubeDL(ydl_opts) as ydl:
            playlist_info = ydl.extract_info(playlist_url, download=False)
            
            if 'entries' not in playlist_info:
                return []
            
            videos = []
            for entry in playlist_info['entries']:
                if entry:
                    video_url = f"https://www.youtube.com/watch?v={entry['id']}"
                    video_title = entry.get('title', 'Video senza titolo')
                    videos.append((video_url, video_title))
            
            return videos
            
    except Exception as e:
        print(f"[ERROR] Errore estrazione playlist: {e}")
        return []

# Funzione che processa la coda in background
def process_queue():
    while True:
        with queue_lock:
            if not queue_status['is_processing']:
                break
            
            if download_queue.empty():
                queue_status['is_processing'] = False
                break
        
        try:
            # Prendi prossimo item
            item = download_queue.get(timeout=1)
            
            with queue_lock:
                queue_status['current'] = item
                # Rimuovi da queue list
                queue_status['queue'] = [i for i in queue_status['queue'] if i['url'] != item['url']]
            
            # Scarica MP3
            result = download_mp3(item['url'])
            
            with queue_lock:
                if result['success']:
                    item['status'] = 'completed'
                    item['filename'] = result['filename']
                    item['title'] = result['title']
                    queue_status['completed'].append(item)
                else:
                    item['status'] = 'failed'
                    item['error'] = result['error']
                    queue_status['failed'].append(item)
                
                queue_status['current'] = None
            
            download_queue.task_done()
            time.sleep(0.5)  # Piccola pausa tra download
            
        except Exception as e:
            print(f"Errore processamento coda: {e}")
            continue

# Funzione helper per scaricare MP3
def download_mp3(url):
    try:
        print(f"[INFO] Inizio download: {url}")
        os.makedirs('downloads', exist_ok=True)
        
        ydl_opts = {
            'format': 'bestaudio/best',
            'outtmpl': 'downloads/%(title)s.%(ext)s',
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '192',
            }],
            'quiet': False,
            'no_warnings': False,
            'verbose': True,
            # Opzioni per bypassare restrizioni
            'age_limit': None,
            'geo_bypass': True,
            'nocheckcertificate': True,
            # User agent per evitare blocchi
            'http_headers': {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
            }
        }
        
        with YoutubeDL(ydl_opts) as ydl:
            print(f"[INFO] Estrazione info...")
            info = ydl.extract_info(url, download=True)
            filename = ydl.prepare_filename(info)
            base = os.path.splitext(filename)[0]
            filename = base + '.mp3'
            
            print(f"[SUCCESS] Download completato: {filename}")
        
        return {
            'success': True,
            'filename': os.path.basename(filename),
            'title': info['title']
        }
        
    except Exception as e:
        error_msg = str(e)
        print(f"[ERROR] Errore download {url}: {error_msg}")
        
        # Messaggi di errore più friendly
        if 'Video unavailable' in error_msg:
            error_msg = 'Video non disponibile. Potrebbe essere privato, con restrizioni geografiche o rimosso.'
        elif 'Sign in' in error_msg or 'age' in error_msg.lower():
            error_msg = 'Video con restrizioni di età. Aggiorna yt-dlp con: pip install --upgrade yt-dlp'
        elif 'HTTP Error 429' in error_msg:
            error_msg = 'Troppi download. Attendi qualche minuto e riprova.'
        
        import traceback
        traceback.print_exc()
        
        return {
            'success': False,
            'error': error_msg
        }

# Endpoint per scaricare file completati
@app.route('/api/download/<path:filename>')
def download_file(filename):
    filepath = os.path.join('downloads', filename)
    if os.path.exists(filepath):
        return send_file(filepath, as_attachment=True)
    return jsonify({'error': 'File non trovato'}), 404

# Endpoint per scaricare tutti i file completati come ZIP
@app.route('/api/download-all', methods=['GET'])
def download_all():
    try:
        import zipfile
        from io import BytesIO
        
        memory_file = BytesIO()
        
        with zipfile.ZipFile(memory_file, 'w', zipfile.ZIP_DEFLATED) as zf:
            downloads_dir = 'downloads'
            if os.path.exists(downloads_dir):
                for filename in os.listdir(downloads_dir):
                    if filename.endswith('.mp3'):
                        filepath = os.path.join(downloads_dir, filename)
                        zf.write(filepath, filename)
        
        memory_file.seek(0)
        return send_file(
            memory_file,
            mimetype='application/zip',
            as_attachment=True,
            download_name='youtube_mp3_downloads.zip'
        )
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Pulisci file scaricati
@app.route('/api/cleanup', methods=['POST'])
def cleanup():
    try:
        if os.path.exists('downloads'):
            for file in os.listdir('downloads'):
                os.remove(os.path.join('downloads', file))
        
        with queue_lock:
            queue_status['completed'] = []
            queue_status['failed'] = []
        
        return jsonify({'success': True, 'message': 'File eliminati'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    print('═══════════════════════════════════════')
    print('🚀 YouTube MP3 Downloader - Queue System')
    print('═══════════════════════════════════════')
    print('✓ Server: http://localhost:5000')
    print('✓ Modalità: Download in coda MP3')
    print('═══════════════════════════════════════')
    app.run(debug=True, port=5000, host='0.0.0.0', threaded=True)