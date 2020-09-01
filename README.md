# Goaty Finance App
Vulnerable Stocks App made of components like React, Postgresql and C Application

## Warning
This application is a Vulnerable Web Application.
Please make sure it is not deployed on Production Environments, Public facing servers or Critical Infrastructure.
Please use it at your own risk.
We have made it clear that the application should not be used maliciously.

## Prerequisites
- docker
- kubernetes
- helm
- nginx running in kubernetes

## Get Quandl free Api Key
Free key can be obtained from https://docs.quandl.com/

## Install node locally
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
```

## Install node modules locally
```
cd apps/webappreact/
npm install
cd ../../
```

## Build Docker Images
```
scripts/build-microservices.sh <DOCKER_REPO> <QUANDL_KEY> <HOSTDOMAIN> <VERSION>
```

## Install Microservices 
```
scripts/install-microservices.sh <DOCKER_REPO> <NAMESPACE> <HOSTDOMAIN> <VERSION>
```
