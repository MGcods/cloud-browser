#!/bin/bash

export DISPLAY=:99

echo "Starting Xvfb..."
Xvfb :99 -screen 0 1280x720x24 &

sleep 2

echo "Starting PulseAudio..."
pulseaudio --start

echo "Launching Chromium..."

chromium-browser \
  --no-sandbox \
  --disable-background-networking \
  --disable-sync \
  --disable-extensions \
  --disable-default-apps \
  --disable-gpu \
  --window-size=1280,720 \
  https://www.google.com &

sleep 2

echo "Starting WebRTC streamer..."

selkies \
  --display :99 \
  --port 3000 \
  --audio