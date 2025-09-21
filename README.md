# CricketCam — Headless Multi-Camera Sports Capture (LAN-only, Director-led HQ Review)

> Two Android headless cameras + one iOS/iPadOS Director. 10-minute rolling CMAF buffer. Director pulls **only** the last 30 s in full quality and can **MARK** events to save a 12 s clip (−8/+4). LAN-only, HTTP-first, WebRTC optional.

## Why this exists
Grassroots cricket (and similar field sports) need high-quality replays without cloud costs, laptop rigs, or “preview-first” compromises. This project makes phones act like field cameras with **true headless capture**, while the Director tablet does **HQ-only review** on demand.

---

## What it does (at a glance)

- **Capture (Android, Dimensity 7050)**
  - 1080p60 H.264 High Profile, CBR ~7 Mbps, GOP=1 s (IDR every second), optional AAC mono 48 kHz.
  - Writes **1 s CMAF/fMP4** fragments to a **rolling 10:00 buffer** (+2 s guard), auto-pruned.

- **Director (iOS/iPadOS)**
  - Discovers cameras via **mDNS/Bonjour**, syncs clocks (clap + 5 s drift pings).
  - On Review: fetches **only the last 30 s** (progressive as bytes arrive) and plays immediately.
  - **MARK**: saves a **12 s** clip (−8/+4) locally with metadata (no transcode).

- **Transport & Security**
  - **HTTP over LAN** (default); **WebRTC DataChannel** optional (unordered).
  - **Pairing** (QR/PIN → pair_token) and **per-match enrollment** (MID + match_token).
  - LAN-only by default; optional TLS + cert pinning.

---

## Hardware & Network

- **2× Android phones**: MediaTek Dimensity 7050; 8 GB / 256 GB; Android 12+; 5 GHz Wi-Fi.
- **Director**: iPad 9 (A13) or iPhone (universal app).
- **Wi-Fi**: Home router, **5 GHz**, LAN-only operation (no Internet required).

---

## Repo layout (proposed)

```
/android/ # Android Camera app (headless capture + HTTP server)
/ios/ # iOS/iPadOS Director app (universal)
/docs/ # GitHub Pages site (project showcase) ← publish this folder
/tools/ # dev scripts: ffprobe checks, iperf, packaging
/.github/ # CI, issue templates
```


> GitHub Pages: set **Pages → Build from `/docs` folder**. If you’re mapping a custom domain, add a `CNAME` file inside `/docs` with just your domain (e.g., `cricketcam.example.com`).

---

## Quick start (dev)

### Prereqs
- macOS with Xcode + Android Studio, Homebrew.
- Homebrew: `brew install ffmpeg gpac iperf3 wireshark`

### Android (camera)
1. Open `/android` in Android Studio.
2. Build & run on Lava phones (enable “Ignore battery optimizations” when prompted).
3. Confirm service shows `_cricketcam._tcp.local` via Bonjour browser.

### iOS/iPadOS (Director)
1. Open `/ios` in Xcode; select iPad 9 (or iPhone) target.
2. Run; app should discover cameras within ~2 s (LAN).
3. Tap **Review** → first frame ≤ 1.5 s; hit **MARK** to save a 12 s clip.

> Bandwidth sanity: `iperf3 -c <camera_ip> -t 30` should show ≥30 Mbps headroom per camera.

---

## Minimal camera API (HTTP)

- `GET /v1/info` → `{ id, model, codec, fps, gop, bitrate, hasAudio, now_ms, serving, thermals }`
- `POST /v1/pair` (Header: `Pairing-Nonce`) → `{ camera_pubkey, pair_token }`
- `POST /v1/matches/enroll` (Auth: **pair_token**) → `{ ok:true }`
- `GET /v1/init/video` (Auth: **match_token**) → bytes
- `GET /v1/segments?mid=<MID>&from=<ms>&to=<ms>&tracks=video[,audio]` (Auth: **match_token**) → chunked `m4s`
- `POST /v1/export?mid=<MID>&from=<ms>&to=<ms>` (Auth: **match_token**) → fast-start MP4 (no transcode)

---

## Guarantees & acceptance (v1)

- **TTFB**: first frame ≤ **1.5 s** from Review tap.
- **Sync**: inter-camera A/V skew ≤ **±50 ms** over 10 min (drift pings @ 5 s).
- **Soak**: 2 h @ 1080p60; rolling window **10:00–10:02**; no gaps.
- **MARK**: 12 s clip is frame-accurate (±1 frame) and plays in QuickTime.
- **Thermal**: serving throttles before any capture fps change; fps step 60→30 occurs **between overs** only, with Director banner.

---

## Roadmap (milestones)
M0 Skeletons → M1 Android capture (CMAF 1 s, 10 min ring) → M2 Pairing →  
M3 Director single-angle progressive review → M4 Drift + dual-angle sync →  
M5 MARK export → M6 Enrollment/auth → M7 Thermal/degraded → M8 QA soak → (Opt) M9 WebRTC DC → (Opt) M10 HTTPS+pinning

---

## Contributing & license
- Issues / discussions welcome! PRs with small, focused changes preferred.
- **License**: _Choose one_ (Apache-2.0 recommended for tooling/libs). Add `LICENSE` file.

---

## Safety, privacy & disclosures
LAN-only by default. No cloud. Do not record in places without permission.  
Security issues? Please open a **Security advisory** or email the maintainer (see repo Security policy).

---

## Project website
A showcase site lives in `/docs` (GitHub Pages). It explains the intent, architecture, and how to run a community match replay setup.  
_Custom domain?_ Add `/docs/CNAME` with your domain and set DNS `A/AAAA` or CNAME to GitHub Pages.

---
