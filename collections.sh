#!/bin/bash
set -e

docker_publish()
{
  ls -la
  ls -la actions-collection
  sh actions-collection/scripts/publish.sh
}

"$@"