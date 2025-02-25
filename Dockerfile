# Use a lightweight base image
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    bind-tools \
    netcat-openbsd \
    tcpdump \
    iputils \
    iproute2 \
    traceroute \
    jq \
    vim \
    openssl \
    busybox-extras \
    && rm -rf /var/cache/apk/*

# Set up alias for ll
RUN echo "alias ll='ls -lah'" >> /root/.bashrc

# Set the working directory
WORKDIR /root

# Set default command to sleep to keep the container running
CMD [ "sleep", "86400" ]
