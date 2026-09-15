#!/usr/bin/env bash
cd "$(dirname "$0")"
M="/c/Users/cvalt/Downloads/Cvalt ad, .mov"
echo "sampling the timeline for letterboxing (1440x1080 source, 81s)"
echo "crop=1440:810 means matted, crop=1440:1080 means full frame"
echo
for T in 1 3 6 12 20 30 40 50 60 70 78; do
  printf "%3ss : " "$T"
  ffmpeg -hide_banner -ss "$T" -i "$M" -vf "cropdetect=limit=24:round=2:reset=1" \
    -frames:v 12 -f null - 2>&1 | grep -o 'crop=[^ ]*' | tail -1
done
