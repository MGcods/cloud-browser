#!/bin/bash

export DISPLAY=:1

echo "Starting virtual display..."

# Display virtual otimizado
Xvfb :1 -screen 0 1024x576x24 &

# Esperar X iniciar MESMO
until xdpyinfo -display :1 >/dev/null 2>&1; do
  echo "Waiting for X display..."
  sleep 1
done

echo "Starting window manager..."
fluxbox &

sleep 3

echo "Starting PulseAudio..."
pulseaudio --start

sleep 2

echo "Starting VNC (low latency mode)..."

x11vnc \
  -display :1 \
  -nopw \
  -forever \
  -shared \
  -rfbport 5900 \
  -noxdamage \
  -ncache 10 \
  -ncache_cr \
  -wait 5 \
  -threads \
  -xkb \
  -repeat \
  -nowf \
  -noscr \
  -quiet &

sleep 2

echo "Launching Chrome..."

google-chrome \
  --no-sandbox \
  --disable-gpu \
  --disable-dev-shm-usage \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --autoplay-policy=no-user-gesture-required \
  --enable-low-end-device-mode \
  --start-maximized \
  https://twitch.tv &

sleep 2

echo "Starting noVNC web client..."

websockify --web=/usr/share/novnc/ 3000 localhost:5900