#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork
dbus-uuidgen > /etc/machine-id
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

###################################
# Virtual Display
###################################
echo "Starting Xvfb..."

Xvfb :1 -screen 0 1280x720x24 -nolisten tcp &

until xdpyinfo -display :1 >/dev/null 2>&1; do
  sleep 1
done

###################################
# Window manager
###################################
echo "Starting Fluxbox..."

fluxbox >/dev/null 2>&1 &

sleep 3

###################################
# PulseAudio
###################################
echo "Starting PulseAudio..."

pulseaudio \
  --system \
  --daemonize=yes \
  --disallow-exit \
  --exit-idle-time=-1 \
  --no-cpu-limit \
  --log-target=stderr

sleep 2

###################################
# Create virtual audio sink
###################################
echo "Creating audio sink..."

pactl load-module module-null-sink sink_name=chrome_sink sink_properties=device.description=chrome_sink

sleep 2

###################################
# VNC
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
  -rfbwait 50 \
  -speeds lan \
  -encodings tight copyrect hextile \
  -quality 6 \
  -compresslevel 5

sleep 2

###################################
# Launch Chrome
###################################
echo "Launching Chrome..."

google-chrome \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-oom-score-adjustment \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-extensions \
  --disable-features=VizDisplayCompositor \
  --renderer-process-limit=2 \
  --no-first-run \
  --no-default-browser-check \
  --autoplay-policy=no-user-gesture-required \
  --user-data-dir=/tmp/chrome \
  --start-maximized \
  https://www.google.com &

sleep 5

###################################
# AUDIO STREAM SERVER
###################################
echo "Starting audio stream..."

ffmpeg \
 -f pulse \
 -i chrome_sink.monitor \
 -ac 2 \
 -ar 44100 \
 -f mp3 \
 -listen 1 \
 http://0.0.0.0:8090/audio.mp3 \
 >/dev/null 2>&1 &

###################################
# noVNC
###################################
echo "Starting noVNC..."

/opt/novnc/utils/novnc_proxy \
 --vnc localhost:5900 \
 --listen 3000 \
 --web /opt/novnc