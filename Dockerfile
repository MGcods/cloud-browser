FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    wget \
    curl \
    dbus-x11 \
    x11-utils \
    net-tools \
    python3 \
    python3-pip \
    git \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && apt install -y ./google-chrome-stable_current_amd64.deb \
 && rm google-chrome-stable_current_amd64.deb

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
 && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

# Improve websocket speed
RUN pip3 install numpy

WORKDIR /app

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]