#!/bin/sh

[ -f /run/secrets/URL ] && URL="$(cat /run/secrets/URL)"
URL="${URL:-https://www.docker.com/}"

if [ ! -z "$EVAL_URL" ]; then URL=$(eval "echo ${URL}"); fi;

rm -rf $HOME/.cache/chromium
rm -rf $HOME/.config/chromium

# /usr/bin/google-chrome-stable
/usr/bin/chromium-browser ${EXTRA_CHROME_OPTION} \
 --purge-memory-button \
 --clear-token-service \
 --disable-3d-apis \
 --disable-accelerated-video \
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
