#!/bin/bash
set -e

# shellcheck disable=SC2154
# Determine the countNumber based on the GitVersion_PreReleaseLabel
if [[ "$GitVersion_PreReleaseLabel" != "" ]]; then
	COUNT_NUMBER=30
else
	COUNT_NUMBER=50
fi

# Construct the lifecycle policy JSON
LIFECYCLE_POLICY=$(
	cat <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": $COUNT_NUMBER
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
)

PROFILE="production"
echo "::debug::ECR_REPOSITORY: $ECR_REPOSITORY"
echo "::debug::LIFECYCLE_POLICY: $LIFECYCLE_POLICY"

# Prepare the request data
data=$(
	cat <<EOF
{
    "repoName": "$ECR_REPOSITORY",
    "lifeCyclePolicy": $LIFECYCLE_POLICY
}
EOF
)

# Make the API call
response=$(curl -sSfL --retry 5 --retry-all-errors -X POST \
	-H "Authorization: $LAZY_GO_KEY" \
	"$LAZY_GO_URL/v1/aws/$PROFILE/ecr" \
	--data "$data" || echo "error")

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
