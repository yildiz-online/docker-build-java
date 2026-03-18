FROM dhi.io/maven:3-jdk25-dev

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"

RUN java -version \
&& mvn -v \
&& mkdir /build-resources \
&& mkdir /root/.ssh \
&& mkdir /src

COPY settings.xml build-resources
COPY deploy-maven-central.sh build-resources

RUN chmod +x /build-resources/deploy-maven-central.sh

WORKDIR /src

ENTRYPOINT ../build-resources/deploy-maven-central.sh
