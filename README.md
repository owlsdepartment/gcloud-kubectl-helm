# [Docker image] - gcloud-kubectl-helm
Image optimized for update helm repos with gitlab-runner in gcloud k8s environment
## Authorization
To use this image, you need to get Service Account in json from your google console.  
You must convert it to base64:
``` sh
base64 service-account.json
#or
base64 service-account.json | pbcopy # copy to clipboard on OSX
```
and paste it to environment variables in your CI tool.
## Example usage (GitLabCI)
```yml
deploy:
  image: owlsdepartment/gcloud-kubectl-helm:latest
  variables:
    # GCLOUD_SERVICE_KEY_BASE64: [secret_variable_with_google_account_in_base64]
    GCLOUD_PROJECT: [your_project_name]
    GKE_CLUSTER: [your_cluster_name]
    ZONE: [your_zone_name]
    ENVIRONMENT_NAME: production
    HELM_REPO_NAME: [your_helm_repo_name]
  before_script:
    - echo $GCLOUD_SERVICE_KEY_BASE64 | base64 -d > $GOOGLE_APPLICATION_CREDENTIALS
    - gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
    - gcloud config set project $GCLOUD_PROJECT
    - if [ $ZONE ]; then gcloud container clusters get-credentials $GKE_CLUSTER --zone=$ZONE --project=$GCLOUD_PROJECT; else gcloud container clusters get-credentials $GKE_CLUSTER --region=$REGION --project=$GCLOUD_PROJECT; fi # different commands for zone and region
    - helm repo add ${HELM_REPO_NAME} gs://[path_to_storage]
  script:
    - helm upgrade --install ${ENVIRONMENT_NAME}-${SERVICE_NAME} --namespace ${ENVIRONMENT_NAME} --set ${ENVIRONMENT_NAME}.env=true,${ENVIRONMENT_NAME}.tag=${IMAGE_VERSION} ${HELM_REPO_NAME}/${SERVICE_NAME}
  only:
    - master
  tags:
    - k8s
```