#!/bin/bash

set -e

echo "Running provision_projects"
curl --include \
    --request POST \
    --header "Content-Type: application/x-www-form-urlencoded" \
    -u ${SONAR_TOKEN}: \
    --data-binary "installationKeys=${GITHUB_ORG}%2F${REPO_NAME}%7C${REPO_ID}&organization=${SONAR_ORG}" \
    "https://sonarcloud.io/api/alm_integration/provision_projects"

echo "Running autoscan"
curl --include \
    -u ${SONAR_TOKEN}: \
    "https://sonarcloud.io/api/autoscan/eligibility?autoEnable=true&projectKey=${GITHUB_ORG}_${REPO_NAME}"

echo "Running activation"
curl --include \
    --request POST \
    --header "Content-Type: application/x-www-form-urlencoded" \
    -u ${SONAR_TOKEN}: \
    --data-binary "enable=true&projectKey=${GITHUB_ORG}_${REPO_NAME}" \
    "https://sonarcloud.io/api/autoscan/activation"
