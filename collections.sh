#!/bin/bash
set -e

docker_publish()
{
  echo $INPUT_ECR_REPOSITORY
  sh actions-collection/scripts/publish.sh
}

"$@"