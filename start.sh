#!/bin/bash

echo "Starting virtual display..."

# Display virtual
Xvfb :1 -screen 0 1280x720x24 &
export DISPLAY=:1

sleep 2

echo "Starting PulseAudio..."
pulseaudio --start

echo "Starting Chromium..."

chromium-browser \
  --no-sandbox \
  --disable-gpu \
  --autoplay-policy=no-user-gesture-required \
  https://twitch.tv &

echo "Starting VNC server..."

x11vnc -display :1 -nopw -forever -shared -rfbport 5900 &

echo "Starting noVNC web client..."

websockify --web=/usr/share/novnc/ 3000 localhost:5900