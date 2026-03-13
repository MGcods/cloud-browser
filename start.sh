#!/bin/bash

export DISPLAY=:99

echo "Starting Xvfb..."
Xvfb :99 -screen 0 1280x720x24 &

sleep 2

echo "Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1

sleep 2

echo "Launching Chromium..."

chromium \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --window-size=1280,720 \
  https://www.google.com &

sleep 3

echo "Starting WebRTC stream..."

selkies-gstreamer \
  --display :99 \
  --port 3000 \
  --enable-audio