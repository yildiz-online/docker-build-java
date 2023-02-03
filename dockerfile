FROM ubuntu:jammy

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"

ARG TARGETARCH

RUN touch arch

RUN if [ "$TARGETARCH" = "amd64" ]; then echo "x64" > arch; elif [ "$TARGETARCH" = "arm64" ]; then echo "aarch64" > arch; fi

RUN ls -lh

ENV ARCH="$(<arch)"

RUN echo ${ARCH}

ENV JAVA_ZULU_VERSION=17.40.19
ENV JAVA_VERSION=17.0.6
ENV MAVEN_VERSION=3.8.7

ENV MAVEN_DIRECTORY=apache-maven-${MAVEN_VERSION}
ENV MAVEN_FILE=${MAVEN_DIRECTORY}-bin.tar.gz
ENV MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_FILE}
ENV M2_HOME=/${MAVEN_DIRECTORY}


ENTRYPOINT ../build-resources/deploy-maven-central.sh

