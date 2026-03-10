FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    pulseaudio \
    dbus-x11 \
    fluxbox \
    wget curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY start.sh .
RUN chmod +x start.sh

EXPOSE 3000

CMD ["bash", "start.sh"]