#!/usr/bin/env bash
set -euo pipefail

mkdir -p docs/assets

# -------- styles.css --------
cat <<'EOF' > docs/styles.css
:root {
  --bg: #0b0f14;
  --bg-alt: #10151c;
  --text: #e8eef6;
  --muted: #b5c4d6;
  --brand: #0f4c81;
  --brand-2: #4ecdc4;
  --card: #131a23;
  --border: #223041;
  --shadow: 0 6px 30px rgba(0,0,0,.25);
}
:root.light {
  --bg: #f7fbff; --bg-alt: #ffffff; --text: #0e1621; --muted: #4b5b70;
  --brand: #0f4c81; --brand-2: #2f9e8b; --card: #ffffff; --border: #e1e8f0;
  --shadow: 0 6px 24px rgba(15,25,35,.1);
}
* { box-sizing: border-box }
html, body { margin:0; padding:0; }
body { font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Apple Color Emoji","Segoe UI Emoji", "Segoe UI Symbol", sans-serif; background: var(--bg); color: var(--text); line-height: 1.6; }
.container { width: min(1100px, 90vw); margin: 0 auto; padding: 2rem 0 4rem; }
.site-header, .site-footer { width: 100%; display: flex; align-items: center; justify-content: space-between; background: var(--bg-alt); border-bottom: 1px solid var(--border); padding: .8rem 5vw; position: sticky; top: 0; z-index: 10; }
.site-footer { position: static; border-top: 1px solid var(--border); border-bottom: none; padding: 2rem 5vw; display: block; text-align: center; }
.brand { display:flex; gap:.6rem; align-items:center; color:var(--text); text-decoration:none; font-weight:700; letter-spacing:.2px }
.brand img { filter: drop-shadow(0 2px 6px rgba(0,0,0,.25)); }
.nav a { color: var(--muted); text-decoration: none; margin: 0 .6rem; padding: .4rem .6rem; border-radius: .5rem; }
.nav a:hover, .nav a:focus { background: var(--card); color: var(--text); outline: none; }
.theme-toggle { background: var(--card); color: var(--text); border: 1px solid var(--border); padding: .45rem .6rem; border-radius: .5rem; cursor: pointer; }
h1, h2, h3 { line-height: 1.2; } h1 { font-size: clamp(1.8rem, 2.5vw + 1rem, 2.6rem); margin-top:0 } h2 { margin-top: 2rem; } p { margin: 0.75rem 0; color: var(--text); }
.hero { margin: 1rem 0 2rem; padding: 2rem; border:1px solid var(--border); background: linear-gradient(135deg, rgba(15,76,129,.12), rgba(78,205,196,.06)); border-radius: 1rem; box-shadow: var(--shadow) }
.hero p { color: var(--muted); max-width: 75ch; }
.btn { display: inline-block; padding: .7rem 1rem; border-radius: .6rem; border:1px solid var(--border); color: var(--text); text-decoration: none; background: var(--card); margin-right:.75rem; }
.btn.primary { background: linear-gradient(135deg, var(--brand), var(--brand-2)); border: none; }
.grid.three { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1rem; margin: 1.5rem 0; }
.card { background: var(--card); border:1px solid var(--border); border-radius: .9rem; padding:1rem; box-shadow: var(--shadow) }
.card h3 { margin: .2rem 0 .6rem; }
.checklist { list-style: none; padding-left: 0; }
.checklist li { padding-left: 1.6rem; position: relative; margin: .4rem 0; color: var(--muted); }
.checklist li::before { content: "✔"; position: absolute; left: 0; color: var(--brand-2); }
.diagram img { width: 100%; border:1px solid var(--border); border-radius: .8rem; background: var(--bg-alt); margin-top: .75rem; }
pre { background: var(--card); color: var(--text); padding: 1rem; border-radius: .8rem; overflow: auto; border:1px solid var(--border) }
code { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono","Courier New", monospace; font-size: .95em; }
.roadmap { counter-reset: step; padding-left: 1.2rem; } .roadmap li { margin: .5rem 0 } .roadmap li::marker { color: var(--brand-2) }
a { color: var(--brand-2) } a:hover { text-decoration: underline; }
@media (max-width: 720px) { .nav { display:none } }
EOF

# -------- script.js --------
cat <<'EOF' > docs/script.js
(function(){
  const root = document.documentElement;
  const key = 'ccam-theme';
  const saved = localStorage.getItem(key);
  const prefersLight = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches;
  if (saved === 'light' || (!saved && prefersLight)) root.classList.add('light');

  const btn = document.getElementById('themeToggle');
  if (btn) {
    btn.addEventListener('click', () => {
      root.classList.toggle('light');
      localStorage.setItem(key, root.classList.contains('light') ? 'light' : 'dark');
    });
  }

  // Copy-to-clipboard for any pre > code blocks
  document.querySelectorAll('pre > code').forEach(code => {
    const pre = code.parentElement;
    const wrap = document.createElement('div');
    wrap.style.position = 'relative';
    pre.parentNode.insertBefore(wrap, pre);
    wrap.appendChild(pre);

    const btn = document.createElement('button');
    btn.textContent = 'Copy';
    btn.setAttribute('aria-label', 'Copy code');
    btn.className = 'copy-btn';
    btn.style.position = 'absolute';
    btn.style.top = '.5rem';
    btn.style.right = '.5rem';
    btn.style.padding = '.3rem .6rem';
    btn.style.borderRadius = '.4rem';
    btn.style.border = '1px solid var(--border)';
    btn.style.background = 'var(--bg-alt)';
    btn.style.color = 'var(--text)';
    btn.addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(code.textContent); btn.textContent = 'Copied!'; setTimeout(()=>btn.textContent='Copy',1200); }
      catch(e){ console.warn('Clipboard failed', e); }
    });
    wrap.appendChild(btn);
  });
})();
EOF

