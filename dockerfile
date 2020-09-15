FROM ubuntu:bionic

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"

ENV M2_HOME=/apache-maven
ENV JAVA_FILE=openjdk-12_linux-x64
ENV JAVA_HOME=/${JAVA_FILE}
ENV PATH="${PATH}:${JAVA_HOME}/bin:${M2_HOME}/bin"
RUN apt-get update && apt-get install -y -q wget zip unzip gnupg2 curl jq locales openssh-client \
&& wget https://bitbucket.org/yildiz-engine-team/build-application-binaries/downloads/${JAVA_FILE}.zip\
&& wget https://bitbucket.org/yildiz-engine-team/build-application-binaries/downloads/apache-maven.zip \
&& unzip -q ${JAVA_FILE}.zip \
&& rm ${JAVA_FILE}.zip \
&& unzip -q apache-maven.zip \
&& rm apache-maven.zip\
&& chmod 777 /apache-maven/bin/mvn \
&& chmod 777 /${JAVA_FILE}/bin/java \
&& chmod 777 /${JAVA_FILE}/bin/javadoc \
&& apt-get remove -y -q unzip wget && apt-get -q -y autoremove && apt-get -y -q autoclean \
&& java -version \
&& mvn -v \

&& mkdir /build-resources \
&& mkdir /src

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
&& locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ssh-keyscan -H yildiz-games.be >> ~/.ssh/known_hosts
COPY settings.xml build-resources
COPY private-key.gpg.enc build-resources
COPY deploy-maven-central.sh build-resources

RUN chmod 777 /build-resources/deploy-maven-central.sh

WORKDIR /src

ENTRYPOINT ../build-resources/deploy-maven-central.sh

