FROM google/cloud-sdk:272.0.0-alpine

ARG DOCKER_VERSION=18.09.6
ARG HELM_VERSION=v2.14.0
ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV DOCKERIZE_VERSION=v0.6.1

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

RUN apk add --no-cache --update \
    'nodejs=10.16.3-r0' \
    'npm=10.16.3-r0' \
    'yarn=1.16.0-r0'	

RUN gcloud components install beta cloud_sql_proxy
RUN apk add mysql-client postgresql-client

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

## Commented due to
# Error relocating /usr/local/bin/aws: __strcat_chk: symbol not found
# Error relocating /usr/local/bin/aws: __snprintf_chk: symbol not found
# Error relocating /usr/local/bin/aws: __vfprintf_chk: symbol not found
# Error relocating /usr/local/bin/aws: __strdup: symbol not found
# Error relocating /usr/local/bin/aws: __stpcpy_chk: symbol not found
# Error relocating /usr/local/bin/aws: __vsnprintf_chk: symbol not found
# Error relocating /usr/local/bin/aws: __strncpy_chk: symbol not found
# Error relocating /usr/local/bin/aws: __strcpy_chk: symbol not found
# Error relocating /usr/local/bin/aws: __fprintf_chk: symbol not found
# Error relocating /usr/local/bin/aws: __strncat_chk: symbol not found
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#     && unzip awscliv2.zip \
#     && ./aws/install

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
