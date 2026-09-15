#!/usr/bin/env bash
# =============================================================
#  Junkyard Butcher — reel encoder
#  One master in, an HLS ladder + poster + loop + fallback out.
#
#  usage:  ./encode-reel.sh "/path/to/Cvalt ad, .mov" cvalt
#
#  output: dist/<slug>/
#            master.m3u8      <- the URL <jb-video> loads
#            1080/ 720/ 540/  <- only the rungs the source supports
#            fallback.mp4     <- progressive, if HLS fails
#            poster.jpg
#            loop.mp4         <- silent 6s tile teaser (Tier A)
#
#  Works on vertical or horizontal source, with or without audio,
#  at any frame rate. Never upscales.
# =============================================================
set -euo pipefail

IN="${1:-}"; SLUG="${2:-}"

if [ -z "$IN" ] || [ -z "$SLUG" ]; then
  echo "usage: $0 <master-file> <slug>" >&2; exit 1
fi
[ -f "$IN" ] || { echo "no such file: $IN" >&2; exit 1; }
command -v ffmpeg  >/dev/null || { echo "ffmpeg not found -> winget install Gyan.FFmpeg" >&2; exit 1; }
command -v ffprobe >/dev/null || { echo "ffprobe not found (ships with ffmpeg)" >&2; exit 1; }

OUT="dist/$SLUG"
rm -rf "$OUT"; mkdir -p "$OUT"

# ---------- read the source, assume nothing -------------------
FPS_RAW=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 "$IN")
FPS=$(awk -F/ '{ printf "%d", ($2 ? $1/$2 : $1) + 0.5 }' <<< "$FPS_RAW")
[ "${FPS:-0}" -gt 0 ] 2>/dev/null || FPS=30
GOP=$((FPS * 2))                    # 2s GOP — segments must land on keyframes

