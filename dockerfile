FROM ubuntu:bionic

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"

ENV M2_HOME=/apache-maven
ENV JAVA_HOME=/openjdk-12_linux-x64
ENV PATH="${PATH}:${JAVA_HOME}/bin:${M2_HOME}/bin"
RUN apt-get update && apt-get install -y -q wget unzip gnupg2 curl jq locale-gen --reinstall \
&& wget https://bitbucket.org/yildiz-engine-team/build-application-binaries/downloads/openjdk-12_linux-x64.zip\
&& wget https://bitbucket.org/yildiz-engine-team/build-application-binaries/downloads/apache-maven.zip \
&& unzip -q openjdk-12_linux-x64.zip \
&& rm openjdk-12_linux-x64.zip \
&& unzip -q apache-maven.zip \
&& rm apache-maven.zip\
&& chmod 777 /apache-maven/bin/mvn \
&& chmod 777 /openjdk-12_linux-x64/bin/java \
&& chmod 777 /openjdk-12_linux-x64/bin/javadoc \
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

COPY settings.xml build-resources
COPY private-key.gpg.enc build-resources

WORKDIR /src