# -------- HEAD/FOOT templates --------
read -r -d '' HEAD <<'EOF' || true
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>%TITLE% — CricketCam</title>
  <meta name="description" content="%DESC%" />
  <meta name="theme-color" content="#0f4c81" />
  <meta property="og:title" content="%TITLE% — CricketCam" />
  <meta property="og:description" content="%DESC%" />
  <meta property="og:type" content="website" />
  <meta property="og:image" content="assets/og.png" />
  <link rel="icon" href="assets/favicon.svg" type="image/svg+xml" />
  <link rel="manifest" href="manifest.webmanifest" />
  <link rel="preload" href="styles.css" as="style" />
  <link rel="stylesheet" href="styles.css" />
  <script defer src="script.js"></script>
</head>
<body>
<header class="site-header">
  <a class="brand" href="index.html" aria-label="CricketCam home">
    <img src="assets/logo.svg" alt="" width="28" height="28" />
    <span>CricketCam</span>
  </a>
  <nav class="nav">
    <a href="index.html">Home</a>
    <a href="architecture.html">Architecture</a>
    <a href="api.html">API</a>
    <a href="roadmap.html">Roadmap</a>
    <a href="faq.html">FAQ</a>
  </nav>
  <button class="theme-toggle" id="themeToggle" aria-label="Toggle dark mode">🌓</button>
</header>
<main class="container">
EOF

read -r -d '' FOOT <<'EOF' || true
</main>
<footer class="site-footer">
  <p>© 2025 CricketCam. LAN-only, privacy-first sports capture.</p>
  <p><a href="https://github.com/" target="_blank" rel="noopener">GitHub</a> · <a href="api.html">API</a> · <a href="roadmap.html">Milestones</a></p>
</footer>
</body>
</html>
EOF

