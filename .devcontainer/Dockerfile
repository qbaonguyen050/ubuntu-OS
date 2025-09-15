# Use the base Ubuntu image
FROM mcr.microsoft.com/devcontainers/base:jammy

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update, pre-configure keyboard, and install a minimal set of packages for a lightweight desktop.
# This is much faster than installing the full 'ubuntu-desktop'.
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
    # Clean up apt cache to reduce image size
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# Create a startup script that will launch the VNC and web servers
# Using absolute paths like /usr/bin/vncpasswd makes the script more robust.
RUN echo '#!/bin/bash\n\
export USER=$(whoami)\n\
export DISPLAY=:1\n\
# Set VNC password to "vscode"\n\
mkdir -p /home/vscode/.vnc\n\
echo "vscode" | /usr/bin/vncpasswd -f > /home/vscode/.vnc/passwd\n\
chmod 600 /home/vscode/.vnc/passwd\n\
# Start VNC server and the noVNC web client\n\
/usr/bin/vncserver :1 -xstartup /usr/bin/xfce4-session -localhost no -geometry 1280x720 -SecurityTypes VncAuth -passwd /home/vscode/.vnc/passwd\n\
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the noVNC web port
EXPOSE 6080