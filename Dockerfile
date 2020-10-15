FROM alpine:3.12

ENV HELM_VERSION v3.3.4
ENV GCLOUD_SDK 314.0.0

ENV PATH /google-cloud-sdk/bin:$PATH
ENV GOOGLE_APPLICATION_CREDENTIALS /secret.json

RUN set -ex ; \
  apk --no-cache add python3 curl git; \
  apk --no-cache --virtual .setup_dependencies add ca-certificates wget; \
  wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK}-linux-x86_64.tar.gz; \
  tar xzf google-cloud-sdk-${GCLOUD_SDK}-linux-x86_64.tar.gz; \
  rm -rf google-cloud-sdk-${GCLOUD_SDK}-linux-x86_64.tar.gz; \
  ln -s /google-cloud-sdk/bin/gcloud /bin/gcloud; \
  gcloud --quiet components update kubectl; \
  gcloud config set core/disable_usage_reporting true; \
  gcloud config set component_manager/disable_update_check true; \
  wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz; \
  tar -xzf helm-${HELM_VERSION}-linux-amd64.tar.gz; \
  rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz; \
  mv linux-amd64/helm /google-cloud-sdk/bin/helm; \
  apk del .setup_dependencies;

RUN helm init -c --skip-refresh; \
  helm plugin install https://github.com/nouney/helm-gcs;
