#!/bin/bash
set -e

docker_publish()
{
  sh ./scripts/publish.sh
  sh ./scripts/trivy_scan.sh
}

docker_publish
