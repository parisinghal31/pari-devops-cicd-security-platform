# Deployment Log

Each entry is appended by the `CD - Production` workflow in
`.github/workflows/cd-production.yml`.

| Timestamp (UTC) | Run ID | Commit | Result | Notes |
|-----------------|--------|--------|--------|-------|
| _populated by CI_ | _populated_ | _populated_ | _populated_ | _populated_ |

## Rollback procedure
On `failure()` the workflow's `Rollback on failure` step runs and (when wired
to a real cluster) executes:

```bash
kubectl rollout undo deployment/company-devops-app -n production
```
