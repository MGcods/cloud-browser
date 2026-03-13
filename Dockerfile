FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
    pulseaudio \
    dbus-x11 \
    x11-xserver-utils \
    ffmpeg \
    python3 \
    python3-pip \
    ca-certificates \
    fonts-liberation \
    curl \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    && rm -rf /var/lib/apt/lists/*

# instalar selkies (compatível com Debian 12)
RUN pip3 install --upgrade pip --break-system-packages \
    && pip3 install --break-system-packages selkies-gstreamer

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]