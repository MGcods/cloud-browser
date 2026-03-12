FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

#################################
# Base packages
#################################
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    fluxbox \
    dbus-x11 \
    xvfb \
    pulseaudio \
    ffmpeg \
    python3 \
    python3-pip \
    ca-certificates \
    gnupg \
    tigervnc-standalone-server \
    tigervnc-common \
    && rm -rf /var/lib/apt/lists/*

#################################
# Install Google Chrome
#################################
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /usr/share/keyrings/google.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list \
 && apt-get update \
 && apt-get install -y google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

#################################
# Install noVNC
#################################
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
 && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify

#################################
# Copy start script
#################################
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

CMD ["/start.sh"]