/* ============================================================
   Shuddha Sangeetham Admin CMS — frontend logic
   ============================================================ */

'use strict';

// ── State ──────────────────────────────────────────────────────────────────

// Backend URL — update this after the Cloudflare tunnel is set up
const API_URL = 'BACKEND_URL_PLACEHOLDER';

let authToken = localStorage.getItem('ss_admin_token') || '';
let krithiPage = 1;
let modalAction = null;

// ── API helper ─────────────────────────────────────────────────────────────

async function api(path, { method = 'GET', body } = {}) {
  const res = await fetch(`${API_URL}${path}`, {
    method,
    headers: {
      'Authorization': authToken ? `Bearer ${authToken}` : '',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  if (res.status === 401) {
    logout();
    throw new Error('Session expired — please sign in again.');
  }
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.json();
}

function logout() {
  authToken = '';
  localStorage.removeItem('ss_admin_token');
  document.getElementById('app-screen').classList.add('hidden');
  document.getElementById('login-screen').classList.remove('hidden');
}

// ── Login / logout ─────────────────────────────────────────────────────────

document.getElementById('login-btn').addEventListener('click', async () => {
  const username = document.getElementById('login-username').value.trim();
  const password = document.getElementById('login-password').value;
  const errEl = document.getElementById('login-error');
  errEl.classList.add('hidden');
  try {
    const res = await fetch(`${API_URL}/api/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password }),
    });
    if (!res.ok) throw new Error('Invalid username or password.');
    const data = await res.json();
    authToken = data.token;
    localStorage.setItem('ss_admin_token', authToken);
    document.getElementById('login-screen').classList.add('hidden');
    document.getElementById('app-screen').classList.remove('hidden');
    showSection('dashboard');
    loadDashboard();
  } catch (e) {
    errEl.textContent = e.message;
    errEl.classList.remove('hidden');
  }
});

// Auto-login if token exists
if (authToken) {
  api('/api/stats').then(() => {
    document.getElementById('login-screen').classList.add('hidden');
    document.getElementById('app-screen').classList.remove('hidden');
    showSection('dashboard');
    loadDashboard();
  }).catch(() => { authToken = ''; localStorage.removeItem('ss_admin_token'); });
}

document.getElementById('logout-btn').addEventListener('click', logout);

// ── Navigation ─────────────────────────────────────────────────────────────

function showSection(name) {
  document.querySelectorAll('.section').forEach(s => s.classList.add('hidden'));
  document.getElementById(`section-${name}`).classList.remove('hidden');
  document.querySelectorAll('.nav-btn').forEach(b => b.classList.toggle('active', b.dataset.section === name));
  if (name === 'krithis') loadKrithis();
  if (name === 'ragas') loadRagas();
  if (name === 'composers') loadComposers();
  if (name === 'talas') loadTalas();
  if (name === 'scraper') loadScraperStatus();
  if (name === 'synclog') loadSyncLog();
}

document.querySelectorAll('.nav-btn').forEach(btn => {
  btn.addEventListener('click', () => showSection(btn.dataset.section));
});

// ── Dashboard ──────────────────────────────────────────────────────────────

async function loadDashboard() {
  try {
    const stats = await api('/api/stats');
    document.getElementById('stat-krithis').textContent = stats.krithis.toLocaleString();
    document.getElementById('stat-ragas').textContent = stats.ragas.toLocaleString();
    document.getElementById('stat-composers').textContent = stats.composers.toLocaleString();
    document.getElementById('stat-talas').textContent = stats.talas.toLocaleString();
    const badge = document.getElementById('scraper-status-badge');
    badge.classList.toggle('hidden', !stats.scraper_running);
  } catch { /* offline */ }

  try {
    const log = await api('/api/sync-log?limit=5');
    const wrap = document.getElementById('dashboard-log');
    wrap.innerHTML = log.length ? log.map(renderLogEntry).join('') : '<p style="color:#999">No activity yet.</p>';
  } catch { /* offline */ }
}

// ── Krithis ────────────────────────────────────────────────────────────────

async function loadKrithis() {
  const q = document.getElementById('krithi-search').value.trim();
  const params = new URLSearchParams({ page: krithiPage, per_page: 50, q });
  try {
    const data = await api(`/api/krithis?${params}`);
    const totalPages = Math.ceil(data.total / data.per_page);
    document.getElementById('krithis-table-wrap').innerHTML = renderTable(
      ['Name', 'Composer', 'Raga', 'Language', 'Type', 'Updated', 'Actions'],
      data.items.map(k => [
        esc(k.name), esc(k.composer_name || '—'), esc(k.raga_name || '—'),
        esc(k.language), esc(k.composition_type),
        k.updated_at ? k.updated_at.slice(0, 10) : '—',
        actionBtns('krithi', k.id),
      ])
    );
    const pag = document.getElementById('krithis-pagination');
    pag.innerHTML = `
      <button onclick="krithiPage=${Math.max(1,krithiPage-1)};loadKrithis()" ${krithiPage===1?'disabled':''}>← Prev</button>
      <span>Page ${krithiPage} of ${totalPages || 1} (${data.total.toLocaleString()} total)</span>
      <button onclick="krithiPage=${Math.min(totalPages,krithiPage+1)};loadKrithis()" ${krithiPage>=totalPages?'disabled':''}>Next →</button>`;
  } catch (e) { showTableError('krithis-table-wrap', e); }
}

document.getElementById('krithi-search').addEventListener('keydown', e => { if (e.key === 'Enter') { krithiPage = 1; loadKrithis(); } });

function openKrithiForm(id) {
  const isEdit = !!id;
  openModal(isEdit ? 'Edit Krithi' : 'Add Krithi', krithiFields({}), async () => {
    const fd = readForm();
    fd.composer_id = parseInt(fd.composer_id);
    fd.raga_id = parseInt(fd.raga_id);
    fd.tala_id = parseInt(fd.tala_id);
    if (isEdit) {
      await api(`/api/krithis/${id}`, { method: 'PUT', body: fd });
    } else {
      await api('/api/krithis', { method: 'POST', body: fd });
    }
    loadKrithis();
  });
  if (isEdit) {
    api(`/api/krithis/${id}`).then(k => {
      setFormValues(k);
    });
  }
}

async function deleteEntity(type, id) {
  if (!confirm(`Delete this ${type}? This cannot be undone.`)) return;
  await api(`/api/${type}s/${id}`, { method: 'DELETE' });
  if (type === 'krithi') loadKrithis();
  if (type === 'raga') loadRagas();
  if (type === 'composer') loadComposers();
  if (type === 'tala') loadTalas();
}

function krithiFields(k) {
  return [
    field('name', 'Name', 'text', k.name),
    field('composer_id', 'Composer ID', 'number', k.composer_id),
    field('raga_id', 'Raga ID', 'number', k.raga_id),
    field('tala_id', 'Tala ID', 'number', k.tala_id),
    field('language', 'Language', 'text', k.language),
    field('composition_type', 'Type', 'text', k.composition_type),
    field('pallavi', 'Pallavi', 'textarea', k.pallavi),
    field('anupallavi', 'Anupallavi', 'textarea', k.anupallavi),
    field('charanam', 'Charanam', 'textarea', k.charanam),
    field('source_url', 'Source URL', 'text', k.source_url),
  ];
}

// ── Ragas ──────────────────────────────────────────────────────────────────

async function loadRagas() {
  const q = document.getElementById('raga-search').value.trim();
  try {
    const data = await api(`/api/ragas?q=${encodeURIComponent(q)}`);
    document.getElementById('ragas-table-wrap').innerHTML = renderTable(
      ['ID', 'Name', 'Melakarta', 'Arohana', 'Avarohana', 'Actions'],
      data.map(r => [r.id, esc(r.name), r.melakarta_number || '—', esc(r.arohana || ''), esc(r.avarohana || ''), actionBtns('raga', r.id)])
    );
  } catch (e) { showTableError('ragas-table-wrap', e); }
}

document.getElementById('raga-search').addEventListener('keydown', e => { if (e.key === 'Enter') loadRagas(); });

function openRagaForm(id) {
  openModal(id ? 'Edit Raga' : 'Add Raga', [
    field('name', 'Name', 'text'),
    field('arohana', 'Arohana', 'text'),
    field('avarohana', 'Avarohana', 'text'),
    field('melakarta_number', 'Melakarta Number', 'number'),
    field('parent_melakarta_id', 'Parent Melakarta ID', 'number'),
  ], async () => {
    const fd = readForm();
    if (fd.melakarta_number) fd.melakarta_number = parseInt(fd.melakarta_number);
    if (fd.parent_melakarta_id) fd.parent_melakarta_id = parseInt(fd.parent_melakarta_id);
    id ? await api(`/api/ragas/${id}`, { method: 'PUT', body: fd })
       : await api('/api/ragas', { method: 'POST', body: fd });
    loadRagas();
  });
  if (id) api(`/api/ragas/${id}`).then(setFormValues);
}

// ── Composers ──────────────────────────────────────────────────────────────

async function loadComposers() {
  const q = document.getElementById('composer-search').value.trim();
  try {
    const data = await api(`/api/composers?q=${encodeURIComponent(q)}`);
    document.getElementById('composers-table-wrap').innerHTML = renderTable(
      ['ID', 'Name', 'Era', 'Actions'],
      data.map(c => [c.id, esc(c.name), esc(c.era || '—'), actionBtns('composer', c.id)])
    );
  } catch (e) { showTableError('composers-table-wrap', e); }
}

document.getElementById('composer-search').addEventListener('keydown', e => { if (e.key === 'Enter') loadComposers(); });

function openComposerForm(id) {
  openModal(id ? 'Edit Composer' : 'Add Composer', [
    field('name', 'Name', 'text'),
    field('era', 'Era', 'text'),
    field('biography', 'Biography', 'textarea'),
  ], async () => {
    const fd = readForm();
    id ? await api(`/api/composers/${id}`, { method: 'PUT', body: fd })
       : await api('/api/composers', { method: 'POST', body: fd });
    loadComposers();
  });
  if (id) api(`/api/composers/${id}`).then(setFormValues);
}

// ── Talas ──────────────────────────────────────────────────────────────────

async function loadTalas() {
  try {
    const data = await api('/api/talas');
    document.getElementById('talas-table-wrap').innerHTML = renderTable(
      ['ID', 'Name', 'Structure', 'Aksharas', 'Actions'],
      data.map(t => [t.id, esc(t.name), esc(t.structure || '—'), t.aksharas_count || '—', actionBtns('tala', t.id)])
    );
  } catch (e) { showTableError('talas-table-wrap', e); }
}

function openTalaForm(id) {
  openModal(id ? 'Edit Tala' : 'Add Tala', [
    field('name', 'Name', 'text'),
    field('structure', 'Structure', 'text'),
    field('aksharas_count', 'Aksharas Count', 'number'),
  ], async () => {
    const fd = readForm();
    if (fd.aksharas_count) fd.aksharas_count = parseInt(fd.aksharas_count);
    id ? await api(`/api/talas/${id}`, { method: 'PUT', body: fd })
       : await api('/api/talas', { method: 'POST', body: fd });
    loadTalas();
  });
  if (id) api(`/api/talas/${id}`).then(setFormValues);
}

// ── Bulk Import ────────────────────────────────────────────────────────────

let importData = null;

const fileInput = document.getElementById('import-file');
const dropZone = document.getElementById('drop-zone');

fileInput.addEventListener('change', e => handleImportFile(e.target.files[0]));

dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.style.borderColor = 'var(--primary)'; });
dropZone.addEventListener('dragleave', () => { dropZone.style.borderColor = ''; });
dropZone.addEventListener('drop', e => {
  e.preventDefault();
  dropZone.style.borderColor = '';
  handleImportFile(e.dataTransfer.files[0]);
});

function handleImportFile(file) {
  if (!file) return;
  const reader = new FileReader();
  reader.onload = ev => {
    try {
      importData = JSON.parse(ev.target.result);
      if (!Array.isArray(importData)) throw new Error('Expected an array');
      document.getElementById('import-count').textContent = `${importData.length} records loaded from ${file.name}`;
      document.getElementById('import-preview').classList.remove('hidden');
      document.getElementById('import-result').innerHTML = '';
    } catch (err) {
      document.getElementById('import-result').innerHTML = `<p class="error">Invalid JSON: ${err.message}</p>`;
      importData = null;
    }
  };
  reader.readAsText(file);
}

document.getElementById('import-submit-btn').addEventListener('click', async () => {
  if (!importData) return;
  const btn = document.getElementById('import-submit-btn');
  btn.disabled = true;
  btn.textContent = 'Importing…';
  try {
    const result = await api('/api/import', { method: 'POST', body: importData });
    document.getElementById('import-result').innerHTML =
      `<p class="success">Import complete — ${result.inserted} inserted, ${result.updated} updated.</p>`;
    document.getElementById('import-preview').classList.add('hidden');
    importData = null;
  } catch (e) {
    document.getElementById('import-result').innerHTML = `<p class="error">Import failed: ${e.message}</p>`;
  } finally {
    btn.disabled = false;
    btn.textContent = 'Import';
  }
});

// ── Scraper ────────────────────────────────────────────────────────────────

async function loadScraperStatus() {
  try {
    const s = await api('/api/scraper/status');
    const el = document.getElementById('scraper-panel-status');
    el.textContent = s.running ? '⚙️ Scraper is currently running…' : '✓ Scraper is idle.';
    document.getElementById('run-scraper-btn').disabled = s.running;
  } catch { /* offline */ }
}

async function runScraper() {
  if (!confirm('Start the scraper? It will run in the background for up to 14 hours.')) return;
  try {
    await api('/api/scraper/run', { method: 'POST' });
    document.getElementById('scraper-panel-status').textContent = '⚙️ Scraper started — check Sync Log for progress.';
    document.getElementById('run-scraper-btn').disabled = true;
  } catch (e) {
    alert(`Failed to start scraper: ${e.message}`);
  }
}

// ── Sync Log ───────────────────────────────────────────────────────────────

async function loadSyncLog() {
  try {
    const entries = await api('/api/sync-log?limit=50');
    const wrap = document.getElementById('synclog-list');
    wrap.innerHTML = entries.length ? entries.map(renderLogEntry).join('') : '<p style="color:#999;margin-top:1rem">No log entries yet.</p>';
  } catch (e) {
    document.getElementById('synclog-list').innerHTML = `<p class="error">${e.message}</p>`;
  }
}

function renderLogEntry(e) {
  const type = e.type || 'unknown';
  const ts = e.timestamp || e.started_at || '?';
  let detail = '';
  if (type === 'import') {
    detail = `Inserted: ${e.inserted}, Updated: ${e.updated}, Total: ${e.total}`;
  } else if (type === 'scraper') {
    detail = `Finished at ${e.finished_at || '?'} — rc ${e.returncode}`;
    if (e.stdout_tail) detail += `<pre>${esc(e.stdout_tail)}</pre>`;
  } else if (type === 'scraper_error') {
    detail = `Error: ${esc(e.error)}`;
  }
  return `<div class="log-entry">
    <span class="log-type log-type-${type}">${type}</span>
    <span style="font-size:.8rem;color:#999;margin-left:.5rem">${ts}</span>
    <div style="margin-top:.35rem;font-size:.85rem">${detail}</div>
  </div>`;
}

// ── Modal ──────────────────────────────────────────────────────────────────

function openModal(title, fields, onSave) {
  document.getElementById('modal-title').textContent = title;
  document.getElementById('modal-fields').innerHTML = fields.join('');
  modalAction = onSave;
  document.getElementById('modal').classList.remove('hidden');
}

function closeModal() {
  document.getElementById('modal').classList.add('hidden');
  modalAction = null;
}

async function handleFormSubmit(e) {
  e.preventDefault();
  if (!modalAction) return;
  try {
    await modalAction();
    closeModal();
  } catch (err) {
    alert(`Save failed: ${err.message}`);
  }
}

document.getElementById('modal').addEventListener('click', e => {
  if (e.target === document.getElementById('modal')) closeModal();
});

function readForm() {
  const form = document.getElementById('modal-form');
  const result = {};
  form.querySelectorAll('[name]').forEach(el => {
    result[el.name] = el.value.trim() || null;
  });
  return result;
}

function setFormValues(data) {
  const form = document.getElementById('modal-form');
  Object.entries(data).forEach(([k, v]) => {
    const el = form.querySelector(`[name="${k}"]`);
    if (el && v != null) el.value = v;
  });
}

// ── Render helpers ─────────────────────────────────────────────────────────

function renderTable(headers, rows) {
  if (!rows.length) return '<p style="color:#999;margin-top:.5rem">No results.</p>';
  const ths = headers.map(h => `<th>${h}</th>`).join('');
  const trs = rows.map(r => `<tr>${r.map(c => `<td>${c}</td>`).join('')}</tr>`).join('');
  return `<table class="data-table"><thead><tr>${ths}</tr></thead><tbody>${trs}</tbody></table>`;
}

function field(name, label, type = 'text', val = '') {
  const tag = type === 'textarea'
    ? `<textarea name="${name}">${esc(val ?? '')}</textarea>`
    : `<input type="${type}" name="${name}" value="${esc(val ?? '')}" />`;
  return `<div class="form-field"><label>${label}${tag}</label></div>`;
}

function actionBtns(type, id) {
  const editFn = type === 'krithi' ? `openKrithiForm(${id})`
               : type === 'raga'   ? `openRagaForm(${id})`
               : type === 'composer' ? `openComposerForm(${id})`
               : `openTalaForm(${id})`;
  return `<button class="action-btn edit-btn" onclick="${editFn}">Edit</button>
          <button class="action-btn delete-btn" onclick="deleteEntity('${type}',${id})">Delete</button>`;
}

function showTableError(wrapId, err) {
  document.getElementById(wrapId).innerHTML = `<p class="error">Failed to load: ${err.message}</p>`;
}

function esc(str) {
  if (str == null) return '';
  return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
