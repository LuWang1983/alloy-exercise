#!/usr/bin/env bash
set -e

IMAGE_NAME=$1

GIT_SHA="$(git rev-parse HEAD)"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "SCRIPT_DIR=${SCRIPT_DIR}"
DOCKER_CONTEXT=$(cd -- "$( dirname -- "${SCRIPT_DIR}" )"/echo-server &> /dev/null && pwd )
echo "DOCKER_CONTEXT=${DOCKER_CONTEXT}"

# assumptions: docker is installed
docker buildx build \
    --platform=linux/amd64 \
    --tag="$IMAGE_NAME:latest" \
    --tag="$IMAGE_NAME:$GIT_SHA" \
    --file="${DOCKER_CONTEXT}/Dockerfile" \
    --push \
    "." \
