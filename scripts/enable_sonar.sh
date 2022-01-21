#!/bin/bash

set -ex

echo "Fetching repo id"
REPO_ID=$(curl --fail -sL -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/repos/${GITHUB_REPOSITORY} | jq --raw-output ".id")
# GITHUB_REPOSITORY name will be org_name/repo_name

if [ -z "$REPO_ID" ]; then
    echo "Failed: Repo id is empty"
    exit 1
else
    echo "Printing repo id : $REPO_ID"
fi

echo "Running provision_projects"
curl --fail --include \
    --request POST \
    --header "Content-Type: application/x-www-form-urlencoded" \
    -u ${SONAR_TOKEN}: \
    --data-binary "installationKeys=${GITHUB_REPOSITORY}%7C${REPO_ID}&organization=${SONAR_ORG}" \
    "https://sonarcloud.io/api/alm_integration/provision_projects"

SONAR_PROJECT_KEY=$(echo ${GITHUB_REPOSITORY} | sed 's/\//_/')
echo "Printing SONAR_PROJECT_KEY: $SONAR_PROJECT_KEY"
echo "Running autoscan"
curl --fail --include \
    -u ${SONAR_TOKEN}: \
    "https://sonarcloud.io/api/autoscan/eligibility?autoEnable=false&projectKey=$SONAR_PROJECT_KEY"

echo "Running activation"
curl --fail --include \
    --request POST \
    --header "Content-Type: application/x-www-form-urlencoded" \
    -u ${SONAR_TOKEN}: \
    --data-binary "enable=false&projectKey=$SONAR_PROJECT_KEY" \
    "https://sonarcloud.io/api/autoscan/activation"
