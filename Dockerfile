# Multi-stage Dockerfile: builder downloads tools, final stage installs required utilities,
# includes bash (as /bin/sh), bash-completion for kubectl/helm/oc, and runs as root.
FROM debian:12-slim AS builder

ARG KUBECTL_VERSION=v1.30.3
ARG HELM_VERSION=v3.15.4
ARG OC_VERSION=4.16.6

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      tar \
      gzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN mkdir -p /out /out/etc/ssl/certs

# Download kubectl
RUN curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /out/kubectl \
    && chmod +x /out/kubectl

# Download helm
RUN curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/linux-amd64/helm /out/helm && chmod +x /out/helm && rm -rf /tmp/linux-amd64

# Download oc (OpenShift client)
RUN curl -fsSL "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" -o /tmp/oc.tar.gz && \
    tar -xzf /tmp/oc.tar.gz -C /tmp && \
    if [ -f /tmp/oc ]; then mv /tmp/oc /out/oc; fi && \
    if [ -f /tmp/kubectl ]; then mv /tmp/kubectl /out/kubectl; fi && \
    chmod +x /out/oc || true && \
    rm -rf /tmp/oc.tar.gz /tmp/openshift-client-linux*

# Copy CA certs so TLS validation works in final image
RUN cp /etc/ssl/certs/ca-certificates.crt /out/etc/ssl/certs/ca-certificates.crt

# -----------------------------------------------------------------------------
# Final image: small interactive image with bash, completion, all tools, and root user
# -----------------------------------------------------------------------------
FROM debian:12-slim

# Install the utilities and bash-completion
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash \
      bash-completion \
      curl \
      dnsutils \
      netcat-openbsd \
      tcpdump \
      iputils-ping \
      iproute2 \
      traceroute \
      jq \
      openssl \
      busybox \
      ca-certificates \
      tar \
      gzip \
    && rm -rf /var/lib/apt/lists/*

# Copy only the binaries and certs from builder
COPY --from=builder /out/kubectl /usr/local/bin/kubectl
COPY --from=builder /out/helm    /usr/local/bin/helm
COPY --from=builder /out/oc      /usr/local/bin/oc
COPY --from=builder /out/etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Ensure binaries are executable and common dirs exist
RUN chmod 0755 /usr/local/bin/kubectl /usr/local/bin/helm /usr/local/bin/oc || true && \
    mkdir -p /home /work && \
    chmod 1777 /tmp /home /work && \
    chmod 0644 /etc/ssl/certs/ca-certificates.crt || true

# Make /bin/sh point to bash so consoles that spawn /bin/sh get bash behavior
RUN ln -sf /bin/bash /bin/sh

# Generate bash completion scripts for kubectl, helm and oc
RUN mkdir -p /etc/bash_completion.d && \
    if /usr/local/bin/kubectl completion bash >/etc/bash_completion.d/kubectl 2>/dev/null; then true; fi && \
    if /usr/local/bin/helm completion bash >/etc/bash_completion.d/helm 2>/dev/null; then true; fi && \
    if /usr/local/bin/oc completion bash >/etc/bash_completion.d/oc 2>/dev/null; then true; fi

# Ensure bash_completion is sourced for interactive shells
RUN cat > /etc/profile.d/enable-bash-completion.sh <<'EOF'
# Enable bash completion for interactive shells
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi
EOF

# Ensure root home and kube dir exist and are writable by root
ENV HOME=/root
RUN mkdir -p /root/.kube && chown root:root /root /root/.kube && chmod 700 /root /root/.kube

WORKDIR /root
ENV PATH=/usr/local/bin:$PATH
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Run as root so `oc login` can write /root/.kube/config
USER 0

# Keep container running by default so you can `kubectl/oc exec -it <pod> -- bash`
CMD ["sleep", "infinity"]
