# JB media pipeline — Phase 02 runbook

Masters stay on your machine. Encoded video goes to Cloudflare R2 and is served
from `media.junkyardbutcher.com`. **No video ever enters this git repo.**

---

## 0. Install the two tools (once)

PowerShell:

```
winget install Gyan.FFmpeg
winget install Rclone.Rclone
```

Close and reopen your terminal afterwards so they land on PATH. Check:

```
ffmpeg -version
rclone version
```

The scripts here are bash — run them in **Git Bash** (right-click the folder →
"Git Bash Here"), which you already have from Git for Windows.

---

## 1. Cloudflare — create the bucket

1. dash.cloudflare.com → **R2** in the left sidebar → **Create bucket**
2. Name it **`jb-media`**, location Automatic → Create
3. Cloudflare will ask you to add a billing profile if you haven't. Expected.
   At this volume the bill is $0 — free tier is 10 GB-month storage,
   1M writes, 10M reads, and egress is always free.

## 2. Bind the custom domain

Still in the bucket → **Settings** → **Public access** → **Custom Domains** →
**Connect Domain** → enter `media.junkyardbutcher.com` → Continue.

Your DNS is already on Cloudflare, so it creates the record itself. Wait for
**Active** (usually under a minute).

> Do **not** use the `r2.dev` URL instead. Cloudflare rate-limits it, calls it
> development-only, and it bypasses CDN caching entirely.

## 3. Set CORS

Bucket → **Settings** → **CORS policy** → **Edit** → paste the contents of
`r2-cors.json` from this folder → Save.

This is the single most common reason this setup "silently doesn't work."
`hls.js` fetches manifests and segments with `fetch()`; without CORS every
video fails with a black frame and an error most people never look for.

## 4. Create an R2 API token

R2 overview page → **Manage R2 API Tokens** → **Create API Token**

- Permissions: **Object Read & Write**
- Scope: only the `jb-media` bucket
- TTL: whatever you like

Copy the **Access Key ID**, **Secret Access Key**, and your **Account ID** —
the secret is shown exactly once.

## 5. Point rclone at it

```
rclone config
```

- `n` (new remote), name: **`r2`**
- Storage: **`s3`**
- Provider: **`Cloudflare`**
- `access_key_id`: your Access Key ID
- `secret_access_key`: your Secret Access Key
- Region: **`auto`**
- Endpoint: `https://<YOUR_ACCOUNT_ID>.r2.cloudflarestorage.com`
- Leave the rest blank, `q` to quit

Verify:

```
rclone lsd r2:
```

You should see `jb-media`. The credentials live in rclone's own config file,
never in this repo.

---

## 6. Encode and publish a reel

Pull the master down from the **"Junkyardbutcher assets"** folder in Google
Drive, then:

```
./encode-reel.sh "/c/Users/cvalt/Downloads/Cvalt ad, .mov" cvalt
./publish-reel.sh cvalt
```

Start with CVALT — it's the flagship case study and the one with the numbers.

`encode-reel.sh` reads the source and adapts: it strips baked-in letterbox bars,
picks ladder rungs the footage can actually fill (never upscales, and the top
rung is the source's own resolution capped at 1080), matches GOP to the real
frame rate, handles vertical or horizontal, and works with or without audio.

**Letterbox:** several of the older masters are a widescreen picture exported
inside a 4:3 frame with hard black bars — `Cvalt ad, .mov` is 1440×1080 holding
a 1440×810 image. The script detects that and crops before encoding, so you
aren't paying bitrate for black. It prints `letterbox detected:` when it fires.
If a master is *meant* to be matted, skip it:

```
NOCROP=1 ./encode-reel.sh "/path/to/master.mov" some-slug
```

Output per reel:

| file | what it's for |
|---|---|
| `master.m3u8` | the URL `<jb-video>` loads |
| `1080/ 720/ 540/` | renditions + 4s segments |
| `fallback.mp4` | progressive, used if HLS fails |
| `poster.jpg` | the tile image |
| `loop.mp4` | silent 6s teaser (Tier A tiles) |

## 7. Smoke test

```
curl -I -H "Origin: https://junkyardbutcher.com" \
  https://media.junkyardbutcher.com/reels/cvalt/v1/master.m3u8
```

Want: `200`, `content-type: application/vnd.apple.mpegurl`, and an
`access-control-allow-origin` header. If that header is missing, CORS didn't
save — redo step 3.

---

## Slugs

Keep these stable; the player references them.

| slug | master in Drive |
|---|---|
| `cvalt` | Cvalt ad, .mov |
| `premium-blossom` | Premium blossom homegrown harvest.mov |
| `kannabis` | Kannabis, interactive reel ig.mov |
| `kannabis-tyson` | Tyson Hashhole kannabis reel.mov |
| `herb-and-joy` | Herb and joy trilogy tease.mov |
| `jb-sting` | Junkyardbutcher original logo sting.mov |

## Re-cutting a reel

Publish to a new version so no cache has to expire:

```
./encode-reel.sh "/path/to/new-cut.mov" cvalt
./publish-reel.sh cvalt v2
```

Then point the player at `.../cvalt/v2/master.m3u8`.
