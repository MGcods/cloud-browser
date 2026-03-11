#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork
dbus-uuidgen > /etc/machine-id
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

###################################
# Virtual Display (mais fluido)
###################################
echo "Starting Xvfb..."
Xvfb :1 -screen 0 960x540x24 -nolisten tcp &

until xdpyinfo -display :1 >/dev/null 2>&1; do
  sleep 1
done

###################################
# Window manager (sem terminal)
###################################
fluxbox >/dev/null 2>&1 &

# garantir WM pronto
sleep 4

###################################
# PulseAudio (Container Safe Mode)
###################################
echo "Starting PulseAudio..."

pulseaudio \
  --system \
  --daemonize=yes \
  --disallow-exit \
  --exit-idle-time=-1 \
  --no-cpu-limit \
  --log-target=stderr

# esperar audio ficar pronto
sleep 2

###################################
# VNC ULTRA SMOOTH
###################################
echo "Starting x11vnc..."

x11vnc \
  -display :1 \
  -nopw \
  -forever \
  -shared \
  -rfbport 5900 \
  -noxdamage \
  -wait 20 \
  -threads \
  -xkb \
  -repeat \
  -bg \
  -o /tmp/x11vnc.log \
  -rfbwait 50 \
  -speeds lan \
  -encodings tight copyrect hextile \
  -quality 6 \
  -compresslevel 5

sleep 2

###################################
# CHROME (modo cloud otimizado)
###################################
echo "Launching Chrome..."

google-chrome \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-gpu-compositing \
  --disable-software-rasterizer \
  --disable-features=UseSkiaRenderer \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --disable-smooth-scrolling \
  --disable-animations \
  --no-first-run \
  --no-default-browser-check \
  --renderer-process-limit=2 \
  --autoplay-policy=no-user-gesture-required \
  --user-data-dir=/tmp/chrome \
  --start-maximized \
  --homepage=https://www.google.com \
  https://www.google.com &

sleep 3

###################################
# AUDIO STREAM
###################################
echo "Starting audio stream..."

python3 -m http.server 8090 >/dev/null 2>&1 &

ffmpeg \
 -f pulse \
 -i chrome_sink.monitor \
 -ac 2 \
 -ar 44100 \
 -f mp3 \
 -content_type audio/mpeg \
 http://localhost:8090/audio.mp3 \
 >/dev/null 2>&1 &

###################################
# noVNC
###################################
echo "Starting noVNC..."

/opt/novnc/utils/novnc_proxy \
 --vnc localhost:5900 \
 --listen 3000 \
 --web /opt/novnc