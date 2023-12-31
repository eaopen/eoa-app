#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# change to top dir
cd ${DIR}/..

# 1 maven(project dir)
mvn clean install -DskipTests=true

# change to eoa dir
APPDIR=${DIR}/../eap-server
cd ${APPDIR}

# 2 maven in eoa dir
mvn clean
mvn install -DskipTests=true

# 3 docker build
# docker image vars
artifactId=eoa-server
version=2.0-snapshot
docker build . --tag ${artifactId}:${version}
docker tag  ${artifactId}:${version}  ${artifactId}:latest

# 4 docker push
## !!!请更改的docker registry以及执行docker login
# docker login -u [user] -p [password] [docker registry]
LOGIN_FILE_PATH="${DIR}/openea-docker-login.sh"

if [ -f "$LOGIN_FILE_PATH" ]; then
  sh $LOGIN_FILE_PATH
fi

repsBase=openea-docker.pkg.coding.net/reps/docker
docker tag ${artifactId}:${version}  ${repsBase}/${artifactId}:latest
docker push ${repsBase}/${artifactId}:latest

