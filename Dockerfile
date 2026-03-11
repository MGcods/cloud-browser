FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Atualização básica e instalação de pacotes
RUN apt-get update && apt-get install -y \
    xvfb \
    fluxbox \
    x11vnc \
    wget \
    curl \
    unzip \
    pulseaudio \
    dbus \
    sudo \
    ca-certificates \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    net-tools \
    wget \
    vim \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Instalação do Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
 && apt-get update && apt-get install -y google-chrome-stable \
 && rm -rf /var/lib/apt/lists/*

# Instala noVNC
RUN mkdir -p /opt/novnc && \
    wget -qO- https://github.com/novnc/noVNC/archive/refs/heads/master.tar.gz | tar xz --strip-components=1 -C /opt/novnc && \
    chmod +x /opt/novnc/utils/websockify/run

# Copiar start.sh e dar permissão
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900 3000

CMD ["/start.sh"]