# -------- Safe page() using awk (no sed) --------
page() {
  local file="$1"; local title="$2"; local desc="$3"; shift 3
  local body="$*"
  # Compose full template
  local tmp
  tmp="$(mktemp)"
  printf "%s\n%s\n%s\n" "$HEAD" "$body" "$FOOT" > "$tmp"
  # Replace placeholders only in the head section (first ~30 lines) using awk
  awk -v t="$title" -v d="$desc" 'NR<=30{gsub(/%TITLE%/, t); gsub(/%DESC%/, d)}1' "$tmp" > "docs/$file"
  rm -f "$tmp"
}

# -------- index.html --------
page index.html \
  "Headless Multi-Camera Sports Capture" \
  "Two Android headless cameras + one iOS/iPadOS Director. 10-minute rolling CMAF buffer. Director pulls only the last 30 s in full quality and can MARK events." \
'\
<section class="hero">
  <h1>Headless multi-camera capture for grassroots cricket</h1>
  <p>Two Android cameras act like field cams. A universal iOS/iPadOS Director fetches only the last 30 s in full quality for instant review. MARK key moments to auto-save a 12 s clip (−8/+4). LAN-only. No cloud. No transcoding.</p>
  <div class="cta">
    <a class="btn primary" href="architecture.html">See how it works</a>
    <a class="btn" href="api.html">Browse the API</a>
  </div>
</section>

<section class="grid three">
  <article class="card">
    <h3>True headless capture</h3>
    <p>Android Foreground Service + MediaCodec H.264 High, 1080p60, CBR ~7 Mbps, GOP=1 s (IDR/sec). Writes 1 s CMAF m4s into a 10:00 rolling buffer.</p>
  </article>
  <article class="card">
    <h3>Director-led HQ review</h3>
    <p>Director pulls only the last 30 s from selected cameras over HTTP (LAN) and plays progressively via AVFoundation. No preview-quality stream.</p>
  </article>
  <article class="card">
    <h3>MARK & export</h3>
    <p>Tap WICKET/FOUR/SIX to save a 12 s clip (−8/+4) as fast-start MP4 with metadata. ISO masters remain on the cameras.</p>
  </article>
</section>

<section class="features">
  <h2>Key features</h2>
  <ul class="checklist">
    <li>mDNS/Bonjour discovery; QR/PIN pairing; per-match enrollment with HMAC tokens</li>
    <li>Clock sync via clap + drift pings every 5 s (apply ≤ ±50 ms/update)</li>
    <li>HTTP-first transport; optional WebRTC DataChannel (unordered) toggle</li>
    <li>Thermal policy: never alter quality mid-over; serve slowly before stepping fps between overs</li>
  </ul>
</section>

<section class="diagram">
  <h2>System sketch</h2>
  <img src="assets/diagram.svg" alt="CricketCam architecture diagram" />
</section>

<section class="cta2">
  <a class="btn primary" href="roadmap.html">View milestones</a>
  <a class="btn" href="faq.html">FAQ</a>
</section>
'

# -------- architecture.html --------
page architecture.html \
  "Architecture" \
  "Capture on Android, review on iOS/iPadOS. Rolling CMAF buffer, 30 s progressive review, MARK clips, LAN-only." \
'\
<h1>Architecture</h1>
<p>This system treats phones like purpose-built field cameras. Capture is continuous and headless; review is high-quality and on demand.</p>

<h2>Devices</h2>
<ul>
  <li><strong>Android Cameras</strong>: Lava LXX504 (MediaTek Dimensity 7050), Android 12+, 5 GHz Wi-Fi</li>
  <li><strong>Director</strong>: iPad 9 (A13) or iPhone (universal app)</li>
  <li><strong>Network</strong>: Home 5 GHz Wi-Fi, LAN-only operation</li>
</ul>

<h2>Capture pipeline (Android)</h2>
<pre><code>Camera2 → MediaCodec (H.264 High)
CBR ≈ 7 Mbps, 1080p60, IDR every second (GOP=1 s, no B-frames)
CMAF writer: 1 s moof/mdat (tfdt continuity, timescale 90k)
Rolling 10:00 ring (+2 s guard), auto-prune
HTTP microserver: /v1/info, /v1/init, /v1/segments, /v1/export
Thermal: throttle serving before any capture change (fps step only between overs)</code></pre>

