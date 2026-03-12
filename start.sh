#!/bin/bash

export DISPLAY=:1
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

# fix machine-id
dbus-uuidgen > /etc/machine-id

# DBus
echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

# Xvfb
echo "Starting virtual display..."
Xvfb :1 -screen 0 1024x576x24 &

# Esperar X iniciar
until xdpyinfo -display :1 >/dev/null 2>&1; do
  echo "Waiting for X display..."
  sleep 1
done

# Fluxbox
echo "Starting window manager..."
fluxbox &

sleep 2

# PulseAudio
echo "Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1 --daemonize=yes || echo "PulseAudio já em execução"

sleep 2

# x11vnc
echo "Starting VNC..."
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

# Chrome
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

sleep 2

# noVNC
echo "Starting noVNC web client..."
/opt/novnc/utils/websockify/run 3000 localhost:5900