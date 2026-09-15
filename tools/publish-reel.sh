#!/usr/bin/env bash
# =============================================================
#  Junkyard Butcher — push an encoded reel to Cloudflare R2
#
#  usage:  ./publish-reel.sh cvalt
#          ./publish-reel.sh cvalt v2      # re-cut, new version folder
#
#  Publishes to:  r2:jb-media/reels/<slug>/<version>/
#  Player URL:    https://media.junkyardbutcher.com/reels/<slug>/<version>/master.m3u8
#
#  Versioned paths mean a re-cut never fights a stale CDN cache.
# =============================================================
set -euo pipefail

SLUG="${1:-}"; VERSION="${2:-v1}"
REMOTE="r2"
BUCKET="jb-media"

[ -n "$SLUG" ] || { echo "usage: $0 <slug> [version]" >&2; exit 1; }
SRC="dist/$SLUG"
[ -d "$SRC" ] || { echo "no encode at $SRC — run ./encode-reel.sh first" >&2; exit 1; }
command -v rclone >/dev/null || { echo "rclone not found -> winget install Rclone.Rclone" >&2; exit 1; }

rclone listremotes | grep -q "^${REMOTE}:$" || {
  echo "rclone remote '${REMOTE}' not configured. Run: rclone config" >&2
  echo "  name: r2 | type: s3 | provider: Cloudflare | region: auto" >&2
  echo "  endpoint: https://<ACCOUNT_ID>.r2.cloudflarestorage.com" >&2
  exit 1
}

DEST="${REMOTE}:${BUCKET}/reels/${SLUG}/${VERSION}"
echo "-> $SRC  =>  $DEST"

# Segments and stills are immutable at a versioned path — cache them for a year.
rclone copy "$SRC" "$DEST" --progress \
  --exclude "*.m3u8" \
  --header-upload "Cache-Control: public, max-age=31536000, immutable"

# Manifests get a short TTL so a fix goes live without a purge.
# Correct MIME matters here: Safari's native HLS refuses a wrong type.
rclone copy "$SRC" "$DEST" --progress \
  --include "*.m3u8" \
  --header-upload "Cache-Control: public, max-age=300" \
  --header-upload "Content-Type: application/vnd.apple.mpegurl"

echo
echo "live at:"
echo "  https://media.junkyardbutcher.com/reels/${SLUG}/${VERSION}/master.m3u8"
echo "  https://media.junkyardbutcher.com/reels/${SLUG}/${VERSION}/poster.jpg"
echo
echo "smoke test (expect 200 + the CORS header):"
echo "  curl -I -H 'Origin: https://junkyardbutcher.com' \\"
echo "    https://media.junkyardbutcher.com/reels/${SLUG}/${VERSION}/master.m3u8"
