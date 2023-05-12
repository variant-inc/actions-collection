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
| dockerfile_dir_path | Directory Path to the dockerfile | `false` | . |
| ecr_registry | ECR Registry ID | `true` |  |
| ecr_repository | ECR Repository Name | `true` |  |
<!-- action-docs-inputs -->
<!-- markdownlint-enable line-length -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
