FROM ubuntu:focal

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"

ENV JAVA_ZULU_VERSION=15.27.17
ENV JAVA_VERSION=15.0.0
ENV MAVEN_VERSION=3.6.3

ENV JAVA_DIRECTORY=/zulu${JAVA_ZULU_VERSION}-ca-jdk${JAVA_VERSION}-linux_x64
ENV JAVA_FILE=${JAVA_DIRECTORY}.tar.gz
ENV JAVA_URL=https://cdn.azul.com/zulu/bin/${JAVA_FILE}
ENV JAVA_HOME=/${JAVA_DIRECTORY}


ENV MAVEN_DIRECTORY=apache-maven-${MAVEN_VERSION}
ENV MAVEN_FILE=${MAVEN_DIRECTORY}-bin.tar.gz
ENV MAVEN_URL=https://mirror.dkd.de/apache/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_FILE}
ENV M2_HOME=/${MAVEN_DIRECTORY}

ENV PATH="${PATH}:${JAVA_HOME}/bin:${M2_HOME}/bin"


RUN apt-get update && apt-get install -y -q wget gnupg2 curl jq locales zip openssh-client

RUN wget -q ${JAVA_URL} \
&& tar -xzf ${JAVA_FILE} \
&& rm ${JAVA_FILE}

RUN wget -q ${MAVEN_URL} \
&& tar -xzf ${MAVEN_FILE} \
&& rm ${MAVEN_FILE}

RUN chmod 777 /${MAVEN_DIRECTORY}/bin/mvn \
&& chmod 777 /${JAVA_DIRECTORY}/bin/java \
&& chmod 777 /${JAVA_DIRECTORY}/bin/javadoc \
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

RUN ssh-keyscan -H yildiz-games.be >> ~/.ssh/known_hosts
COPY settings.xml build-resources
COPY private-key.gpg.enc build-resources
COPY deploy-maven-central.sh build-resources

RUN chmod 777 /build-resources/deploy-maven-central.sh

WORKDIR /src

ENTRYPOINT ../build-resources/deploy-maven-central.sh

