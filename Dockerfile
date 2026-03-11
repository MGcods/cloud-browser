# Dockerfile
FROM ubuntu:22.04

# Variáveis de ambiente
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y \
    wget curl git sudo xvfb fluxbox x11vnc python3 python3-pip \
    libnss3 libnspr4 libvulkan1 libgbm1 mesa-vulkan-drivers fonts-liberation \
    libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxrandr2 libgtk-3-0 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxfixes3 libxi6 libxtst6 libxrender1 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Instalar Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Instalar noVNC e websockify via tarballs
RUN mkdir -p /usr/share/novnc/utils/websockify \
    && curl -L https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz | tar xz --strip-components=1 -C /usr/share/novnc \
    && curl -L https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.tar.gz | tar xz --strip-components=1 -C /usr/share/novnc/utils/websockify

# Expor porta do noVNC
EXPOSE 6080

# Copiar start.sh para dentro do container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Definir diretório de trabalho
WORKDIR /usr/share/novnc

# Comando padrão: iniciar via start.sh
CMD ["/start.sh"]