# Use the base Ubuntu image
FROM mcr.microsoft.com/devcontainers/base:jammy

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install all packages and configure the VNC password in a single layer.
# Using the absolute path /usr/bin/vncpasswd ensures the command is found.
RUN sudo apt-get update && \
    echo "keyboard-configuration keyboard-configuration/layoutcode string us" | sudo debconf-set-selections && \
    sudo apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 && \
    # Pre-create the VNC password file using its full path
    mkdir -p /home/vscode/.vnc && \
    echo "vscode" | /usr/bin/vncpasswd -f > /home/vscode/.vnc/passwd && \
    chmod 600 /home/vscode/.vnc/passwd && \
    chown -R vscode:vscode /home/vscode/.vnc && \
    # Clean up apt cache
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# Create the startup script
RUN echo '#!/bin/bash\n\
# Clean up old VNC lock files that might prevent startup\n\
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1\n\
# Start VNC server (password file is already created in the image)\n\
/usr/bin/vncserver :1 -xstartup /usr/bin/xfce4-session -localhost no -geometry 1280x720 -SecurityTypes VncAuth -passwd /home/vscode/.vnc/passwd\n\
# Start the noVNC web client in the foreground\n\
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the noVNC web port
EXPOSE 6080