v0.13.0:
- Use Pod template for StatefulSet and Deployment 
- Add `dnsConfig` and `dnsPolicy` fields to Pod template
- Improve document for testing helm chart

v0.12.0:
- Add `secrets` in volumes to mount secret files into Pods
- Add examples and docs to deploy postgres, nginx and web application
- Improve testing and add it to development doc

v0.11.0:
- Set default value of `resources` to nil 
- Set default value of `services` to empty list
- Add `subPath` for configmap 
- Improve test scripts and reorganize hack directory 

v0.10.2
- Add `podLabels` to label `Deployment` and `Statefulset` pods

v0.10.1:
- Correct `pathType` in values file 
- Add `tls` section to ingress object 

v0.10.0:
- Replace `volumes.pvc.existing_claim` with  `volumes.pvc.existingClaim`
- Set default value of `volumes.pvc.existingClaim` explicitly to null
- Do not create PVC if there is an existing claim (i.e. `volumes.pvc.existingClaim` is 
not null) 

v0.9.0: 
- Change command and args usage 
- Set default value of configmaps to empty list

v0.8.0:
- Add securityContext for deployment and sts
- Add podSecurityContext for deployment and sts

v0.7.1: 
- Do not create Deployment if `deployment: false`
- Fix problem with ConfigMap and Service

v0.7.0:
- Add statefulset 
- Add test for statefulset
- Delete some template yaml files 
- Use Secret data as environment variable

v0.6.1: 
- SubPath for PVC mounted on the pod

v0.6.0:
- Add node selector and tolerations 
- Add update strategy for deployment
- Add hostNetwork for deployment
