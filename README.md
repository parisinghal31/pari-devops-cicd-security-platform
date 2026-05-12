# Enterprise DevOps Platform

[![CI - Development](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/ci-development.yml/badge.svg?branch=development)](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/ci-development.yml)
[![CD - Production](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/cd-production.yml/badge.svg?branch=production)](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/cd-production.yml)

End-to-end DevOps reference implementation covering Linux administration,
Git/GitHub workflow, GitHub Actions CI/CD, SonarQube static analysis and
Open Policy Agent policy enforcement.

## Repository layout
```
devops-cicd-security-platform/
  .github/workflows/
  artifacts/
  configs/
  deployments/
  examples/
  policies/
    deployment/
    security/
    container/
  reports/
  scripts/
  src/
  package.json
  docker-compose.sonarqube.yml
  sonar-project.properties
  README.md
```

## Branching strategy
| Branch        | Purpose                                   | Trigger                              |
|---------------|-------------------------------------------|--------------------------------------|
| `development` | Daily integration, feature work           | `ci-development.yml` on push         |
| `staging`     | Pre-production validation, QA sign-off    | Manual promotion from `development`  |
| `production`  | Live release branch                       | `cd-production.yml` on push          |

Flow: feature -> `development` -> `staging` -> `production`.

## Quick start
```bash
sudo bash scripts/01_linux_admin.sh
docker compose -f docker-compose.sonarqube.yml up -d
bash scripts/03_run_opa_validation.sh
```

## CI/CD pipeline
- **Trigger:** push or PR to `development`, push to `production`.
- **Stages:** Source Checkout -> Build -> Test -> Security Validation -> Deployment.
- **Artifacts:** uploaded to `artifacts/` and to GitHub Actions.
- **Rollback:** `cd-production.yml` runs `kubectl rollout undo` on failure.
- **Secrets:** `SONAR_TOKEN`, `SONAR_HOST_URL`, `PROD_DEPLOY_TOKEN`.

## SonarQube
SonarCloud project key `parisinghal31_devops-cicd-security-platform`,
organization `parisinghal31`. Quality gate wait enabled.

## Open Policy Agent
- `policies/deployment/` - replicas, namespace, resource limits.
- `policies/security/` - no root user, no privilege escalation.
- `policies/container/` - no `:latest`/`:nightly`/`:snapshot`, no privileged mode.

## Author
**Pari Singhal** - DevOps coursework, Make Up exam (merged main + feature edits).

