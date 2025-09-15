# Use Ubuntu 24.04 as base for stability and compatibility.
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Run as root for authoritative installations.
USER root

# Single RUN layer to minimize image size and prevent caching issues.
# Installs XFCE, VNC, noVNC, Firefox, and dbus-x11 with anti-corruption checks.
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
        dbus-x11 \
    && \
    # Anti-corruption: Verify critical binaries exist.
    which tigervncpasswd || (echo "Error: tigervncpasswd not found" && exit 1) && \
    which tigervncserver || (echo "Error: tigervncserver not found" && exit 1) && \
    which websockify || (echo "Error: websockify not found" && exit 1) && \
    which dbus-launch || (echo "Error: dbus-launch not found" && exit 1) && \
    # Create VNC config directory with strict permissions.
    mkdir -p /home/vscode/.vnc && \
    # Set VNC password securely (password: ubuntu).
    echo "ubuntu" | /usr/bin/tigervncpasswd -f > /home/vscode/.vnc/passwd && \
    chmod 600 /home/vscode/.vnc/passwd && \
    # Create robust xstartup script for XFCE.
    echo "#!/bin/bash" > /home/vscode/.vnc/xstartup && \
    echo "# Anti-corruption: Clear session variables to prevent XFCE issues." >> /home/vscode/.vnc/xstartup && \
    echo "unset SESSION_MANAGER" >> /home/vscode/.vnc/xstartup && \
    echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/vscode/.vnc/xstartup && \
    echo "# Ensure X11 socket directory." >> /home/vscode/.vnc/xstartup && \
    echo "mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix" >> /home/vscode/.vnc/xstartup && \
    echo "# Start D-Bus session." >> /home/vscode/.vnc/xstartup && \
    echo "dbus-launch --exit-with-session bash -c 'export DISPLAY=:1; startxfce4 &' > /home/vscode/.vnc/dbus.log 2>&1" >> /home/vscode/.vnc/xstartup && \
    echo "# Load X resources if present." >> /home/vscode/.vnc/xstartup && \
    echo "[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources" >> /home/vscode/.vnc/xstartup && \
    echo "# Start vncconfig for clipboard support." >> /home/vscode/.vnc/xstartup && \
    echo "vncconfig -iconic &" >> /home/vscode/.vnc/xstartup && \
    chmod 700 /home/vscode/.vnc/xstartup && \
    # Anti-corruption: Verify VNC config files.
    test -f /home/vscode/.vnc/passwd || (echo "Error: VNC passwd file not created" && exit 1) && \
    test -f /home/vscode/.vnc/xstartup || (echo "Error: VNC xstartup file not created" && exit 1) && \
    # Fix /tmp/.X11-unix permissions and ownership.
    mkdir -p /tmp/.X11-unix && \
    chown root:root /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    # Anti-corruption: Clean up to prevent stale caches or apt issues.
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose VNC (5901) and noVNC (6080) ports for local access.
EXPOSE 5901 6080

# Default to vscode user (mapped to 'codespace' UID 1000 in Codespaces).
USER vscode