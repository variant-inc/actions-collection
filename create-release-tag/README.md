# Build Push Image Action

<!-- action-docs-description -->
## Description

This Action creates tags & release when merged to Master/Main.
If tag/release already exists, then it is updated.

## Permissions

Add the following permissions to the job

```yaml
permissions:
  contents: write
```

## Usage

```yaml
- name: Create Release Action
  uses: variant-inc/actions-collection/create-release-tag@v2
  with:
    create_release: 'true'
```
<!-- action-docs-description -->

<!-- markdownlint-disable line-length -->
<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| create_release | Creates Release if true | `false` | true |
<!-- action-docs-inputs -->
<!-- markdownlint-enable line-length -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
