#!/bin/bash
set -e

docker_publish()
{
  sh ./scripts/publish.sh
}

"$@"