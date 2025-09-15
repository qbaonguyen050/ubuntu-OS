# Use the Debian 11 (Bullseye) base image, the same foundation as Whonix
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# --- LAYER 1: Install all software packages ---
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
    curl \
    tar \
    libfontconfig1 && \
    # Clean up apt cache
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# --- LAYER 2: Download and install Tor Browser ---
RUN curl -L "https://www.torproject.org/dist/torbrowser/13.0.10/tor-browser-linux-x86_64-13.0.10.tar.xz" -o /tmp/tor.tar.xz && \
    tar -xvf /tmp/tor.tar.xz --strip-components=1 -C /opt/ && \
    rm /tmp/tor.tar.xz && \
    chown -R vscode:vscode /opt/tor-browser

# --- LAYER 3: Configure the VNC user, password, and xstartup script ---
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

# --- LAYER 4: Create the main container startup script ---
RUN echo '#!/bin/bash\n\
# Clean up old VNC lock files\n\
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1\n\
# Start the Tor service\n\
sudo service tor start\n\
# Start VNC server (it will automatically use the xstartup file we created)\n\
/usr/bin/vncserver :1 -localhost no -geometry 1280x720 -SecurityTypes VncAuth -passwd /home/vscode/.vnc/passwd\n\
# Start the noVNC web client\n\
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5901\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the noVNC web port
EXPOSE 6080