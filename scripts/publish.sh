#!/bin/bash

set -eu

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
IMAGE="$ECR_REGISTRY/$INPUT_ECR_REPOSITORY:$IMAGE_VERSION"

cleanup() {
  set +e
  rm -rf publish
  docker logout "$ECR_REGISTRY"
  docker image rm "$IMAGE"
}

trap "cleanup" EXIT

docker login --username drivevariant -p "$DOCKER_PASSWORD"

echo "Connecting to AWS account."

docker login -u AWS -p "$(aws ecr get-login-password)" "$ECR_REGISTRY"

DOCKERFILE_PATH="$INPUT_DOCKERFILE_DIR_PATH"

mkdir -p /publish

eval "docker build -t $IMAGE $DOCKERFILE_PATH $(for i in $(env); do if [ ! -z $i ]; then out+="--build-arg $i "; fi; done; echo "$out")"

echo "Start: Trivy Scan"
sh -c "./actions-collection/scripts/trivy_scan.sh"
echo "End: Trivy Scan"

docker push "$IMAGE"

echo "Setting image name to environment variables"
echo "IMAGE_NAME=$IMAGE" >>"$GITHUB_ENV"
