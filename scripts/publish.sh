#!/bin/bash

set -xe

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

touch args.txts
env | tee args.txt
BUILD_ARGS=""
while IFS='=' read -r n v; do BUILD_ARGS+="--build-arg $n='$v' "; done < <(cat args.txt)

eval "docker build $BUILD_ARGS -t $IMAGE $DOCKERFILE_PATH"

echo "Start: Trivy Scan"
sh -c "./actions-collection/scripts/trivy_scan.sh"
echo "End: Trivy Scan"

docker push "$IMAGE"

echo "Setting image name to environment variables"
echo "IMAGE_NAME=$IMAGE" >>"$GITHUB_ENV"
