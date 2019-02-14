FROM alpine:3.6

ENV HELM_VERSION v2.8.0
ENV GCLOUD_SDK 233.0.0

ENV PATH /google-cloud-sdk/bin:$PATH
ENV GOOGLE_APPLICATION_CREDENTIALS /secret.json

COPY run.sh /usr/bin/run.sh

RUN set -ex ; \
  chmod +x /usr/bin/run.sh; \
  apk --no-cache add python curl git; \
  apk --no-cache --virtual .setup_dependencies add ca-certificates wget; \
  wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK}-linux-x86_64.tar.gz; \
  tar xzf google-cloud-sdk-${GCLOUD_SDK}-linux-x86_64.tar.gz; \
  gcloud --quiet components update kubectl; \
  gcloud config set core/disable_usage_reporting true; \
  gcloud config set component_manager/disable_update_check true; \
  wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz; \
  tar -xzf helm-${HELM_VERSION}-linux-amd64.tar.gz; \
  mv linux-amd64/helm /google-cloud-sdk/bin/helm; \
  apk del .setup_dependencies;

ENTRYPOINT [ "/usr/bin/run.sh" ]