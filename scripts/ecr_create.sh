#!/bin/bash
set -e

ECR_REPO=$1
URL_ECR_REPO=$( echo $ECR_REPO | sed 's/\//\%2F/g')

curl -f -L "url"  --request GET "$LAZY_API_URL/profiles/prod/regions/$AWS_REGION/ecr/repo/$URL_ECR_REPO/repo-policy" \
  --header "x-api-key:  $LAZY_API_KEY" \
|| { echo "Repo not found. Hence creating a new repo with name ${ECR_REPO}" &&
  wget \
  --content-on-error -O -\
  --method=POST \
  --timeout=0 \
  --header "x-api-key:  $LAZY_API_KEY" \
  --header 'Content-Type: application/json' \
  --body-data "{
        \"profile\" : \"prod\",
        \"region\": \"$AWS_REGION\",
        \"options\": {
            \"repositoryName\": \"$ECR_REPO\"
        }
    }" \
  "$LAZY_API_URL/profiles/prod/regions/$AWS_REGION/ecr/repo" 
  }
