# Problem 1 — DevOps CI/CD Security & Version Control Management System (Make Up Exam)
**Submitted by:** Pari Singhal
**GitHub:** [parisinghal31](https://github.com/parisinghal31)
**Repository:** https://github.com/parisinghal31/devops-cicd-security-platform

---

## Deliverable 1 — GitHub Repository
- **URL:** https://github.com/parisinghal31/devops-cicd-security-platform
- **Visibility:** Public
- **Branches:** `main`, `development`, `staging`, `production`
- **Sole contributor:** `parisinghal31`

---

## Deliverable 2 — Linux Configuration Structure

**Script:** [`scripts/01_linux_admin.sh`](scripts/01_linux_admin.sh)
**Log:** [`reports/linux-admin.log`](reports/linux-admin.log)

### Users
```
developer:x:...:/home/developer:/bin/bash
tester:x:...:/home/tester:/bin/bash
devopsadmin:x:...:/home/devopsadmin:/bin/bash
```

### Groups
```
developers:x:...:developer,tester
operations:x:...:devopsadmin
```

### Permissions
- `configs/`, `deployments/` -> group `developers`, mode `770`
- `policies/`, `reports/` -> owner `devopsadmin:operations`, mode `750`
- `devopsadmin` -> passwordless sudo (full admin)

### Project tree
```
devops-cicd-security-platform/
  .github/workflows/
  artifacts/
  backup-configs/
  configs/{deployment.yaml,pipeline.yaml,security.conf}
  deployments/app-deployment.yaml
  examples/insecure-deployment.yaml
  policies/{deployment,security,container}/*.rego
  reports/{deployment-log.md,linux-admin.log,opa-validation-report.md,sonarqube/}
  scripts/{01_linux_admin,02_git_workflow_demo,03_run_opa_validation,04_opa_advisory_check}.sh
  src/{app.js,app.test.js}
  package.json
  docker-compose.sonarqube.yml
  sonar-project.properties
  README.md
```

### Background process + process tree + archive
All shown in `reports/linux-admin.log` (created by Task 11/12/13 of the script).

---

## Deliverable 3 — Git & GitHub Workflow

### Commit history (graph)
```
* chore: cleanup demo artifacts
* demo: cleanup recovered file
* demo: file to delete and recover           <-- file recovery
* feat: rebase demo A                         <-- rebase
* chore: main moves forward
* Revert "hotfix: add hotfix marker"          <-- revert
* hotfix: add hotfix marker                   <-- cherry-pick
* chore: resolve merge conflict on README     <-- merge conflict resolved
|\
| * feat: feature-branch tweak on README author line
* | feat: main-branch tweak on README author line
|/
* docs: README with branching strategy, badges, quickstart
* feat(opa): Rego v1 policies + validator
* feat(sonar): SonarCloud configuration + local SonarQube docker stack
* feat(cicd): GitHub Actions CI for development and CD for production
* feat(git): branching workflow + recovery demo script
* feat(linux): scaffold project layout, users/groups, configs, backups
```

### Branching strategy
| Branch        | Purpose                                | Trigger                              |
|---------------|----------------------------------------|--------------------------------------|
| `development` | Daily integration                      | `ci-development.yml` on push         |
| `staging`     | QA validation                          | Manual promotion                     |
| `production`  | Live releases                          | `cd-production.yml` on push          |

---

## Deliverable 4 — CI/CD Pipeline Configuration

**Tool:** GitHub Actions
**Files:**
- [`.github/workflows/ci-development.yml`](.github/workflows/ci-development.yml)
- [`.github/workflows/cd-production.yml`](.github/workflows/cd-production.yml)

### Stages
1. Source Checkout
2. Build (`npm install`)
3. Test (`jest --coverage`)
4. Security Validation (SonarQube + OPA)
5. Deployment (artifact upload)

### Secrets to add (in GitHub repo settings)
| Name | Value |
|---|---|
| `SONAR_TOKEN` | from sonarcloud.io |
| `SONAR_HOST_URL` | `https://sonarcloud.io` |
| `PROD_DEPLOY_TOKEN` | `dummy-token-for-assignment` |

### Status badges (auto-update once first run completes)
[![CI - Development](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/ci-development.yml/badge.svg?branch=development)](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/ci-development.yml)
[![CD - Production](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/cd-production.yml/badge.svg?branch=production)](https://github.com/parisinghal31/devops-cicd-security-platform/actions/workflows/cd-production.yml)

### Rollback
The `Rollback on failure` step in `cd-production.yml` runs on deploy failure
and executes `kubectl rollout undo` (placeholder).

---

## Deliverable 5 — SonarQube Reports

**Service:** SonarCloud (free tier, public repo)
**Org:** `parisinghal31`
**Project key:** `parisinghal31_devops-cicd-security-platform`
**Project URL:** https://sonarcloud.io/project/overview?id=parisinghal31_devops-cicd-security-platform
**Properties:** [`sonar-project.properties`](sonar-project.properties)
**Scanned:** `src/`, `configs/`, `scripts/`, `deployments/`
**Quality gate:** `sonar.qualitygate.wait=true` (CI fails if gate fails)

---

## Deliverable 6 — OPA Policies

**Engine:** Open Policy Agent (Rego v1)

| File                                   | Enforces                                                                |
|----------------------------------------|-------------------------------------------------------------------------|
| `policies/deployment/deployment.rego`  | replicas defined, namespace not `default`, resource limits required     |
| `policies/security/security.rego`      | no root user, no privilege escalation, runAsNonRoot                     |
| `policies/container/container.rego`    | no privileged mode, image must be tagged, no `:latest`/`:nightly`/`:snapshot` |

---

## Deliverable 7 — Validation Report

[`reports/opa-validation-report.md`](reports/opa-validation-report.md):
```
## deployments/app-deployment.yaml -> PASS (0 violations)

## examples/insecure-deployment.yaml -> FAIL (6 violations)
  - Container 'worker' must define resource limits
  - Container 'worker' must not allow privilege escalation
  - Container 'worker' must not run as root (UID 0)
  - Container 'worker' must not run in privileged mode
  - Container 'worker' uses banned image tag 'latest'
  - Deployment 'legacy-worker' must not use the 'default' namespace
```

The OPA gate in `cd-production.yml` exits non-zero on any violation, blocking
the production deployment.

---

## Deliverable 8 — Deployment Logs

- File: [`reports/deployment-log.md`](reports/deployment-log.md)
- Live runs: https://github.com/parisinghal31/devops-cicd-security-platform/actions

---

## Deliverable 9 — README Documentation

[`README.md`](README.md) covers project description, layout, branching strategy,
quickstart, CI/CD overview, SonarQube + OPA usage, and live status badges.
