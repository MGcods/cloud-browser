FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

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
    && rm -rf /var/lib/apt/lists/*

# instalar WebRTC streamer
RUN pip3 install selkies-gstreamer

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]