W=$(ffprobe -v error -select_streams v:0 -show_entries stream=width  -of csv=p=0 "$IN")
H=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$IN")
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$IN" | cut -d. -f1)
HAS_AUDIO=$(ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$IN" | head -n1)

# ---------- strip baked-in letterbox --------------------------
# Old exports often carry a widescreen picture inside a 4:3 frame with hard
# black bars. Encoding those wastes bitrate and breaks the tile aspect.
# Set NOCROP=1 to skip (e.g. a deliberately matted, cinematic look).
CROP=""
if [ "${NOCROP:-0}" != "1" ]; then
  # Sample several points and take the MOST COMMON result. Never use reset=0
  # over a long span: cropdetect then reports the union across frames, so a
  # single bright transition makes a genuinely matted reel look full-frame.
  SAMPLES=""
  for frac in 5 15 25 40 55 70 85; do
    T=$(( ${DUR:-0} * frac / 100 ))
    C=$(ffmpeg -hide_banner -ss "$T" -i "$IN" \
          -vf "cropdetect=limit=24:round=2:reset=1" -frames:v 12 -f null - 2>&1 \
        | grep -o 'crop=[0-9]\+:[0-9]\+:[0-9]\+:[0-9]\+' | tail -n1)
    # drop fades and dark-edged shots — they skew the vote
    if [ -n "$C" ]; then
      cw=$(echo "$C" | cut -d= -f2 | cut -d: -f1)
      ch=$(echo "$C" | cut -d= -f2 | cut -d: -f2)
      if [ "$cw" -ge $(( W * 80 / 100 )) ] && [ "$ch" -ge $(( H * 40 / 100 )) ]; then
        SAMPLES="${SAMPLES}${C}
"
      fi
    fi
  done
  DET=$(printf '%s' "$SAMPLES" | grep -v '^$' | sort | uniq -c | sort -rn | head -n1 | awk '{print $2}')
  if [ -n "$DET" ]; then
    CW=$(echo "$DET" | cut -d= -f2 | cut -d: -f1)
    CH=$(echo "$DET" | cut -d= -f2 | cut -d: -f2)
    if [ "${CW:-0}" -gt 0 ] && [ "${CH:-0}" -gt 0 ]; then
      # only act if it removes more than 2% of a dimension — ignore noise
      if [ $((W - CW)) -gt $((W / 50)) ] || [ $((H - CH)) -gt $((H / 50)) ]; then
        CROP="${DET},"
        echo "   letterbox detected: ${W}x${H} -> ${CW}x${CH} (bars stripped)"
        W=$CW; H=$CH
      fi
    fi
  fi
fi

SHORT=$(( W < H ? W : H ))          # vertical -> width, horizontal -> height

# ---------- build a ladder the source can actually fill -------
# Top rung is the source's own short side, capped at 1080 — so an 810-tall
# master serves 810, not a needlessly downscaled 720. Bitrate scales with
# pixel count off the 1080/3500k anchor.
TOP=$(( SHORT < 1080 ? SHORT : 1080 ))
TOPRATE=$(( 3500 * TOP * TOP / (1080 * 1080) ))
[ "$TOPRATE" -lt 600 ] && TOPRATE=600

RUNGS=("$TOP"); RATES=("$TOPRATE")
# add the standard lower rungs, but only if meaningfully below the top
for pair in "720:1800" "540:900"; do
  px=${pair%%:*}; kb=${pair##*:}
  if [ "$px" -le $(( TOP * 85 / 100 )) ]; then RUNGS+=("$px"); RATES+=("$kb"); fi
done
N=${#RUNGS[@]}

echo "-> $SLUG"
echo "   source : ${W}x${H} @ ${FPS}fps, ${DUR:-?}s, audio=$([ -n "$HAS_AUDIO" ] && echo yes || echo no)"
echo "   ladder : ${RUNGS[*]}  (GOP=$GOP, 4s segments)"

# scale by the short side, never upscale, keep dimensions even
sc () { echo "scale=w='if(gt(ih,iw),min($1\,iw),-2)':h='if(gt(ih,iw),-2,min($1\,ih))'"; }

# ---------- assemble the ffmpeg invocation --------------------
FILTER="[0:v]split=${N}"
for i in $(seq 0 $((N-1))); do FILTER+="[v$i]"; done
FILTER+=";"
for i in $(seq 0 $((N-1))); do FILTER+="[v$i]${CROP}$(sc "${RUNGS[$i]}")[o$i];"; done
FILTER="${FILTER%;}"

MAPS=(); VAR=""
for i in $(seq 0 $((N-1))); do
  r=${RATES[$i]}
  MAPS+=( -map "[o$i]" -c:v:$i libx264 -b:v:$i "${r}k" -maxrate:v:$i "$((r*107/100))k" -bufsize:v:$i "$((r*15/10))k" )
  if [ -n "$HAS_AUDIO" ]; then VAR+="v:$i,a:$i "; else VAR+="v:$i "; fi
done
VAR="${VAR% }"

AUD=()
if [ -n "$HAS_AUDIO" ]; then
  for _ in $(seq 1 "$N"); do AUD+=( -map a:0 ); done
  AUD+=( -c:a aac -b:a 128k -ac 2 )
fi

ffmpeg -hide_banner -loglevel warning -stats -i "$IN" \
  -filter_complex "$FILTER" \
  "${MAPS[@]}" "${AUD[@]}" \
  -preset slow -profile:v high -pix_fmt yuv420p \
  -x264-params "keyint=${GOP}:min-keyint=${GOP}:scenecut=0" \
  -f hls -hls_time 4 -hls_playlist_type vod \
  -hls_flags independent_segments -hls_segment_type mpegts \
  -hls_segment_filename "$OUT/%v/seg_%03d.ts" \
  -master_pl_name master.m3u8 \
  -var_stream_map "$VAR" "$OUT/%v/index.m3u8"

# ffmpeg writes variant dirs as 0/1/2 — give them real names
for i in $(seq 0 $((N-1))); do
  [ -d "$OUT/$i" ] && mv "$OUT/$i" "$OUT/tmp_${RUNGS[$i]}"
done
for i in $(seq 0 $((N-1))); do
  [ -d "$OUT/tmp_${RUNGS[$i]}" ] && mv "$OUT/tmp_${RUNGS[$i]}" "$OUT/${RUNGS[$i]}"
  sed -i "s|^$i/|${RUNGS[$i]}/|" "$OUT/master.m3u8"
done

# ---------- progressive fallback ------------------------------
FB=${RUNGS[$((N-1))]}; [ "$N" -gt 1 ] && FB=720
ffmpeg -hide_banner -loglevel error -i "$IN" \
  -vf "${CROP}$(sc "$FB")" -c:v libx264 -crf 23 -preset slow -profile:v high -pix_fmt yuv420p \
  $([ -n "$HAS_AUDIO" ] && echo "-c:a aac -b:a 128k -ac 2" || echo "-an") \
  -movflags +faststart "$OUT/fallback.mp4"

# ---------- poster: a real frame, not frame zero --------------
SEEK=00:00:00.5; [ "${DUR:-0}" -gt 3 ] 2>/dev/null && SEEK=00:00:01.5
ffmpeg -hide_banner -loglevel error -ss "$SEEK" -i "$IN" \
  -frames:v 1 -vf "${CROP}$(sc 1080)" -q:v 3 "$OUT/poster.jpg"

# ---------- Tier A silent loop for the tile -------------------
ffmpeg -hide_banner -loglevel error -i "$IN" -t 6 -an \
  -vf "${CROP}$(sc 640),fps=24" -c:v libx264 -crf 30 -preset slow \
  -movflags +faststart "$OUT/loop.mp4"

echo; echo "done -> $OUT  ($(du -sh "$OUT" | cut -f1))"
echo "check it:  ffplay $OUT/master.m3u8"
