#!/bin/bash
################################################################################
##  File:  docker.sh
##  Team:  CI-Platform
##  Desc:  Pulls down the docker images used for building on ubuntu
################################################################################

source $HELPER_SCRIPTS/apt.sh
source $HELPER_SCRIPTS/document.sh

# Cache popular docker images
docker pull node:8
docker pull node:10
docker pull node:12
docker pull buildpack-deps:stretch
docker pull node:8-alpine
docker pull node:10-alpine
docker pull node:12-alpine
docker pull debian:8
docker pull debian:9
docker pull alpine:3.7
docker pull alpine:3.8
docker pull alpine:3.9
docker pull alpine:3.10

docker images

echo "Documenting Docker images cached"
docker_images=$(docker images)
DocumentInstalledItem "Docker ($docker_images)"
