# Use the base Ubuntu image
FROM mcr.microsoft.com/devcontainers/base:jammy

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts during apt-get install.
# Also set the locale to en_US.UTF-8.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Update, generate locale, pre-configure keyboard, and install all packages in a single command layer
RUN sudo apt-get update && \
    sudo apt-get install -y locales && \
    sudo locale-gen en_US.UTF-8 && \
    # Pre-configure keyboard layout to US to prevent prompts
    echo "keyboard-configuration keyboard-configuration/layoutcode string us" | sudo debconf-set-selections && \
    # Install the desktop environment and VNC tools
    sudo apt-get install -y --no-install-recommends \
    ubuntu-desktop \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    novnc \
    websockify && \
    # Clean up apt cache to reduce image size
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

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
