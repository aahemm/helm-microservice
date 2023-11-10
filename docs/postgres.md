The values to have a sample postgres can be found in [this file](./examples/postgres-values.yaml).
We set the replicas to 1:
```yaml
global:
  replicaCount: 1
```
Then comes the postgres image info:
```yaml
image:
  repository: "postgres"
  tag: "14.7"
  pullPolicy: Always
```
The tag may be changed if you need another version of postgres.

Postgres is a stateful service. So we want to deploy it using a StatefulSet. Here we do this:
```yaml
deployment: false 
```

To expose postgres define Service: 
```yaml
services:
  - name: db
    type: ClusterIP
    annotations: {}
    specs:
    - port: 5432
      targetPort: 5432
      name: db
```

Postgres image needs some environment variables. So we put this block and define variables in there: 
```yaml
environment:
  POSTGRES_PASSWORD: password
  POSTGRES_USER: postgres
  POSTGRES_DB: postgres
  PGDATA: /var/lib/postgresql/data/pgdata
```

To persist postgres data create a PVC: 
```yaml
volumes:
  enabled: true
  pvc:
    enabled: true 
    name: postgres
    mountPath: /var/lib/postgresql/data
    size: 2G
    accessModes:
    - ReadWriteOnce
  configMaps: []
```
All the PVC parameters are set here. You need a default StoragClass for this to work.

And finally the resources: 
```yaml
resources:
  limits:
    cpu: 500m
    memory: 1000Mi
  requests:
    cpu: 500m
    memory: 1000Mi
```
This is not mandatory but it is a good practice to define resources for Pods. 

Now you have the values to deploy postgres. Install it with a command like:
```sh 
helm install postgres app/app --values ./values.yaml
```

And have fun!