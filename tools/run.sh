#!/usr/bin/env bash
# Re-encode CVALT with fixed letterbox detection, publish as v3, verify.
# Run with:  sh run.sh
cd "$(dirname "$0")"
MASTER="/c/Users/cvalt/Downloads/Cvalt ad, .mov"

[ -f "$MASTER" ] || { echo "!! master not found: $MASTER"; exit 1; }

echo "======== 1. RE-ENCODE ========"
./encode-reel.sh "$MASTER" cvalt 2>&1 | tr '\r' '\n' | grep -vE '^frame=|^$' | tail -10

echo
echo "poster: $(ffprobe -v error -select_streams v:0 -show_entries stream=width,height \
  -of csv=p=0 dist/cvalt/poster.jpg)   <- want 1440x810"
echo -n "renditions: "; ls -d dist/cvalt/*/ | xargs -n1 basename | tr '\n' ' '; echo

echo
echo "======== 2. PUBLISH v3 ========"
./publish-reel.sh cvalt v3

echo
echo "======== 3. VERIFY ========"
curl -sI -H "Origin: https://junkyardbutcher.com" \
  https://media.junkyardbutcher.com/reels/cvalt/v3/master.m3u8 \
  | grep -Ei '^(HTTP|content-type|access-control-allow-origin)'
echo
curl -s https://media.junkyardbutcher.com/reels/cvalt/v3/master.m3u8 | grep RESOLUTION
echo
echo "^ want RESOLUTION=1440x810 and 960x540. No 1080 heights."
