#!/bin/bash

set -e

docker_skip="false"
IMAGE_META="$(aws ecr describe-images \
  --repository-name "$ECR_REPOSITORY" \
  --image-ids "imageTag=$IMAGE_VERSION" 2>/dev/null || true)"

if [[ -n $IMAGE_META ]]; then
    if echo "${IMAGE_META}" | jq '.imageDetails[0].imageTags' | grep -q \""$IMAGE_VERSION"\"; then
        echo "$IMAGE_VERSION exists at $ECR_REPOSITORY repository"
        docker_skip="True"
    else
        echo "$IMAGE_VERSION not found or the JSON response changed"
    fi
else
    echo "$IMAGE_VERSION not found. Please check if the image for this branch has been built and the CI/CD job finished successfuly."
fi

echo "docker_skip=$docker_skip" >>"$GITHUB_OUTPUT"
