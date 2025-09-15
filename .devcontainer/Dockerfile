# Use the Debian 11 (Bullseye) base image
FROM mcr.microsoft.com/devcontainers/base:bullseye

# Set DEBIAN_FRONTEND to noninteractive to prevent all interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# --- LAYER 1: Install necessary packages ---
# We only need firefox-esr (as a backend for browsh), ttyd, tor, and curl.
RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
    firefox-esr \
    ttyd \
    tor \
    curl \
    ca-certificates && \
    # Clean up apt cache
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# --- LAYER 2: Manually download and install browsh ---
RUN curl -L "https://github.com/browsh-org/browsh/releases/download/v1.8.2/browsh_1.8.2_linux_amd64.deb" -o /tmp/browsh.deb && \
    sudo apt-get install -y /tmp/browsh.deb && \
    rm /tmp/browsh.deb

# --- LAYER 3: Create the main container startup script ---
# This starts the Tor service in the background and then launches the ttyd web terminal.
RUN echo '#!/bin/bash\n\
# Start the Tor service in the background\n\
sudo service tor start\n\
# Start ttyd web terminal in the foreground\n\
ttyd bash\n\
' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Expose the ttyd web terminal port
EXPOSE 7681