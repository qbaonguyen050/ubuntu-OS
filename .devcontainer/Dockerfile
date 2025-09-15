# Use the Debian 11 (Bullseye) base image
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# --- LAYER 1: Install all software packages ---
# This installs the XFCE desktop, VNC tools, and Firefox.
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    tor \
    dbus-x11 \
    firefox-esr && \
    # Clean up apt cache
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# --- LAYER 2: Configure the VNC user, password, and xstartup script ---
RUN mkdir -p /home/vscode/.vnc && \
    echo "vscode" | /usr/bin/vncpasswd -f > /home/vscode/.vnc/passwd && \
    chmod 600 /home/vscode/.vnc/passwd && \
    # Create the xstartup file to properly launch XFCE with D-Bus
    echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
/usr/bin/dbus-launch --exit-with-session /usr/bin/xfce4-session\n\
' > /home/vscode/.vnc/xstartup && \
    chmod 755 /home/vscode/.vnc/xstartup && \
    chown -R vscode:vscode /home/vscode/.vnc

# --- LAYER 3: Create the main container startup script ---
RUN echo '#!/bin/bash\n\
# Clean up old VNC lock files\n\
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1\n\
# Start the Tor service\n\
sudo service tor start\n\
# Start VNC server\n\
/usr/bin/vncserver :1 -localhost no -geometry 1280x720 -SecurityTypes VncAuth -passwd /home/vscode/.vnc/passwd\n\
# Start the noVNC web client in the foreground\n\
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the VNC web port
EXPOSE 6080
