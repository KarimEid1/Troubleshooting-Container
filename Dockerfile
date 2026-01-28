# ----------------------------
# Base image
# ----------------------------
FROM alpine:3.20

# ----------------------------
# Versions (pin them!)
# ----------------------------
ARG KUBECTL_VERSION=v1.30.3
ARG HELM_VERSION=v3.15.4
ARG OC_VERSION=4.16.6

# ----------------------------
# Install base utilities
# ----------------------------
RUN apk add --no-cache \
    bash \
    curl \
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
    gzip

# ----------------------------
# Install kubectl
# ----------------------------
RUN curl -L \
    https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# ----------------------------
# Install Helm
# ----------------------------
RUN curl -L \
    https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | \
    tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64

# ----------------------------
# Install OpenShift oc
# ----------------------------
RUN curl -L \
    https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | \
    tar xz && \
    mv oc /usr/local/bin/oc && \
    chmod +x /usr/local/bin/oc && \
    rm -f README.md

# ----------------------------
# Sanity checks (fail build if broken)
# ----------------------------
RUN kubectl version --client=true && \
    helm version && \
    oc version

# ----------------------------
# Quality-of-life
# ----------------------------
RUN echo "alias ll='ls -lah'" >> /root/.bashrc

WORKDIR /root
CMD ["sleep", "infinity"]
