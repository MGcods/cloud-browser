#!/bin/bash

export DISPLAY=:1

echo "Starting DBus..."
mkdir -p /run/dbus
dbus-daemon --system --fork

#################################
# Create VNC password automatically
#################################
mkdir -p ~/.vnc

echo "Setting VNC password..."
echo "cloud" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

#################################
# VNC session startup
#################################
cat <<EOF > ~/.vnc/xstartup
#!/bin/bash

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XDG_RUNTIME_DIR=/tmp/runtime-root
mkdir -p \$XDG_RUNTIME_DIR

# start window manager (IMPORTANT: keep foreground)
exec fluxbox
EOF

sleep 5

echo "Launching Chrome..."

DISPLAY=:1 google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --start-maximized \
  https://www.google.com &

chmod +x ~/.vnc/xstartup

#################################
# Start TigerVNC
#################################
echo "Starting TigerVNC server..."

vncserver :1 \
  -geometry 1280x720 \
  -depth 24 \
  -SecurityTypes VncAuth

sleep 3

#################################
# Start noVNC
#################################
echo "Starting noVNC proxy..."

/opt/novnc/utils/novnc_proxy \
  --vnc localhost:5901 \
  --listen 3000