#!/bin/bash

set -e

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

echo "Starting Xvfb..."

Xvfb :1 \
  -screen 0 1280x720x24 \
  -ac \
  -nolisten tcp \
  -dpi 96 &

# Wait for display
echo "Waiting for X display..."

until xdpyinfo -display :1 >/dev/null 2>&1
do
  sleep 1
done

echo "X display ready"

echo "Starting Fluxbox..."
fluxbox &

sleep 2

echo "Starting x11vnc..."

x11vnc \
 -display :1 \
  -forever \
  -shared \
  -nopw \
  -rfbport 5900 \
  -noxdamage \
  -repeat \
  -ncache 10 \
  -wait 20 \
  -bg

echo "Checking VNC port..."

sleep 2
netstat -tulpn | grep 5900 || echo "WARNING: VNC port not detected"

echo "Launching Chrome..."

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-extensions \
  --disable-background-networking \
  --disable-sync \
  --disable-translate \
  --disable-features=site-per-process \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --disable-client-side-phishing-detection \
  --disable-component-update \
  --disable-default-apps \
  --disable-domain-reliability \
  --disable-hang-monitor \
  --disable-popup-blocking \
  --disable-prompt-on-repost \
  --disable-ipc-flooding-protection \
  --disable-breakpad \
  --disable-features=TranslateUI \
  --no-first-run \
  --disable-infobars \
  --window-size=1280,720 \
  https://google.com &

sleep 2

echo "Starting noVNC..."

/opt/novnc/utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen ${PORT:-3000} \
  --web /opt/novnc