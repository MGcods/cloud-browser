FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xvfb x11vnc fluxbox \
    dbus dbus-x11 pulseaudio \
    wget curl ca-certificates \
    fonts-liberation fonts-dejavu fonts-noto \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# instalar chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
 && apt-get update \
 && apt-get install -y ./google-chrome-stable_current_amd64.deb \
 && rm google-chrome-stable_current_amd64.deb

# noVNC
RUN git clone https://github.com/novnc/noVNC.git /usr/share/novnc \
 && git clone https://github.com/novnc/websockify /usr/share/novnc/utils/websockify

RUN useradd -m clouduser
USER clouduser
WORKDIR /home/clouduser

ENV DISPLAY=:1
ENV LIBGL_ALWAYS_SOFTWARE=1

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]