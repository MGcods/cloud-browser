FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

#################################
# Base packages
#################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gnupg \
    git \
    ca-certificates \
    dbus-x11 \
    pulseaudio \
    pulseaudio-utils \
    xvfb \
    fluxbox \
    x11vnc \
    x11-utils \
    ffmpeg \
    python3 \
    python3-numpy \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    upower \
    && rm -rf /var/lib/apt/lists/*

#################################
# Install Google Chrome
#################################
RUN mkdir -p /etc/apt/keyrings \
 && wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /etc/apt/keyrings/google.gpg \
 && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list \
 && apt-get update \
 && apt-get install -y google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

#################################
# noVNC
#################################
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
 && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

#################################
# Startup
#################################
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000
EXPOSE 8090

CMD ["/start.sh"]