# Build Push Image Action

<!-- action-docs-description -->
## Description

This Action sets some variables and necessities for sonar
Required env:
  SONAR_PROJECT_KEY
  SONAR_PROJECT_NAME
  SECRET__SONAR_TOKEN
  GITHUB_REPOSITORY
  GITHUB_TOKEN
<!-- action-docs-description -->

<!-- action-docs-inputs -->

<!-- action-docs-inputs -->

<!-- action-docs-outputs -->
## Outputs

| parameter | description |
| --- | --- |
| wait_flag | Fail Build if Sonarscan fails |
| sonar_skip | Skip Sonarscan |
<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->

## Usage

```yaml
- name: Sonar Setup
  id: sonar-setup
  uses: variant-inc/actions-collection/sonar-setup@f/v2
  env:
    SONAR_PROJECT_KEY:
    SONAR_PROJECT_NAME:
    SECRET__SONAR_TOKEN:
    GITHUB_REPOSITORY:
    GITHUB_TOKEN:
```