<h2>Director pipeline (iOS/iPadOS)</h2>
<pre><code>Bonjour/mDNS discovery → roster (Core Data)
Ping/pong every 5 s to estimate drift; clamp apply ≤ ±50 ms
Review 30 s: fetch init then 30 × 1 s m4s; progressive playback with AVAssetResourceLoader → AVPlayer
MARK (−8/+4): save fast-start MP4 + metadata (no transcode)</code></pre>

<h2>Security model</h2>
<ol>
  <li><strong>Pairing</strong> (QR/PIN) → exchange keys; store <code>pair_token</code> (rotated daily)</li>
  <li><strong>Enrollment</strong> per match → <code>match_token = HMAC(pair_token, "enroll:"+MID+nonce)</code> (TTL)</li>
  <li>Serving gate: all /v1/segments and /v1/export require <em>MID + match_token</em></li>
  <li>LAN-only by default; optional HTTPS + certificate pinning</li>
</ol>

<h2>Performance budgets</h2>
<ul>
  <li><strong>TTFB</strong> ≤ 1.5 s (Review → first decoded frame)</li>
  <li><strong>Sync</strong> ≤ ±50 ms between cameras over 10 min</li>
  <li><strong>Soak</strong> 2 h at 1080p60; window 10:00–10:02; no gaps</li>
  <li><strong>Storage</strong> ≈ 540 MB per camera for 10 min ring @ ~7.1 Mbps (video+audio)</li>
</ul>
'

# -------- api.html --------
page api.html \
  "HTTP API" \
  "Minimal LAN API for discovery, enrollment and fragment serving. HTTP-first; WebRTC optional." \
'\
<h1>Camera HTTP API</h1>
<p>All endpoints are LAN-local to each camera. Default port: <code>8134</code>.</p>

<h2>Discovery</h2>
<pre><code>GET /v1/info
200 OK
{ "id":"cam-uuid","model":"Lava LXX504","soc":"D7050","codec":"h264",
  "fps":60,"gop":1,"bitrate":7000000,"hasAudio":true,
  "now_ms":1725169234123,"serving":"ok",
  "thermals":{"state":"nominal","cpuC":41} }</code></pre>

<h2>Pairing</h2>
<pre><code>POST /v1/pair
Headers: Authorization: Pairing-Nonce &lt;nonce&gt;
Body:    { "director_pubkey":"...", "display_name":"iPad 9", "pin":"123456" }
200 OK   { "camera_pubkey":"...", "pair_token":"&lt;base64url&gt;" }</code></pre>

<h2>Enrollment</h2>
<pre><code>POST /v1/matches/enroll
Headers: Authorization: Bearer &lt;pair_token&gt;
Body:    { "mid":"&lt;uuid&gt;", "match_token":"&lt;hmac&gt;", "ttl":7200, "role":"A" }
200 OK   { "ok":true }</code></pre>

<h2>Init segments</h2>
<pre><code>GET /v1/init/video
GET /v1/init/audio  (if audio enabled)
Headers: Authorization: Bearer &lt;match_token&gt;</code></pre>

<h2>Serving fragments</h2>
<pre><code>GET /v1/segments?mid=&lt;MID&gt;&amp;from=&lt;ms&gt;&amp;to=&lt;ms&gt;&amp;tracks=video[,audio]
Headers: Authorization: Bearer &lt;match_token&gt;
Response: HTTP chunked stream of 1 s m4s (moof/mdat) in order</code></pre>

<h2>Export MARK clip</h2>
<pre><code>POST /v1/export?mid=&lt;MID&gt;&amp;from=&lt;ms&gt;&amp;to=&lt;ms&gt;&amp;tracks=video[,audio]
Headers: Authorization: Bearer &lt;match_token&gt;
Response: application/mp4 (fast-start; no transcode)</code></pre>

