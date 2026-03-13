FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    ca-certificates \
    pulseaudio \
    xvfb \
    dbus-x11 \
    x11-xserver-utils \
    ffmpeg \
    python3 \
    python3-pip \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# instalar chromium via debian repo
RUN echo "deb http://deb.debian.org/debian bullseye main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y chromium

# instalar selkies
RUN pip3 install selkies-gstreamer

COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]