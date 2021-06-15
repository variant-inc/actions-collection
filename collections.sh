#!/bin/bash
set -e

docker_publish()
{
  sh ./actions-collection/scripts/publish.sh
}

"$@"