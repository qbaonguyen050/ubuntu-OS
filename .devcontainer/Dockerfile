# Use the base Ubuntu image
FROM mcr.microsoft.com/devcontainers/base:jammy

# Set the locale to en_US.UTF-8 to prevent language selection prompt
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
RUN sudo apt-get update && sudo apt-get install -y locales && sudo locale-gen en_US.UTF-8

# Install Ubuntu Desktop (XFCE), TigerVNC, and noVNC web client
RUN export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get -y install --no-install-recommends ubuntu-desktop xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify

# Create a startup script that will launch the VNC and web servers
RUN echo '#!/bin/bash\n\
export USER=$(whoami)\n\
# Start VNC server on display :1 with password "vscode"\n\
mkdir -p /home/vscode/.vnc\n\
echo "vscode" | vncpasswd -f > /home/vscode/.vnc/passwd\n\
chmod 600 /home/vscode/.vnc/passwd\n\
vncserver :1 -xstartup /usr/bin/xfce4-session -localhost no -geometry 1280x720 -SecurityTypes VncAuth -passwd /home/vscode/.vnc/passwd\n\
# Start the noVNC web client, listening on port 6080 and forwarding to VNC port 5901\n\
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the noVNC web port
EXPOSE 6080
