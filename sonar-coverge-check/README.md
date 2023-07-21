# Sonar Setup

<!-- action-docs-description -->
## Description

This Action check for existance of coverage report.

Required env:
  SONAR_PROJECT_KEY
  SONAR_TOKEN

## Usage

```yaml
- name: Sonar Coverage Check
  id: sonar-coverage-check
  uses: variant-inc/actions-collection/sonar-coverage-check@v2
  env:
    SONAR_PROJECT_KEY:
    SONAR_TOKEN:
```
<!-- action-docs-description -->

<!-- action-docs-inputs -->

<!-- action-docs-inputs -->

<!-- action-docs-outputs -->

<!-- action-docs-outputs -->

<!-- action-docs-runs -->
## Runs

This action is a `composite` action.
<!-- action-docs-runs -->
