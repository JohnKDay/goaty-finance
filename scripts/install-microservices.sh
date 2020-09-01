#!/bin/bash

if [ $# -lt 4 ]; then
  echo 1>&2 "Usage: $0 <DOCKER_REPO> <NAMESPACE> <HOSTDOMAIN> <VERSION>"
  exit 2
fi
DOCKER_REPO=$1
NAMESPACE=$2
HOSTDOMAIN=$3
VERSION=$4

helm install ./apps/postgresql/helm/ --set image.registry=${DOCKER_REPO} --set postgresqlPassword=gRAHBwPjR8 --set livenessProbe.enabled=false --set readinessProbe.enabled=false --name postgresql-demo --set image.repository=postgresql --set image.tag=${VERSION} --namespace ${NAMESPACE}
if [[ $? -ne 0 ]] ; then
    echo "error failed to install postgresql"
    exit 1
fi

helm install ./apps/capplication/helm/ --name capplication-demo --set ingress.hosts=${HOSTDOMAIN} --set image.repository=${DOCKER_REPO}/capplication --set image.tag=${VERSION} --namespace ${NAMESPACE}
if [[ $? -ne 0 ]] ; then
    echo "error failed to install capplication"
    exit 1
fi

helm install ./apps/webappreact/helm/ --name webappreact-demo --set ingress.hosts=${HOSTDOMAIN} --set image.repository=${DOCKER_REPO}/webappreact --set image.tag=${VERSION} --namespace ${NAMESPACE}
if [[ $? -ne 0 ]] ; then
    echo "error failed to install webappreact"
    exit 1
fi

sleep 30
export POSTGRES_PASSWORD=$(kubectl get secret --namespace demo postgresql-demo -o jsonpath="{.data.postgresql-password}" | base64 --decode) ; kubectl run postgresql-demo-client --rm --tty -i --restart='Never' --namespace demo --image tmaier/postgresql-client:latest --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgresql-demo -U postgres -d postgres -p 5432 -c "CREATE DATABASE stocksdb"

export POSTGRES_PASSWORD=$(kubectl get secret --namespace demo postgresql-demo -o jsonpath="{.data.postgresql-password}" | base64 --decode) ; kubectl run postgresql-demo-client --rm --tty -i --restart='Never' --namespace demo --image tmaier/postgresql-client:latest --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgresql-demo -U postgres -d stocksdb -p 5432 -c "CREATE TABLE stocks (ticker varchar(10)) "

export POSTGRES_PASSWORD=$(kubectl get secret --namespace demo postgresql-demo -o jsonpath="{.data.postgresql-password}" | base64 --decode) ; kubectl run postgresql-demo-client --rm --tty -i --restart='Never' --namespace demo --image tmaier/postgresql-client:latest --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgresql-demo -U postgres -d stocksdb -p 5432 -c "INSERT INTO stocks (ticker) VALUES ('TSLA')"
