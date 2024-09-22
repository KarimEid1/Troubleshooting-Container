# Troubleshooting-Container

This repository contains the source code for a Dockerfile used to build a versatile troubleshooting container for Kubernetes environments. The container is equipped with essential networking, diagnostic, and debugging tools to assist in identifying and resolving deployment issues within Kubernetes clusters.

## Features

- **Pre-installed Tools:** Includes a wide range of tools such as:
  - `curl` and `wget`: For testing HTTP/HTTPS endpoints.
  - `dig` and `nslookup`: For DNS queries and troubleshooting.
  - `netcat` and `telnet`: For testing network connections.
  - `tcpdump` and `traceroute`: For packet analysis and tracing routes.
  - `jq`: For parsing and manipulating JSON data.
  - Additional utilities for various troubleshooting scenarios.

- **Lightweight and Configurable:** The container image is designed to be lightweight while still providing a comprehensive toolkit for troubleshooting.

- **Kubernetes Integration:** Easily deploy the container as a pod in your Kubernetes cluster for quick access to all the tools.

## Usage

### Build the Docker Image

Clone the repository and build the Docker image:

```bash
git clone https://github.com/KarimEid1/Troubleshooting-Container.git
cd Troubleshooting-Container
docker build -t troubleshooting-container .
```

### Runing the Container in a Kubernetes Deployment

Create a Deployment YAML file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: troubleshooting-container
spec:
  replicas: 1
  selector:
    matchLabels:
      app: troubleshooting-container
  template:
    metadata:
      labels:
        app: troubleshooting-container
    spec:
      containers:
      - name: troubleshooting-container
        image: troubleshooting-container:latest
        command: ["/bin/sh", "-c", "sleep 3600"]
        securityContext:
          runAsNonRoot: true
          runAsUser: 1000
      restartPolicy: Always
```

Deploy the Pod:

```bash
kubectl apply -f troubleshooter-deployment.yaml
```

Verify the Pod is Running:

```bash
kubectl get pods -l app=troubleshooting-container
```

Access the Pod:

```bash
kubectl exec -it $(kubectl get pod -l app=troubleshooting-container -o jsonpath="{.items[0].metadata.name}") -- /bin/sh
```

## Contributing

Contributions are welcome! If you have any suggestions for additional tools or improvements, feel free to open an issue or submit a pull request.
