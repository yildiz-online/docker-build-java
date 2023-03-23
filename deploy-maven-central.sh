#!/bin/bash

#To create the quotes properly.
generate_post_data()
{
  cat <<EOF
{"token": "$VAULT_TOKEN"}  
EOF
}

RESPONSE=$(curl --connect-timeout 10 --max-time 15 -sS -X POST --data "$(generate_post_data)" https://vault.yildiz-games.be/v1/auth/github/login)
TOKEN=$(echo ${RESPONSE} | jq -r '.auth.client_token')
SECRETS=$(curl -sS -H "X-Vault-Token: $TOKEN" -X GET https://vault.yildiz-games.be/v1/kv/yildiz-engine)

#Some variables need to be exported as env variable to be used by external processes.

export GH_TOKEN=$(echo ${SECRETS} | jq -r '.data.GH_TOKEN')
OPENSSL_PWD=$(echo ${SECRETS} | jq -r '.data.OPENSSL_PWD')
export GPG_KEY=$(echo ${SECRETS} | jq -r '.data.GPG_KEY')
export GPG_PWD=$(echo ${SECRETS} | jq -r '.data.GPG_PWD')
export OSSRH_USER_TOKEN=$(echo ${SECRETS} | jq -r '.data.OSSRH_USER_TOKEN')
export OSSRH_PWD_TOKEN=$(echo ${SECRETS} | jq -r '.data.OSSRH_PWD_TOKEN')
export REPO_USER=$(echo ${SECRETS} | jq -r '.data.REPO_USER')
export REPO_PASSWORD=$(echo ${SECRETS} | jq -r '.data.REPO_PASSWORD')
SONAR=$(echo ${SECRETS} | jq -r '.data.SONAR')
SONAR_ORGANIZATION=$(echo ${SECRETS} | jq -r '.data.SONAR_ORGANIZATION')


export MAVEN_OPTS="--add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.text=ALL-UNNAMED --add-opens=java.desktop/java.awt.font=ALL-UNNAMED"


echo "Building $BRANCH branch"

if [ "$NO_DEPLOY" = "true" ]; then
  if [ "$BRANCH" = "develop" ]; then
    mvn -V -s ../build-resources/settings.xml org.jacoco:jacoco-maven-plugin:prepare-agent clean package sonar:sonar -Dsonar.host.url=https://sonarcloud.io -Dsonar.organization=$SONAR_ORGANIZATION -Dsonar.login=$SONAR $MVN_PARAMS
  elif [ "$BRANCH" = "master" ]; then
    mvn -V -s ../build-resources/settings.xml clean package $MVN_PARAMS
  else
    mvn -V -s ../build-resources/settings.xml clean package $MVN_PARAMS
  fi
else
  if [ "$BRANCH" = "develop" ]; then
    openssl aes-256-cbc -pass pass:${OPENSSL_PWD} -in ../build-resources/private-key.gpg.enc -out private-key.gpg -d && gpg --import --batch private-key.gpg && mvn -V -s ../build-resources/settings.xml org.jacoco:jacoco-maven-plugin:prepare-agent clean deploy sonar:sonar $MVN_PARAMS -Dsonar.host.url=https://sonarcloud.io -Dsonar.organization=${SONAR_ORGANIZATION} -Dsonar.login=${SONAR}
  elif [ "$BRANCH" = "master" ]; then
    openssl aes-256-cbc -pass pass:${OPENSSL_PWD} -in ../build-resources/private-key.gpg.enc -out private-key.gpg -d && gpg --import --batch private-key.gpg && mvn -V -U -s ../build-resources/settings.xml clean deploy $MVN_PARAMS
  else
    mvn -V -s ../build-resources/settings.xml clean package $MVN_PARAMS
  fi
fi
