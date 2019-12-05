FROM google/cloud-sdk:272.0.0-alpine

ARG DOCKER_VERSION=18.09.6
ARG HELM_VERSION=v2.14.0
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz

RUN apk add openssl gettext jq

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl 

RUN curl -L https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} | tar xz \
    && mv linux-amd64/helm /bin/helm \
    && rm -rf linux-amd64 \
    && helm init --client-only

RUN curl -L -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$VER.tgz \
    && mv /tmp/docker/* /usr/local/bin/ && docker version || true

RUN curl -fLSs https://circle.ci/cli | bash

RUN apk add --no-cache --update nodejs nodejs-npm yarn

RUN gcloud components install beta cloud_sql_proxy
