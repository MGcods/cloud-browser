#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

echo "Preparing VNC environment..."

mkdir -p ~/.vnc

#################################
# VNC startup session
#################################
cat <<EOF > ~/.vnc/xstartup
#!/bin/bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

fluxbox &

sleep 2

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --no-first-run \
  --no-default-browser-check \
  --start-maximized \
  https://www.google.com &

EOF

chmod +x ~/.vnc/xstartup

echo "Starting TigerVNC server..."

vncserver :1 -geometry 1280x720 -depth 24

sleep 3

echo "Starting noVNC proxy..."

/opt/novnc/utils/novnc_proxy \
  --vnc localhost:5901 \
  --listen 3000