#!/bin/bash
set -e

docker_publish()
{
  echo "ls -la"
  ls -la
  sh actions-collection/scripts/publish.sh
}

"$@"