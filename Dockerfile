FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Pacotes necessários
RUN apt-get update && apt-get install -y \
    wget curl git sudo \
    xvfb x11vnc novnc websockify \
    pulseaudio dbus-x11 \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Pasta app
WORKDIR /app

COPY start.sh .
RUN chmod +x start.sh

EXPOSE 3000

CMD ["bash", "start.sh"]