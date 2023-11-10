# A Helm Chart To Deploy (Almost) All Your Services

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![version](https://img.shields.io/github/tag/aahemm/helm-microservice.svg?label=release)

## Overview

This helm chart provides a solution for everyone who wants to deploy their applications
on Kubernetes. It is designed to make the deployment and management of your stateful 
and stateless services as seamless and efficient as possible. It can be used with helm,
helmfile, GitOps and any other helm related tools.

## Features 
- Easy installation and configuration 
- Customizable settings to fit your specific needs using ConfigMaps and environment 
variables 
- Supports both StatefulSet and Deployment in Kubernetes
- Manage workload scheduling using node selectors, tolerations and affinities
- Define ingress resources and services that expose your application
- And much more!

## Prerequisites

- Kubernetes cluster 1.10+
- Helm 3.0.0+

## Installation

First add the helm repo:
```bash
helm repo add app https://aahemm.github.io/helm-microservice
helm repo update
```

Then you need to write a values file to deploy your specific application. For configurations options, please 
see the [values.yaml](values.yaml) file. This file lists the configurable parameters of the chart and the 
default values. It also provides some hints on how to use them. 

After configuring the desired values in `values.yaml` file, install the 
helm chart with a release name `my-release`:

```bash
helm install my-release app/app --values ./values.yaml
```

To uninstall/delete the `my-release` deployment:

```bash
helm uninstall my-release
```


## Documentation
For more information on how to use this helm chart, refer to [docs](./docs/README.md) or 
[examples](./docs/examples/).


## Contributing

We welcome and appreciate contributions from the community. 
If you have any ideas, suggestions, or improvements, feel free to open
an issue or submit a pull request.

 
## License

Thid project is licensed under Apache License 2.0. See the [LICENSE](/LICENSE)
for details.



Thank you for choosing this helm chart! I hope it helps you in deploying 
and managing your services effectively.