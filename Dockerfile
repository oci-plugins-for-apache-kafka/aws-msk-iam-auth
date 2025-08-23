FROM  registry.access.redhat.com/ubi9/ubi:latest AS build

ARG VERSION=latest
ARG PLUGIN=plugin

RUN mkdir plugin
RUN curl -sL https://github.com/aws/aws-msk-iam-auth/releases/download/v${VERSION}/aws-msk-iam-auth-${VERSION}-all.jar -o plugin/aws-msk-iam-auth-${VERSION}-all.jar

FROM scratch

ARG VERSION=latest
ARG PLUGIN=plugin

LABEL org.opencontainers.image.source='https://github.com/kafka-oci-plugins/aws-msk-iam-auth' \
      org.opencontainers.image.url='https://github.com/kafka-oci-plugins/aws-msk-iam-auth' \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.title="Amazon MSK Library for AWS Identity and Access Management" \
      org.opencontainers.image.description='Container images with the Amazon MSK Library for AWS Identity and Access Management'

COPY --from=build plugin /