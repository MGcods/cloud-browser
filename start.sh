#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

echo "Fixing machine-id..."
if [ ! -s /etc/machine-id ]; then
  dbus-uuidgen > /etc/machine-id
fi

echo "Fixing DNS..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

echo "Starting virtual display..."
Xvfb :1 -screen 0 1024x576x24 -ac +extension GLX +render -noreset &

echo "Waiting for X display..."
until xdpyinfo -display :1 >/dev/null 2>&1; do
  sleep 1
done

echo "Starting window manager..."
fluxbox &

sleep 2

echo "Starting PulseAudio..."
pulseaudio --start --exit-idle-time=-1 --daemonize=yes 2>/dev/null || true

sleep 2

echo "Starting VNC..."
x11vnc \
 -display :1 \
 -forever \
 -shared \
 -rfbport 5900 \
 -nopw \
 -noxdamage \
 -repeat \
 -xkb \
 -quiet &

sleep 2

echo "Launching Chrome..."
google-chrome \
 --no-sandbox \
 --disable-dev-shm-usage \
 --disable-gpu \
 --disable-software-rasterizer \
 --disable-features=VizDisplayCompositor \
 --disable-background-networking \
 --disable-background-timer-throttling \
 --disable-renderer-backgrounding \
 --disable-backgrounding-occluded-windows \
 --no-first-run \
 --no-default-browser-check \
 --autoplay-policy=no-user-gesture-required \
 --window-size=1024,576 \
 --user-data-dir=/tmp/chrome \
 https://google.com &

sleep 2

echo "Starting noVNC server..."
/opt/novnc/utils/novnc_proxy \
 --vnc localhost:5900 \
 --listen 3000 \
 --web /opt/novnc