#!/bin/bash

set -e

export DISPLAY=:1
export PORT=${PORT:-3000}

echo "Using port: $PORT"

# DBus
echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

# Virtual display
echo "Starting Xvfb..."
Xvfb :1 -screen 0 1280x720x24 &

# Wait for X
until xdpyinfo -display :1 >/dev/null 2>&1; do
  echo "Waiting for X server..."
  sleep 1
done

# Window manager
echo "Starting Fluxbox..."
fluxbox &

sleep 2

# PulseAudio
echo "Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1 --daemonize=yes || true

sleep 2

# VNC server
echo "Starting x11vnc..."
x11vnc \
  -display :1 \
  -nopw \
  -forever \
  -shared \
  -rfbport 5900 \
  -noxdamage \
  -repeat \
  -xkb \
  -quiet &

sleep 2

# Chrome
echo "Launching Chrome..."

google-chrome \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-software-rasterizer \
  --no-first-run \
  --no-default-browser-check \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --autoplay-policy=no-user-gesture-required \
  --user-data-dir=/tmp/chrome \
  --start-maximized \
  https://google.com &

sleep 3

# noVNC proxy
echo "Starting noVNC..."

/opt/novnc/utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen $PORT \
  --web /opt/novnc