#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

echo "Starting virtual display..."
Xvfb :1 -screen 0 1024x576x24 &

# Esperar X iniciar MESMO
until xdpyinfo -display :1 >/dev/null 2>&1; do
  echo "Waiting for X display..."
  sleep 1
done

echo "Starting window manager..."
fluxbox &

# Esperar Fluxbox iniciar (verifica se X está pronto para janelas)
until xprop -root >/dev/null 2>&1; do
  sleep 1
done

echo "Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1 --daemonize=yes

# Esperar PulseAudio estar pronto
sleep 1

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

# Esperar VNC estar pronto
sleep 1

echo "Launching Chrome..."
google-chrome \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --no-first-run \
  --no-default-browser-check \
  --autoplay-policy=no-user-gesture-required \
  --enable-low-end-device-mode \
  --user-data-dir=/tmp/chrome \
  --start-maximized \
  https://google.com &

# Esperar Chrome iniciar
sleep 1

echo "Starting noVNC web client..."
/usr/share/novnc/utils/websockify/websockify --web=/usr/share/novnc/ 3000 localhost:5900