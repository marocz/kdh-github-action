FROM docker:18.06.3-ce-dind

ENV HELM_VERSION="3.8.0" \
  KUBECTL_VERSION="1.23.3" \
  YQ_VERSION="4.35.1" \ 
  KUBEVAL_VERSION="0.16.1" \ 
  GLIBC_VERSION="2.28-r0" \
  PATH=/opt/kubernetes-deploy:$PATH

# Install pre-req
RUN apk add -U openssl curl tar gzip bash ca-certificates git wget jq libintl coreutils \
  && apk add --virtual build_deps gettext \
  && mv /usr/bin/envsubst /usr/local/bin/envsubst \
  && apk del build_deps

# Install deploy scripts
COPY / /opt/kubernetes-deploy/

# Install glibc for Alpine
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \ 
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk \ 
  && apk add glibc-$GLIBC_VERSION.apk \ 
  && rm glibc-$GLIBC_VERSION.apk

# Install yq
RUN wget -q -O /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v$YQ_VERSION/yq_linux_amd64 && chmod +x /usr/local/bin/yq

# Install kubeval
RUN wget https://github.com/garethr/kubeval/releases/download/v$KUBEVAL_VERSION/kubeval-linux-amd64.tar.gz \
  && tar xvfzmp kubeval-linux-amd64.tar.gz \
  && mv kubeval /usr/local/bin \
  && chmod +x /usr/local/bin/kubeval

# Install kubectl
RUN curl -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && chmod +x /usr/bin/kubectl \
  && kubectl version --client

# Install Helm
# RUN set -x \
#   && curl -fSL https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz \
#   && tar -xzvf helm.tar.gz \
#   && mv linux-amd64/helm /usr/local/bin/ \
#   && rm -rf linux-amd64 \
#   && rm helm.tar.gz \
#   && helm help

RUN set -x \
  && curl -fSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz \
  && tar -xzvf helm.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/ \
  && rm -rf linux-amd64 \
  && rm helm.tar.gz \
  && helm help

# ARG KUBE_URL
# ARG KUBE_TOKEN
# ARG KUBE_CA_PEM
# ARG KUBE_NAMESPACE
# ARG CI_ENVIRONMENT_SLUG
# ARG CI_ENVIRONMENT_URL
# ARG CI_DEPLOY_USER
# ARG CI_DEPLOY_PASSWORD
# ARG CI_REGISTRY
# ARG CLUSTER

ENV KUBE_URL=$KUBE_URL
ENV KUBE_TOKEN=$KUBE_TOKEN
ENV KUBE_CA_PEM=$KUBE_CA_PEM
ENV KUBE_NAMESPACE=$KUBE_NAMESPACE
ENV CI_ENVIRONMENT_SLUG=$CI_ENVIRONMENT_SLUG
ENV CI_ENVIRONMENT_URL=$CI_ENVIRONMENT_URL
ENV CI_DEPLOY_USER=$CI_DEPLOY_USER
ENV CI_DEPLOY_PASSWORD=$CI_DEPLOY_PASSWORD
ENV CI_REGISTRY=$CI_REGISTRY
ENV CLUSTER=$CLUSTER 

# Add the entrypoint script
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]