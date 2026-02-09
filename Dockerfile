FROM alpine:latest

RUN apk update && apk add \
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
    busybox-extras

RUN echo "alias ll='ls -lah'" >> /root/.bashrc

WORKDIR /root

CMD [ "sleep", "infinity" ]