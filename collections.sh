#!/bin/bash
set -e

docker_publish()
{
  echo "ECR_REPO: $ECR_REPOSITORY"
  echo "INPUT_ECR_REPO: $INPUT_ECR_REPOSITORY"
  sh actions-collection/scripts/publish.sh
}

"$@"