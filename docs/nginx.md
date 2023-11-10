The values to have a sample nginx can be found in [this file](./examples/nginx-values.yaml). 
We set the replicas to 1:
```yaml
global:
  replicaCount: 1
```
You can increase it and upgrade your helm release whenever you want. 
Then comes the nginx image info: 
```yaml 
image:
  repository: "nginx"
  tag: "1.24.0"
  pullPolicy: Always
```
The tag may be changed if you need another version of nginx.
To expose nginx define Service: 
```yaml
services:
- name: web
  type: NodePort
  annotations: {}
  specs:
  - port: 80
    targetPort: 80
    nodePort: 30080
    name: web
```

To have custom nginx config use ConfigMaps: 
```yaml
volumes:
  enabled: true
  pvc:
    enabled: false
  configMaps: 
  - name: nginx-config
    mountPath: /etc/nginx/conf.d/
    data:
      default.conf: |
        server {
          listen 80;
          listen [::]:80;

          server_name www.example.com;
              
          location / {
              proxy_pass http://localhost:8000;
              proxy_set_header Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
```
Change nginx config as you wish. The name of the key(s) in `.volumes.configMaps[*].data` will become the file
names mounted in the Pod. 
Set the `.volumes.pvc.enabled` to `false` because we do not need PVC for nginx. 
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
Now you have the values to deploy nginx. Install it with a command like:
```sh 
helm install nginx app/app --values ./values.yaml
```

And have fun!
