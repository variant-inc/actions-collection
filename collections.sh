#!/bin/bash
set -e

docker_publish()
{
  echo "START: Publish.sh"
  sh ./scripts/publish.sh
  echo "END: Publish.sh"
  echo "START: trivy_scan.sh"
  sh ./scripts/trivy_scan.sh
  echo "END: trivy_scan.sh"
}

docker_publish
