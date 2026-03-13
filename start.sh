#!/bin/bash

export DISPLAY=:1

#################################
# FIX XAUTH (IMPORTANT)
#################################
touch ~/.Xauthority
xauth generate :1 . trusted

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

#################################
# VNC password
#################################
mkdir -p ~/.vnc
echo "cloud" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

#################################
# Desktop startup
#################################
cat <<EOF > ~/.vnc/xstartup
#!/bin/bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export DISPLAY=:1

fluxbox &

sleep 3

google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --start-maximized \
  https://www.google.com &
EOF

chmod +x ~/.vnc/xstartup

#################################
# Start VNC
#################################
echo "Starting TigerVNC server..."

vncserver :1 \
  -geometry 1280x720 \
  -depth 24 \
  -SecurityTypes VncAuth

sleep 5

#################################
# Start noVNC
#################################
echo "Starting noVNC proxy..."

/opt/novnc/utils/novnc_proxy \
  --vnc localhost:5901 \
  --listen 3000