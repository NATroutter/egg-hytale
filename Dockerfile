FROM --platform=$TARGETOS/$TARGETARCH ghcr.io/parkervcp/yolks:java_25

LABEL author="NATroutter" maintainer="contact@natroutter.fi"
LABEL org.opencontainers.image.source="https://github.com/NATroutter/egg-hytale"
LABEL org.opencontainers.image.description="Container for running hytale game servers"
LABEL org.opencontainers.image.licenses=MIT

# Work as root for setup
USER root

# Copy Pterodactyl entrypoint
COPY --from=ghcr.io/parkervcp/yolks:java_25 --chmod=755 /entrypoint.sh /entrypoint.sh

# Install dependencies
RUN apt update -y && apt install -y unzip jq curl net-tools && rm -rf /var/lib/apt/lists/*

# Copy entry.sh as root-owned (so container user can't modify it)
COPY --chmod=755 ./entry.sh /entry.sh
RUN sed -i 's/\r$//' /entry.sh

# Copy start.sh to /usr/local/bin (protected location, won't be overridden by volume mounts)
COPY --chmod=755 ./start.sh /usr/local/bin/start.sh
RUN sed -i 's/\r$//' /usr/local/bin/start.sh

# Copy hibernation monitor script to /usr/local/bin
COPY --chmod=755 ./hibernation-monitor.sh /usr/local/bin/hibernation-monitor.sh
RUN sed -i 's/\r$//' /usr/local/bin/hibernation-monitor.sh

# Switch to container user ONLY for runtime
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

#Start the container
CMD ["/bin/bash", "/entry.sh"]