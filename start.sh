#!/bin/bash

echo "Starting virtual display..."

# iniciar display virtual
Xvfb :1 -screen 0 1280x720x24 &
export DISPLAY=:1

# esperar X iniciar (IMPORTANTE)
sleep 5

echo "Starting window manager..."
fluxbox &

sleep 2

echo "Starting PulseAudio..."
pulseaudio --start

sleep 2

echo "Launching Chromium..."

chromium \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --autoplay-policy=no-user-gesture-required \
  https://twitch.tv &

sleep 3

echo "Starting VNC..."
x11vnc -display :1 -nopw -forever -shared -rfbport 5900 &

echo "Starting noVNC..."
websockify --web=/usr/share/novnc/ 3000 localhost:5900