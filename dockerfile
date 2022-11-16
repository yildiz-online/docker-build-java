FROM ubuntu:focal

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"
ENV JAVA_ZULU_VERSION=17.38.21
ENV JAVA_VERSION=17.0.5
ENV MAVEN_VERSION=3.8.6

ENV JAVA_HOME=/java

ENV MAVEN_DIRECTORY=apache-maven-${MAVEN_VERSION}
ENV MAVEN_FILE=${MAVEN_DIRECTORY}-bin.tar.gz
ENV MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_FILE}
ENV M2_HOME=/${MAVEN_DIRECTORY}

ENV PATH="${PATH}:${JAVA_HOME}/bin:${M2_HOME}/bin"

RUN apt-get update && apt-get install -y -q wget gnupg2 curl jq locales zip openssh-client

ARG CI_ARCH

RUN if [ "$CI_ARCH" = "amd64" ]; then wget -q https://cdn.azul.com/zulu/bin/zulu${JAVA_ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_x64.tar.gz -O java.tar.gz\; fi

RUN tar -xzf java.tar.gz \
&& rm java.tar.gz

RUN wget -q ${MAVEN_URL} \
&& tar -xzf ${MAVEN_FILE} \
&& rm ${MAVEN_FILE}

RUN chmod +x /${MAVEN_DIRECTORY}/bin/mvn \
&& chmod +x /java/bin/java \
&& chmod +x /java/bin/javadoc \
&& apt-get remove -y -q wget && apt-get -q -y autoremove && apt-get -y -q autoclean \
&& java -version \
&& mvn -v \
&& mkdir /build-resources \
&& mkdir /root/.ssh \
&& mkdir /src

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
&& locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN ssh-keyscan -p 55022 -H yildiz-games.be >> ~/.ssh/known_hosts
COPY settings.xml build-resources
COPY private-key.gpg.enc build-resources
COPY deploy-maven-central.sh build-resources

RUN chmod +x /build-resources/deploy-maven-central.sh

WORKDIR /src

ENTRYPOINT ../build-resources/deploy-maven-central.sh

