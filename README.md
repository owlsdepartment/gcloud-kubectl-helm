# [Docker image] - gcloud-kubectl-helm
Image optimized for update helm repos with gitlab-runner in gcloud k8s environment
## Authorization
To use this image, you need to get Service Account in json from your google console.  
Now you must it encode this image to base64.
``` sh
base64 service-account.json
```
## Configuration
- HELM_VERSION: version of helm like v2.8.0
- GCLOUD_SDK: version of gcloud sdk like 231.0.0
- GCLOUD_PROJECT: gcloud project name
- GKE_CLUSTER: google container engine cluster id
- ZONE: gcloud zone, e.g. europe-west2-a
- REGION: gcloud region, e.g. europe-west2
- GCLOUD_SERVICE_KEY_BASE64: base64 encoded service-account.json file