#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
dbus-daemon --system --fork

echo "Starting Xvfb..."
Xvfb :1 -screen 0 1280x720x24 &

sleep 2

echo "Starting Fluxbox..."
fluxbox &

sleep 2

echo "Starting PulseAudio..."
pulseaudio --start

echo "Starting x11vnc..."
x11vnc -display :1 \
       -rfbport 5900 \
       -forever \
       -shared \
       -nopw &

echo "Launching Chrome..."

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --window-size=1280,720 \
  https://www.google.com &

echo "Starting noVNC..."

/opt/novnc/utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen 3000