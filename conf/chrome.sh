#!/bin/sh

[ -f /run/secrets/URL ] && URL="$(cat /run/secrets/URL)"
URL="${URL:-https://www.docker.com/}"
# /usr/bin/google-chrome-stable
/usr/bin/chromium-browser \
 --clear-token-service \
 --disable-background-mode \
 --disable-gpu \
 --disable-infobars \
 --disable-metrics \
 --disable-preconnect \
 --disable-speech-api \
 --disable-sync \
 --disable-sync-app-list \
 --disable-translate \
 --disable-voice-input \
 --disable-webgl \
 --disable-web-security \
 --force-device-scale-factor=1 \
 --ignore-certificate-errors \
 --load-extension=/home/chrome/plugin \
 --no-first-run \
 --no-pings \
 --no-sandbox \
 --reset-variation-state \
 --user-data-dir \
 --window-position=0,0 \
 --window-size=${X11_W},${X11_H} \
 "${URL}"
