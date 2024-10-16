#!/bin/bash
set -e

# Extract the branch name from GITHUB_REF
BRANCH_NAME=${GITHUB_REF##*/}
PROFILE="v-prod"
echo "::debug::ECR_REPOSITORY: $ECR_REPOSITORY"
echo "::debug::BRANCH_NAME: $BRANCH_NAME"

# Prepare the request data
data=$(cat <<EOF
{
  "repoName": "$ECR_REPOSITORY",
  "branchName": "$BRANCH_NAME"
}
EOF
)

# Make the API call
response=$(curl -sSfL --retry 5 --retry-all-errors -X POST \
    -H "X-API-KEY: $API_KEY" \
    "$LAZY_GO_URL/v1/aws/$PROFILE/ecr" \
    --data "$data" -v || echo "error")

# Output the response for debugging
echo "::debug::$response"

# Handle response based on your API's expected output
if [[ $response == *"already exists"* ]]; then
    echo "::notice::ECR Repository $ECR_REPOSITORY already exists"
elif [[ $response == *"created"* ]]; then
    echo "::notice::ECR Repository $ECR_REPOSITORY successfully created"
else
    echo "::error::Failed to handle the ECR Repository $ECR_REPOSITORY."
    exit 1
fi
