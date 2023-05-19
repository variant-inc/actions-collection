# Build Push Image Action

<!-- action-docs-description -->
## Description

Build the Image and Push to ECR Repository

required env:
  IMAGE_VERSION
  LAZY_API_URL
  LAZY_API_KEY

## Permissions

Add the following permissions to the job

```yaml
permissions:
  id-token: write
  contents: read
```

## Usage

```yaml
- uses: variant-inc/actions-collection/build-push-image@v2
  with:
    ecr_repository: demo/example
  env:
    IMAGE_VERSION
    LAZY_API_URL
    LAZY_API_KEY
```
<!-- action-docs-description -->

<!-- markdownlint-disable line-length -->
<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| dockerfile_dir_path | Directory path to the dockerfile | `false` | . |
| ecr_repository | ECR repository name | `true` |  |
| aws_region | Region where the image will be created. Defaults to us-east-2.  | `false` | us-east-2 |
<!-- action-docs-inputs -->
<!-- markdownlint-enable line-length -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
