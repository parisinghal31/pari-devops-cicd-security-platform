# OPA Validation Report
_Generated: Tue May 12 07:27:09 UTC 2026_

## deployments/app-deployment.yaml
- Result: **PASS** (0 violations)


## examples/insecure-deployment.yaml (advisory — must FAIL)
- Result: **FAIL** (6 violations)
```
- Container 'worker' must define resource limits
- Container 'worker' must not allow privilege escalation
- Container 'worker' must not run as root (UID 0)
- Container 'worker' must not run in privileged mode
- Container 'worker' uses banned image tag 'latest'
- Deployment 'legacy-worker' must not use the 'default' namespace
```
