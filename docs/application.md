In this part we want to deploy a web application. You can replace it with your own image but here we use ...
The values to have a sample app can be found in [this file](./examples/application-values.yaml). 
We set the replicas to 1:
```yaml
global:
  replicaCount: 1
```
You can increase it and upgrade your helm release whenever you want. 
Then comes the image info: 
```yaml 
image:
  repository: "stefanprodan/podinfo"
  tag: "latest"
  pullPolicy: Always
```
The tag may be changed if you need another version of the image.
To expose application define Service: 
```yaml
services:
- name: web
  type: ClusterIP
  annotations: {}
  specs:
  - port: 9898
    targetPort: 9898
    name: web
```

Then we define ingress: 
```yaml
ingress:
  enabled: true
  annotations: 
      traefik.ingress.kubernetes.io/router.entrypoints: websecure 
      traefik.ingress.kubernetes.io/router.tls: "true" 
      traefik.ingress.kubernetes.io/router.tls.certresolver: "letsencrypt"
  hosts:
    - host: api.example.com
      servicePort: 9898
      serviceName: web
      path: /
      pathType: Prefix
  tls: []
```
This ingress is for Traefik. Adjust it based on your ingress controller. 

And finally the resources: 
```yaml
resources:
  limits:
    cpu: 100m
    memory: 200Mi
  requests:
    cpu: 100m
    memory: 200Mi
```

This is not mandatory but it is a good practice to define resources for Pods. 
Now you have the values to deploy the application. Install it with a command like:
```sh 
helm install backend app/app --values ./values.yaml
```

And have fun!
