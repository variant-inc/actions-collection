# Build Push Image Action

<!-- action-docs-description -->
## Description

Upload Package to S3

required env:
  IMAGE_VERSION

## Permissions

Add the following permissions to the job

```yaml
permissions:
  id-token: write
  contents: read
```

## Usage

```yaml
  - name: Upload Package to S3
    uses: variant-inc/actions-collection/upload-s3-package@v2
    with:
      package_path: 'path/to/package'
      s3_bucket: 'my-s3-bucket'
      package_name: 'my-cli'
```
<!-- action-docs-description -->

<!-- markdownlint-disable line-length -->
<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| package_path | The local path of the package to be uploaded | `true` | |
| s3_bucket | The name of the target S3 bucket  | `true` |  |
| package_name | The name of the package.  | `true` | |
<!-- action-docs-inputs -->
<!-- markdownlint-enable line-length -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
