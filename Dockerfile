FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    xvfb \
    x11vnc \
    fluxbox \
    dbus-x11 \
    x11-utils \
    net-tools \
    python3 \
    python3-pip \
    git \
    supervisor \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcairo2 \
    libcups2 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libvulkan1 \
    libxkbcommon0 \
    xdg-utils \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install \
 && rm google-chrome-stable_current_amd64.deb

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
 && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Improve websocket performance
RUN pip3 install numpy

WORKDIR /app

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]