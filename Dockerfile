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
    curl \FROM debian:bookworm-slim

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
    python3-venv \
    python3-pip \
    ca-certificates \
    fonts-liberation \
    curl \
    && rm -rf /var/lib/apt/lists/*

# criar virtualenv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# instalar selkies
RUN pip install --upgrade pip
RUN pip install selkies-gstreamer

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]
    && rm -rf /var/lib/apt/lists/*

# instalar WebRTC streamer
RUN pip3 install selkies-gstreamer

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]