<h2>WebRTC (optional)</h2>
<p>Unordered RTCDataChannel for the same messages (<code>INIT</code>, <code>SEGMENTS</code>, <code>PING/PONG</code>) on host-only ICE; disabled by default.</p>

<h2>mDNS TXT</h2>
<pre><code>id=&lt;uuid&gt;;model=LavaLXX504;soc=D7050;codec=h264;fps=60;gop=1;br=7000k;audio=1;pin=1;ver=4</code></pre>
'

# -------- roadmap.html --------
page roadmap.html \
  "Roadmap & Milestones" \
  "Development plan from skeletons to QA soak, with thermal safeguards and optional WebRTC." \
'\
<h1>Roadmap</h1>
<ol class="roadmap">
  <li><strong>M0</strong> — Skeletons & tooling (Android/iOS compile; mDNS & /v1/info stubs)</li>
  <li><strong>M1</strong> — Android capture: 10-min rolling CMAF (1 s) @ 1080p60 + HTTP /init,/segments</li>
  <li><strong>M2</strong> — Pairing: QR/PIN flow; roster on Director</li>
  <li><strong>M3</strong> — Director review: single-angle progressive 30 s (TTFB ≤ 1.5 s)</li>
  <li><strong>M4</strong> — Drift & dual-angle sync (±50 ms over 10 min)</li>
  <li><strong>M5</strong> — MARK (v1 camera export; v2 local remux)</li>
  <li><strong>M6</strong> — Enrollment & auth: MID + match_token gate</li>
  <li><strong>M7</strong> — Thermal & degraded serving (UI banner)</li>
  <li><strong>M8</strong> — QA soak: 2 h @1080p60; window 10:00–10:02; MARK frame-accuracy</li>
  <li><em>Optional:</em> M9 WebRTC DC; M10 HTTPS + pinning</li>
</ol>

<h2>Acceptance criteria</h2>
<ul>
  <li>First frame ≤ 1.5 s from Review tap</li>
  <li>Inter-camera sync ≤ ±50 ms over 10 min</li>
  <li>2 h soak without gaps; thermal policy honored</li>
  <li>MARK 12 s export is frame-accurate and fast-start</li>
</ul>
'

# -------- faq.html --------
page faq.html \
  "FAQ" \
  "Common questions about CricketCam: privacy, network, hardware, and operations." \
'\
<h1>FAQ</h1>

<h2>Is Internet required?</h2>
<p>No. Everything works LAN-only on your 5 GHz Wi-Fi. Internet is optional.</p>

<h2>Does the Director see a low-res preview?</h2>
<p>No. By design there’s only high-quality review of the last 30 s (progressive as bytes arrive).</p>

<h2>What happens when phones heat up?</h2>
<p>Serving slows or pauses before capture changes. If required, fps steps from 60→30 <em>between overs only</em>, and the Director is notified.</p>

<h2>Where are MARK clips saved?</h2>
<p>Locally on the Director (fast-start MP4) with a metadata sidecar. ISO masters remain on cameras.</p>

<h2>What sports are supported?</h2>
<p>Spec targets cricket first; volleyball and badminton are natural follow-ups with the same pipeline.</p>

<h2>How do I point my domain to this site?</h2>
<p>Add your custom domain in the repo at <code>/docs/CNAME</code> and set DNS to GitHub Pages. See GitHub’s docs for A/AAAA or CNAME targets.</p>
'

# -------- 404.html --------
page 404.html "Not Found" "Page not found" \
'\
<h1>404 — Not Found</h1>
<p>The page you’re looking for doesn’t exist. Try the <a href="index.html">home page</a>.</p>
'

