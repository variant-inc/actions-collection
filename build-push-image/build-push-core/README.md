# Build Push Image Action

<!-- action-docs-description -->
## Description

Build the Image and Push to ECR Repository
required env:
  IMAGE_VERSION
<!-- action-docs-description -->

<!-- markdownlint-disable line-length -->
<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| dockerfile_dir_path | Directory path to the dockerfile | `false` | . |
| ecr_registry | ECR repository name | `true` |  |
| ecr_repository | ECR repository name | `true` |  |
<!-- action-docs-inputs -->
<!-- markdownlint-enable line-length -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
