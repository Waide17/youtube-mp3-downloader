        const API_BASE = 'http://localhost:5000/api';
        let updateInterval;
        let downloadedFiles = new Set(); // Tiene traccia dei file già scaricati

        function showStatus(message, type) {
            const status = document.getElementById('status');
            status.textContent = message;
            status.className = `status ${type} show`;
            setTimeout(() => status.classList.remove('show'), 5000);
        }

        async function addToQueue() {
            const input = document.getElementById('urlInput').value;
            const urls = input.split('\n')
                .map(url => url.trim())
                .filter(url => url.length > 0);

            if (urls.length === 0) {
                showStatus('Inserisci almeno un URL!', 'error');
                return;
            }

            const hasPlaylist = urls.some(url => url.includes('playlist') || url.includes('list='));

            if (hasPlaylist) {
                showStatus('Estrazione playlist in corso...', 'info');
            }

            try {
                const response = await fetch(`${API_BASE}/queue/add`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        urls: urls
                    })
                });

                const data = await response.json();

                if (data.success) {
                    let message = `${data.added} video aggiunti alla coda!`;
                    if (hasPlaylist) {
                        message = `${data.added} video estratti dalla playlist e aggiunti!`;
                    }

                    showStatus(message, 'success');

                    if (data.errors && data.errors.length > 0) {
                        console.warn('Alcuni URL hanno dato errore:', data.errors);
                        showStatus(`${data.added} aggiunti, ${data.errors.length} errori (vedi console)`, 'info');
                    }

                    document.getElementById('urlInput').value = '';
                    document.getElementById('startBtn').disabled = false;
                    updateQueueStatus();
                } else {
                    showStatus('Errore: ' + data.error, 'error');
                }
            } catch (error) {
                showStatus('Errore di rete: ' + error, 'error');
            }
        }

        async function startQueue() {
            try {
                const response = await fetch(`${API_BASE}/queue/start`, {
                    method: 'POST'
                });

                const data = await response.json();

                if (data.success) {
                    showStatus('✓ Download avviati!', 'success');
                    document.getElementById('startBtn').disabled = true;
                    document.getElementById('stopBtn').disabled = false;
                    document.getElementById('processingIndicator').style.display = 'inline';

                    // Avvia aggiornamento automatico
                    if (updateInterval) clearInterval(updateInterval);
                    updateInterval = setInterval(updateQueueStatus, 1000);
                } else {
                    showStatus('Errore: ' + data.error, 'error');
                }
            } catch (error) {
                showStatus('Errore: ' + error, 'error');
            }
        }

        async function stopQueue() {
            try {
                const response = await fetch(`${API_BASE}/queue/stop`, {
                    method: 'POST'
                });

                const data = await response.json();

                if (data.success) {
                    showStatus('Download fermati', 'info');
                    document.getElementById('startBtn').disabled = false;
                    document.getElementById('stopBtn').disabled = true;
                    document.getElementById('processingIndicator').style.display = 'none';

                    if (updateInterval) {
                        clearInterval(updateInterval);
                        updateInterval = null;
                    }
                }
            } catch (error) {
                showStatus('Errore: ' + error, 'error');
            }
        }

        async function clearQueue() {
            if (!confirm('Vuoi davvero pulire tutta la coda?')) return;

            try {
                const response = await fetch(`${API_BASE}/queue/clear`, {
                    method: 'POST'
                });

                const data = await response.json();

                if (data.success) {
                    showStatus('✓ Coda pulita', 'success');
                    downloadedFiles.clear(); // Resetta anche i file tracciati
                    updateQueueStatus();
                }
            } catch (error) {
                showStatus('Errore: ' + error, 'error');
            }
        }

        async function updateQueueStatus() {
            try {
                const response = await fetch(`${API_BASE}/queue/status`);
                const data = await response.json();

                // Aggiorna statistiche
                document.getElementById('queueCount').textContent = data.queue.length;
                document.getElementById('currentCount').textContent = data.current ? 1 : 0;
                document.getElementById('completedCount').textContent = data.completed.length;
                document.getElementById('failedCount').textContent = data.failed.length;

                // Aggiorna progress bar
                const total = data.queue.length + (data.current ? 1 : 0) + data.completed.length + data.failed.length;
                if (total > 0) {
                    const completed = data.completed.length;
                    const percentage = Math.round((completed / total) * 100);
                    const progressBar = document.getElementById('progressBar');
                    const progressFill = document.getElementById('progressFill');
                    progressBar.classList.add('show');
                    progressFill.style.width = percentage + '%';
                    progressFill.textContent = `${completed}/${total} (${percentage}%)`;
                } else {
                    document.getElementById('progressBar').classList.remove('show');
                }

                // Aggiorna download corrente
                const currentItem = document.getElementById('currentItem');
                if (data.current) {
                    currentItem.innerHTML = `
                        <div class="queue-item current">
                            <div class="queue-item-icon">⚡</div>
                            <div class="queue-item-info">
                                <div class="queue-item-title">${data.current.title || 'Download in corso...'}</div>
                                <div class="queue-item-url">${data.current.url}</div>
                            </div>
                        </div>
                    `;
                } else {
                    currentItem.innerHTML = '<div class="empty-state"><div>Nessun download in corso</div></div>';
                }

                // Aggiorna lista in attesa
                const queueList = document.getElementById('queueList');
                if (data.queue.length > 0) {
                    queueList.innerHTML = data.queue.map(item => `
                        <div class="queue-item">
                            <div class="queue-item-icon">⏳</div>
                            <div class="queue-item-info">
                                <div class="queue-item-title">${item.title}</div>
                                <div class="queue-item-url">${item.url}</div>
                            </div>
                        </div>
                    `).join('');
                } else {
                    queueList.innerHTML = '<div class="empty-state"><div>Coda vuota</div></div>';
                }

                // Aggiorna completati
                const completedList = document.getElementById('completedList');
                if (data.completed.length > 0) {
                    completedList.innerHTML = data.completed.reverse().map(item => {
                        // Scarica automaticamente se non è già stato scaricato
                        if (!downloadedFiles.has(item.filename)) {
                            downloadedFiles.add(item.filename);
                            setTimeout(() => {
                                downloadFile(item.filename);
                                showStatus(`Download automatico: ${item.title}`, 'success');
                            }, 500);
                        }

                        return `
                        <div class="queue-item completed">
                            <div class="queue-item-icon">✅</div>
                            <div class="queue-item-info">
                                <div class="queue-item-title">${item.title}</div>
                                <div class="queue-item-url">${item.url}</div>
                            </div>
                            <div class="queue-item-action">
                                <button class="btn-success" style="padding: 8px 12px; font-size: 14px;" 
                                        onclick="downloadFile('${item.filename}')">
                                    Riscarica
                                </button>
                            </div>
                        </div>
                    `
                    }).join('');
                } else {
                    completedList.innerHTML = '<div class="empty-state"><div>Nessun download completato</div></div>';
                }

                // Aggiorna falliti
                const failedSection = document.getElementById('failedSection');
                const failedList = document.getElementById('failedList');
                if (data.failed.length > 0) {
                    failedSection.style.display = 'block';
                    failedList.innerHTML = data.failed.reverse().map(item => `
                        <div class="queue-item failed">
                            <div class="queue-item-icon">❌</div>
                            <div class="queue-item-info">
                                <div class="queue-item-title">${item.title || 'Errore'}</div>
                                <div class="queue-item-url">${item.url}</div>
                                <div style="margin-top: 5px; font-size: 12px; color: #d32f2f;">
                                    <strong>Errore:</strong> ${item.error || 'Errore sconosciuto'}
                                </div>
                            </div>
                            <div class="queue-item-action">
                                <button class="btn-primary" style="padding: 8px 12px; font-size: 14px;" 
                                        onclick="retryDownload('${item.url}')">
                                    🔄 Riprova
                                </button>
                            </div>
                        </div>
                    `).join('');
                } else {
                    failedSection.style.display = 'none';
                }

                // Gestisci stato pulsanti
                if (!data.is_processing) {
                    document.getElementById('startBtn').disabled = data.queue.length === 0;
                    document.getElementById('stopBtn').disabled = true;
                    document.getElementById('processingIndicator').style.display = 'none';

                    if (updateInterval && data.queue.length === 0 && !data.current) {
                        clearInterval(updateInterval);
                        updateInterval = null;
                        showStatus('✓ Tutti i download completati!', 'success');
                    }
                }

            } catch (error) {
                console.error('Errore aggiornamento stato:', error);
            }
        }

        function downloadFile(filename) {
            window.location.href = `${API_BASE}/download/${encodeURIComponent(filename)}`;
        }

        async function retryDownload(url) {
            document.getElementById('urlInput').value = url;
            await addToQueue();
            if (!document.getElementById('startBtn').disabled) {
                await startQueue();
            }
        }

        // Aggiorna stato iniziale
        updateQueueStatus();

        // Auto-update ogni 2 secondi se non sta già processando
        setInterval(() => {
            if (!updateInterval) {
                updateQueueStatus();
            }
        }, 2000);