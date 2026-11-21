FROM --platform=$TARGETOS/$TARGETARCH eclipse-temurin:25.0.5.1_2-jre-noble
#FROM --platform=$TARGETOS/$TARGETARCH eclipse-temurin:25.0.2_10-jre-noble

# Metadata
LABEL author="NATroutter" maintainer="contact@natroutter.fi"
LABEL org.opencontainers.image.source="https://github.com/NATroutter/egg-hytale"
LABEL org.opencontainers.image.description="Container for running hytale game servers"
LABEL org.opencontainers.image.licenses=MIT

# Switch to root user for installation
USER root

# Install necessary dependencies
RUN apt update -y \
	&& apt install -y \
	curl \
	lsof \
	ca-certificates \
	openssl \
	git \
	tar \
	sqlite3 \
	fontconfig \
	tzdata \
	iproute2 \
	libfreetype6 \
	tini \
	zip \
	unzip \
	ncurses-bin \
	jq

# Copy start.sh to /usr/local/bin (protected location, won't be overridden by volume mounts)
COPY --chmod=755 ./start.sh /usr/local/bin/start.sh

# Strip Windows line endings (\r) just in case the file was edited on Windows
RUN sed -i 's/\r$//' /usr/local/bin/start.sh

# Copy entrypoint script to root
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

# Strip Windows line endings (\r) just in case the file was edited on Windows
RUN sed -i 's/\r$//' /entrypoint.sh

# Create egg-hytale folder
RUN mkdir -p /egg-hytale

# Copy lib directory
COPY --chmod=755 ./lib /egg-hytale/lib
RUN sed -i 's/\r$//' /egg-hytale/lib/*.sh

# Create dmidecode shim for Docker usage
COPY --chmod=755 ./lib/dmidecode /usr/local/bin/dmidecode
RUN sed -i 's/\r$//' /usr/local/bin/dmidecode

RUN sed -i 's/\r$//' /entrypoint.sh

# Create the container user
RUN useradd -m -d /home/container -s /bin/bash container

# Switch to the container user
USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

# Ensure clean shutdown
STOPSIGNAL SIGINT

# Use tini as init process to handle signals correctly
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]
