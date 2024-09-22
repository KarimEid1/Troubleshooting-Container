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

### Running the Container Declaratively 

To run the troubleshooting container declaratively using kubectl run, you can specify the image and additional options directly from the command line. Here's how you can do it:

```bash
kubectl run troubleshooting-container \
  --image=troubleshooting-container:latest \
  --restart=Never \
  --command -- /bin/sh -c "sleep 3600"
```

To access the pod and use the tools inside it, run:

```bash
kubectl exec -it troubleshooting-container -- /bin/sh
```

To delete the pod after use, run:

```bash
kubectl delete pod troubleshooting-container
```


### Runing the Container in a Kubernetes Deployment

Create a Deployment YAML file:

Save the following configuration as troubleshooter-deployment.yaml:

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

This configuration will deploy a single pod running the troubleshooting container in your Kubernetes cluster.

Deploy the Pod:

Apply the configuration using the following command:

```bash
kubectl apply -f troubleshooter-deployment.yaml
```

Verify the Pod is Running:

Check if the pod is running with:

```bash
kubectl get pods -l app=troubleshooting-container
```

Access the Pod:

Once the pod is running, you can access it using kubectl exec:

```bash
kubectl exec -it $(kubectl get pod -l app=troubleshooting-container -o jsonpath="{.items[0].metadata.name}") -- /bin/sh
```

Deleting the Deployment:

To delete the deployment, run the following command:

```bash
kubectl delete deployment troubleshooting-container
```

This will give you a shell inside the troubleshooting container, where you can use the pre-installed tools to debug and troubleshoot your Kubernetes deployment.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! If you have any suggestions for additional tools or improvements, feel free to open an issue or submit a pull request.
