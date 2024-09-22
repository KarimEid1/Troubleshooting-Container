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
