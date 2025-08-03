#!/usr/bin/env bash
set -e

IMAGE_NAME=$1

GIT_SHA="$(git rev-parse HEAD)"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "SCRIPT_DIR=${SCRIPT_DIR}"
DOCKER_CONTEXT=$(cd -- "$( dirname -- "${SCRIPT_DIR}" )"/echo-server &> /dev/null && pwd )
echo "DOCKER_CONTEXT=${DOCKER_CONTEXT}"

# assumptions: docker is installed
# Improvements: using Packer and Ansible to install all the dependencies in the AMI for the EC2 instance
# docker runs the application that will make calls to the database in the private subnet
docker buildx build \
    --platform=linux/amd64 \
    --tag="$IMAGE_NAME:latest" \
    --tag="$IMAGE_NAME:$GIT_SHA" \
    --file="${DOCKER_CONTEXT}/Dockerfile" \
    --push \
    "." \
