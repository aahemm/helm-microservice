# A Helm Chart for DRY microservice deployments

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![version](https://img.shields.io/github/tag/aahemm/helm-microservice.svg?label=release)

## Introduction

This helm chart deploys a deployment, with a series of services and ingresses for a given container, hosting a web service with the following properties:

- Configuration from environment variables
- exposes a number of ports, dependent on the container

The chart exposes port 8000 over http by default, with a load balancing service, but the ports and services are configured from a list of arbitrary length in the values file.

Similarly, the environment variables are injected from a definition list, of arbitrary length.

The goal is to provide a DRY microservice deployment mechanism with some flexibility, to be used with some other charts orchestrating a series of microservices via a requirement file, pointing to this chart, where each instance of this chart is differenciated using aliases.

The federating chart will provide the configuration for each microservices in its values file.

## Prerequisites

- Kubernetes cluster 1.10+
- Helm 3.0.0+
- PV provisioner support in the underlying infrastructure.

## Installation

### Add Helm repository

```bash
helm repo add app https://aahemm.github.io/helm-microservice
helm repo update
```

### Configure the chart

The following items can be set via `--set` flag during installation or configured by editing the `values.yaml` directly (need to download the chart first).

#### Configure the way how to expose the microservice service:

- **Ingress**: The ingress controller must be installed in the Kubernetes cluster.
- **ClusterIP**: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster.
- **NodePort**: Exposes the service on each Node’s IP at a static port (the NodePort). You’ll be able to contact the NodePort service, from outside the cluster, by requesting `NodeIP:NodePort`.
- **LoadBalancer**: Exposes the service externally using a cloud provider’s load balancer.

#### Configurations

For other configurations, please see the [values.yaml](values.yaml) file. This file lists the configurable parameters of the microservice chart and the default values.

### Install the chart

Install the microservice helm chart with a release name `my-release`:

```bash
helm install my-release app/app
```

## Uninstallation

To uninstall/delete the `my-release` deployment:

```bash
helm uninstall my-release
```

## Contributing

Feel free to contribute by making a [pull request](https://github.com/aahemm/helm-microservice/pull/new/master).

Please read the official [Contribution Guide](https://github.com/helm/charts/blob/master/CONTRIBUTING.md) from Helm for more information on how you can contribute to this Chart.

To create a package from chart: 
- Update chart version in `Chart.yaml` file
- Run `helm package .` in the root of project
- Move the generated `app-$version.tgz` file to `hack/`
- Run `./generate-index.sh $version` in `hack/` and copy new lines in `hack/index.taml` to `index.yaml`
- Upload the `.tgz` file to releases 
 
## License

[Apache License 2.0](/LICENSE)
