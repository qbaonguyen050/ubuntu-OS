# Use Ubuntu 24.04 as base for stability.
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Run as root for installations.
USER root

# Single RUN layer for efficiency: Install XFCE, VNC, noVNC, and Firefox.
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        xfce4 \
        xfce4-goodies \
        tigervnc-standalone-server \
        tigervnc-tools \
        novnc \
        websockify \
        firefox \
    && \
    # Verify tigervncpasswd exists (from tigervnc-tools).
    which tigervncpasswd || (echo "tigervncpasswd not found" && exit 1) && \
    # Create VNC config for vscode user (standard in devcontainers; mapped to codespace runtime).
    mkdir -p /home/vscode/.vnc && \
    echo "ubuntu" | /usr/bin/tigervncpasswd -f > /home/vscode/.vnc/passwd && \
    chmod 600 /home/vscode/.vnc/passwd && \
    # xstartup script for XFCE session (fixes common DBus/session issues).
    echo "#!/bin/bash" > /home/vscode/.vnc/xstartup && \
    echo "unset SESSION_MANAGER" >> /home/vscode/.vnc/xstartup && \
    echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/vscode/.vnc/xstartup && \
    echo "[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup" >> /home/vscode/.vnc/xstartup && \
    echo "[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources" >> /home/vscode/.vnc/xstartup && \
    echo "vncconfig -iconic &" >> /home/vscode/.vnc/xstartup && \
    echo "startxfce4 &" >> /home/vscode/.vnc/xstartup && \
    chmod +x /home/vscode/.vnc/xstartup && \
    # Clean up to keep image small.
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Default to vscode user (Codespaces maps this to 'codespace' UID 1000).
USER vscode

# Expose VNC port (5901) and noVNC port (6080) for local access.
EXPOSE 5901 6080