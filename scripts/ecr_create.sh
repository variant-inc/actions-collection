#!/bin/bash
set -ex

ECR_REPO=$1
URL_ECR_REPO=$( echo "$ECR_REPO" | sed 's/\//\%2F/g')

echo "ECR_REPO: $ECR_REPO"
echo "URL_ECR_REPO: $URL_ECR_REPO"

curl -f -L "url"  --request GET "https://$LAZY_API_URL/profiles/prod/regions/$AWS_REGION/ecr/repo/$URL_ECR_REPO/repo-policy" \
  --header "x-api-key:  $LAZY_API_KEY" \
|| { echo "Repo not found. Hence creating a new repo with name ${ECR_REPO}" &&
  wget \
  --content-on-error -O -\
  --method=POST \
  --timeout=0 \
  --https-only \
  --header "x-api-key:  $LAZY_API_KEY" \
  --header 'Content-Type: application/json' \
  --body-data "{
        \"profile\" : \"prod\",
        \"region\": \"$AWS_REGION\",
        \"options\": {
            \"repositoryName\": \"$ECR_REPO\"
        }
    }" \
  "https://$LAZY_API_URL/profiles/prod/regions/$AWS_REGION/ecr/repo" 
  }
