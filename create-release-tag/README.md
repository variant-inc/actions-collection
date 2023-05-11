# Build Push Image Action

<!-- action-docs-description -->
## Description

This Action creates tags & release when merged to Master/Main.
If tag/release already exists, then it is updated.
<!-- action-docs-description -->

<!-- markdownlint-disable line-length -->
<!-- action-docs-inputs -->
## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| create_release | Creates Release if true | `false` | True |
<!-- action-docs-inputs -->
<!-- markdownlint-enable line-length -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->

## Usage

```yaml
- name: Sonar Setup
  id: sonar-setup
  uses: variant-inc/actions-collection/sonar-setup@v2
  env:
    SONAR_PROJECT_KEY:
    SONAR_PROJECT_NAME:
    SECRET__SONAR_TOKEN:
    GITHUB_REPOSITORY:
    GITHUB_TOKEN:
```
