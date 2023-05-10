#!/bin/bash
set -e

url_encoded_ecr_repository=$(echo "$ECR_REPOSITORY" | sed 's/\//\%2F/g')

echo "::debug::ECR_REPOSITORY: $ECR_REPOSITORY"
echo "::debug::URL_ECR_REPOSITORY: $url_encoded_ecr_repository"

{
    echo "::debug::$(curl -sSfL "https://$SECRET__LAZY_API_URL/tenants/apps/profiles/production/regions/$AWS_DEFAULT_REGION/ecr/repo/$url_encoded_ecr_repository/repo-policy" \
    --header "x-api-key: $SECRET__LAZY_API_KEY" | jq -c)"
    echo "::notice::ECR Repository $ECR_REPOSITORY already present"
} ||
{
    echo "Repository $ECR_REPOSITORY was not found"
    echo "Creating a repository with name ${ECR_REPOSITORY}"
    data=$(
        cat <<EOF
{
  "profile": "production",
  "region": "$AWS_REGION",
  "options": {
    "repositoryName": "$ECR_REPOSITORY"
    "imageTagMutability": "MUTABLE"
  }
}
EOF
    )
    echo "::debug::$(curl -sSfL -X POST \
      "https://$SECRET__LAZY_API_URL/tenants/apps/profiles/production/regions/$AWS_REGION/ecr/repo" \
      -d "$data")"
    echo "::notice::ECR Repository $ECR_REPOSITORY already created"
}
