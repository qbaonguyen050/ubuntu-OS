# Use the Debian 11 (Bullseye) base image, the same foundation as Whonix
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# --- LAYER 1: Install all software packages ---
# This installs the XFCE desktop, VNC tools, and the Tor service
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    tor && \
    # Clean up apt cache
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# --- LAYER 2: Configure the VNC user and password ---
RUN mkdir -p /home/vscode/.vnc && \
    echo "vscode" | /usr/bin/vncpasswd -f > /home/vscode/.vnc/passwd && \
    chmod 600 /home/vscode/.vnc/passwd && \
    chown -R vscode:vscode /home/vscode/.vnc

# --- LAYER 3: Create the startup script ---
# This script now also starts the Tor service in the background
RUN echo '#!/bin/bash\n\
# Clean up old VNC lock files\n\
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1\n\
# Start the Tor service\n\
sudo service tor start\n\
# Start VNC server\n\
/usr/bin/vncserver :1 -xstartup /usr/bin/xfce4-session -localhost no -geometry 1280x720 -SecurityTypes VncAuth -passwd /home/vscode/.vnc/passwd\n\
# Start the noVNC web client\n\
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the noVNC web port
EXPOSE 6080