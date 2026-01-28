# ----------------------------
# Use a lightweight base image
# ----------------------------
FROM alpine:latest

# ----------------------------
# Install base utilities
# ----------------------------
RUN apk update && apk add --no-cache \
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
    ca-certificates \
    tar \
    gzip \
    && rm -rf /var/cache/apk/*

# ----------------------------
# Install kubectl
# ----------------------------
RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -L -o /usr/local/bin/kubectl \
    https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# ----------------------------
# Install Helm
# ----------------------------
RUN HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | jq -r .tag_name) && \
    curl -L -o helm.tar.gz \
    https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -xzf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf helm.tar.gz linux-amd64

# ----------------------------
# Install OpenShift oc
# ----------------------------
RUN OC_VERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt | grep '^Name:' | awk '{print $2}') && \
    curl -L -o oc.tar.gz \
    https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz && \
    tar -xzf oc.tar.gz && \
    mv oc kubectl /usr/local/bin/ && \
    chmod +x /usr/local/bin/oc /usr/local/bin/kubectl && \
    rm -rf oc.tar.gz README.md

# ----------------------------
# Set up alias for ll
# ----------------------------
RUN echo "alias ll='ls -lah'" >> /root/.bashrc

# ----------------------------
# Set the working directory
# ----------------------------
WORKDIR /root

# ----------------------------
# Keep container running
# ----------------------------
CMD ["sleep", "infinity"]
