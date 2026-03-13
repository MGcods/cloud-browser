FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    supervisor \
    xvfb \
    pulseaudio \
    dbus-x11 \
    x11-xserver-utils \
    ffmpeg \
    python3 \
    python3-pip \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# instalar Selkies WebRTC
RUN pip install selkies

COPY start.sh /start.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]