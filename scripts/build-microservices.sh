#!/bin/bash

if [ $# -lt 4 ]; then
  echo 1>&2 "Usage: $0 <DOCKER_REPO> <QUANDL_KEY> <HOSTDOMAIN> <VERSION>"
  exit 2
fi
DOCKER_REPO=$1
REACT_APP_QUANDL_KEY=$2
HOSTDOMAIN=$3
VERSION=$4

cd ./apps/postgresql/docker ; docker build -t postgresql -f Dockerfile . 
if [[ $? -ne 0 ]] ; then
    echo "error docker build postgres"
    exit 1
fi
cd ../../../

cd ./apps/capplication/docker ; docker build -t capplication -f Dockerfile . 
if [[ $? -ne 0 ]] ; then
    echo "error docker build capplication"
    exit 1
fi
cd ../../../

cd ./apps/webappreact/docker ; docker build --build-arg REACT_APP_QUANDL_KEY=${REACT_APP_QUANDL_KEY} --build-arg REACT_APP_WEB_SERVER=${HOSTDOMAIN} -t webappreact -f Dockerfile . 
if [[ $? -ne 0 ]] ; then
    echo "error docker build webappreact"
    exit 1
fi

docker tag postgresql ${DOCKER_REPO}/postgresql:${VERSION} && docker push ${DOCKER_REPO}/postgresql:${VERSION}
if [[ $? -ne 0 ]] ; then
    echo "error tagging/pushing postgres"
    exit 1
fi

docker tag capplication ${DOCKER_REPO}/capplication:${VERSION} && docker push ${DOCKER_REPO}/capplication:${VERSION}
if [[ $? -ne 0 ]] ; then
    echo "error tagging/pushing capplication"
    exit 1
fi

docker tag webappreact ${DOCKER_REPO}/webappreact:${VERSION} && docker push ${DOCKER_REPO}/webappreact:${VERSION}
if [[ $? -ne 0 ]] ; then
    echo "error tagging/pushing webappreact"
    exit 1
fi