# -------- manifest.webmanifest --------
cat <<'EOF' > docs/manifest.webmanifest
{
  "name": "CricketCam",
  "short_name": "CricketCam",
  "start_url": "index.html",
  "display": "standalone",
  "background_color": "#0b0f14",
  "theme_color": "#0f4c81",
  "icons": [
    { "src": "assets/favicon.svg", "sizes": "any", "type": "image/svg+xml" }
  ]
}
EOF

# -------- robots.txt --------
cat <<'EOF' > docs/robots.txt
User-agent: *
Allow: /
Sitemap: https://your-domain.example/sitemap.xml
EOF

# -------- sitemap.xml --------
cat <<'EOF' > docs/sitemap.xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>https://your-domain.example/</loc></url>
  <url><loc>https://your-domain.example/architecture.html</loc></url>
  <url><loc>https://your-domain.example/api.html</loc></url>
  <url><loc>https://your-domain.example/roadmap.html</loc></url>
  <url><loc>https://your-domain.example/faq.html</loc></url>
</urlset>
EOF

# -------- CNAME (edit this to your domain) --------
echo 'your.domain.tld' > docs/CNAME

# -------- assets/logo.svg --------
cat <<'EOF' > docs/assets/logo.svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0f4c81"/>
      <stop offset="1" stop-color="#4ecdc4"/>
    </linearGradient>
  </defs>
  <circle cx="32" cy="32" r="30" fill="url(#g)" />
  <path d="M18 40l12-16 8 10 8-12" stroke="#fff" stroke-width="4" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="32" cy="32" r="4" fill="#fff"/>
</svg>
EOF

# -------- assets/favicon.svg --------
cp docs/assets/logo.svg docs/assets/favicon.svg

# -------- assets/diagram.svg --------
cat <<'EOF' > docs/assets/diagram.svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 880 420">
  <style>
    .b{fill:#10151c;stroke:#223041;stroke-width:2}
    .t{font:14px sans-serif;fill:#e8eef6}
    .s{font:12px sans-serif;fill:#b5c4d6}
  </style>
  <rect width="100%" height="100%" fill="#0b0f14"/>
  <rect x="30" y="60" width="240" height="120" rx="12" class="b"/>
  <text x="150" y="85" text-anchor="middle" class="t">Android Camera A</text>
  <text x="150" y="108" text-anchor="middle" class="s">1080p60 H.264, 1 s m4s</text>
  <text x="150" y="130" text-anchor="middle" class="s">10:00 rolling buffer</text>
  <rect x="30" y="240" width="240" height="120" rx="12" class="b"/>
  <text x="150" y="265" text-anchor="middle" class="t">Android Camera B</text>
  <text x="150" y="288" text-anchor="middle" class="s">1080p60 H.264, 1 s m4s</text>
  <text x="150" y="310" text-anchor="middle" class="s">10:00 rolling buffer</text>
  <rect x="610" y="150" width="240" height="120" rx="12" class="b"/>
  <text x="730" y="175" text-anchor="middle" class="t">Director (iPad/iPhone)</text>
  <text x="730" y="198" text-anchor="middle" class="s">30 s HQ progressive review</text>
  <text x="730" y="220" text-anchor="middle" class="s">MARK −8/+4 clip</text>
  <rect x="330" y="170" width="200" height="80" rx="12" class="b"/>
  <text x="430" y="195" text-anchor="middle" class="t">5 GHz Wi-Fi (LAN)</text>
  <text x="430" y="218" text-anchor="middle" class="s">HTTP default • WebRTC optional</text>
  <path d="M270 120 H330" stroke="#4ecdc4" stroke-width="3"/>
  <path d="M270 300 H330" stroke="#4ecdc4" stroke-width="3"/>
  <path d="M530 210 H610" stroke="#4ecdc4" stroke-width="3"/>
  <text x="300" y="112" class="s">/v1/info, /v1/segments</text>
  <text x="300" y="292" class="s">/v1/info, /v1/segments</text>
  <text x="570" y="202" class="s">30× 1 s m4s</text>
</svg>
EOF

echo "✅ GitHub Pages site generated in ./docs"
