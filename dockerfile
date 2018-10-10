FROM ubuntu:bionic

LABEL maintainer="Grégory Van den Borre vandenborre.gregory@hotmail.fr"

ENV M2_HOME=/apache-maven
ENV JAVA_HOME=/openjdk-11_linux-x64
ENV PATH="${PATH}:${JAVA_HOME}/bin:${M2_HOME}/bin"
RUN apt-get update && apt-get install -y -q wget unzip gnupg2 \
&& wget https://bitbucket.org/yildiz-engine-team/build-application-binaries/downloads/openjdk-11_linux-x64.zip\
&& wget https://bitbucket.org/yildiz-engine-team/build-application-binaries/downloads/apache-maven.zip \
&& unzip -q openjdk-11_linux-x64.zip \
&& rm openjdk-11_linux-x64.zip \
&& unzip -q apache-maven.zip \
&& rm apache-maven.zip\
&& chmod 777 /apache-maven/bin/mvn \
&& chmod 777 /openjdk-11_linux-x64/bin/java \
&& chmod 777 /openjdk-11_linux-x64/bin/javadoc \
&& apt-get remove -y -q unzip wget && apt-get -q -y autoremove && apt-get -y -q autoclean \
&& java -version \
&& mvn -v \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-clean-plugin -Dversion=3.1.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-compiler-plugin -Dversion=3.8.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-deploy-plugin -Dversion=2.8.2 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-failsafe-plugin -Dversion=2.19.1 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-install-plugin -Dversion=2.5.2 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-resources-plugin -Dversion=3.1.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-surefire-plugin -Dversion=2.19.1 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-verifier-plugin -Dversion=1.1 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-jar-plugin -Dversion=3.1.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-site-plugin -Dversion=3.7.1 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-antrun-plugin -Dversion=1.8 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-assembly-plugin -Dversion=3.1.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-dependency-plugin -Dversion=3.1.1 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-scm-plugin -Dversion=1.10.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-release-plugin -Dversion=2.5.3 \
&& mvn dependency:get -DgroupId=org.sonatype.plugins -DartifactId=nexus-staging-maven-plugin -Dversion=1.6.8 \
&& mvn dependency:get -DgroupId=org.sonarsource.scanner.maven -DartifactId=sonar-maven-plugin -Dversion=3.5.0.1254 \
&& mvn dependency:get -DgroupId=com.github.wvengen -DartifactId=proguard-maven-plugin -Dversion=2.0.14 \
&& mvn dependency:get -DgroupId=com.akathist.maven.plugins.launch4j -DartifactId=launch4j-maven-plugin -Dversion=1.7.21 \
&& mvn dependency:get -DgroupId=org.jacoco -DartifactId=jacoco-maven-plugin -Dversion=0.8.2 \
&& mvn dependency:get -DgroupId=org.codehaus.mojo -DartifactId=exec-maven-plugin -Dversion=1.6.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-source-plugin -Dversion=3.0.1 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-javadoc-plugin -Dversion=3.0.0 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-gpg-plugin -Dversion=1.6 \
&& mvn dependency:get -DgroupId=org.jooq -DartifactId=jooq-codegen-maven -Dversion=3.10.0 \
&& mvn dependency:get -DgroupId=org.pitest -DartifactId=pitest-maven -Dversion=1.2.4 \
&& mvn dependency:get -DgroupId=com.spotify -DartifactId=docker-maven-plugin -Dversion=1.0.0 \
&& mvn dependency:get -DgroupId=com.spotify -DartifactId=dockerfile-maven-plugin -Dversion=1.3.6 \
&& mvn dependency:get -DgroupId=org.apache.maven.plugins -DartifactId=maven-enforcer-plugin -Dversion=1.4.1 \
&& mvn dependency:get -DgroupId=org.owasp -DartifactId=dependency-check-maven -Dversion=3.0.2 \
&& mvn dependency:get -DgroupId=pl.project13.maven -DartifactId=git-commit-id-plugin -Dversion=2.2.4 \
&& mvn dependency:get -DgroupId=org.junit.jupiter -DartifactId=junit-jupiter-api -Dversion=5.1.0 \
&& mvn dependency:get -DgroupId=org.junit.jupiter -DartifactId=junit-jupiter-engine -Dversion=5.1.0 \
&& mvn dependency:get -DgroupId=org.junit.platform -DartifactId=junit-platform-launcher -Dversion=1.1.0 \
&& mvn dependency:get -DgroupId=org.junit.platform -DartifactId=junit-platform-surefire-provider -Dversion=1.1.0 \
&& mvn dependency:get -DgroupId=org.sonatype.plexus -DartifactId=plexus-cipher -Dversion=1.7 \
&& mvn dependency:get -DgroupId=org.apache.httpcomponents -DartifactId=httpclient -Dversion=4.3.5 \
&& mvn dependency:get -DgroupId=com.intellij -DartifactId=annotations -Dversion=9.0.4 \
&& mvn dependency:get -DgroupId=org.slf4j -DartifactId=slf4j-api -Dversion=1.7.25 \
&& mvn dependency:get -DgroupId=logkit -DartifactId=logkit -Dversion=1.0.1 \
&& mvn dependency:get -DgroupId=avalon-framework -DartifactId=avalon-framework -Dversion=4.1.3 \
&& mvn dependency:get -DgroupId=org.codehaus.mojo -DartifactId=build-helper-maven-plugin -Dversion=3.0.0 \
&& mvn dependency:get -DgroupId=org.codehaus.mojo -DartifactId=versions-maven-plugin -Dversion=2.5 \

&& mkdir /src
WORKDIR /src
