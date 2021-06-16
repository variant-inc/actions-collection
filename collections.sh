#!/bin/bash
set -e


ecr_create()
{
  ECR_REPO=$1

  GET_RESPONSE_BODY=$( curl --location --request GET "$LAZY_API_URL/profiles/prod/regions/$AWS_REGION/ecr/repo" \
  --header "x-api-key:  $LAZY_API_KEY" \
  --data-raw "{
          \"profile\" : \"prod\",
          \"region\": \"$AWS_REGION\",
          \"options\": {
              \"repositoryName\": \"$ECR_REPO\"
          }
      }" | jq -r '.repositories[]')

  # shellcheck disable=SC2206
  # Otherwise bash will not parse array
  arr=( $GET_RESPONSE_BODY )
  REPO_DOES_NOT_EXIST=true

  for i in "${arr[@]}"
  do
      echo "Repo: $i"
      if [[ ($ECR_REPO == "$i") ]]
      then
          echo "ECR REPO already exists"
          REPO_DOES_NOT_EXIST=false
          break
      fi
  done

  if [[ $REPO_DOES_NOT_EXIST = true ]]
  then
      echo "ECR REPO Does not exist"
      echo "Creating ECR REPO: $ECR_REPO"
      wget \
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
  fi
}


"$@"
