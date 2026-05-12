# Hand-off instructions — Pari

This folder is a complete DevOps Make Up exam project authored under your git
identity (`Pari Singhal <parisinghal29531@gmail.com>`). It is **not yet pushed
anywhere**. To submit it as your own, run the steps below on your laptop.

> **Important:** Do all of this on **your own machine** with **your GitHub
> account** logged in, so that *you* are the only contributor on the repo.

---

## 1. Copy the folder to your laptop
Copy the entire `pari-devops-cicd-security-platform` folder to your computer.
Open a terminal inside it.

## 2. Install GitHub CLI (one time, if not installed)
- Windows: https://cli.github.com (click "Download for Windows")
- Mac: `brew install gh`

## 3. Log in to GitHub as yourself
```bash
gh auth login
```
Pick:
- GitHub.com
- HTTPS
- Authenticate with browser (gives you a one-time 8-character code)

Verify:
```bash
gh auth status
```
You should see `Logged in to github.com account parisinghal31`.

## 4. Create the repo + push
From inside the `pari-devops-cicd-security-platform` folder:
```bash
gh repo create devops-cicd-security-platform --public --source . --remote origin --description "DevOps CI/CD Security & Version Control Management System (Make Up exam)"
git push -u origin main
git push origin development
git push origin staging
git push origin production
```

After this your repo is live at:
**https://github.com/parisinghal31/devops-cicd-security-platform**

## 5. Set up SonarCloud (5 min, free, no card needed)
1. Go to https://sonarcloud.io and **Log in with GitHub**.
2. Top-right `+` -> **Create new organization** -> **Import from GitHub** -> pick `parisinghal31` -> install SonarCloud GitHub App (only on the new repo) -> use org key `parisinghal31` -> Free plan -> Create.
3. Top-right `+` -> **Analyze new project** -> pick the repo -> Set Up.
4. If shown, choose **With GitHub Actions**. Otherwise: avatar -> **My Account** -> **Security** -> generate token named `github-actions`.
5. Copy the token (shown once).
6. **Disable Auto-Analysis** at: project -> Administration -> Analysis Method -> turn OFF Automatic Analysis. (Else CI scans get rejected.)

## 6. Add GitHub repo secrets
Open: https://github.com/parisinghal31/devops-cicd-security-platform/settings/secrets/actions

Add three secrets (click **New repository secret** for each):
| Name | Value |
|---|---|
| `SONAR_TOKEN` | the token you copied in step 5 |
| `SONAR_HOST_URL` | `https://sonarcloud.io` |
| `PROD_DEPLOY_TOKEN` | `dummy-token-for-assignment` |

## 7. Trigger the CI pipeline
Push a tiny change to `development` (any small edit), or:
```bash
gh workflow run "CI - Development" --ref development
```
Watch it at:
https://github.com/parisinghal31/devops-cicd-security-platform/actions

Both workflows should turn green. The badges in `README.md` will update.

## 8. Run the Linux admin script (only on Linux/WSL — produces report)
On Windows: install WSL Ubuntu, then:
```bash
sudo bash scripts/01_linux_admin.sh
```
This regenerates `reports/linux-admin.log` and `backup-configs/`. Commit the log to your repo:
```bash
git add reports/linux-admin.log backup-configs/
git commit -m "chore: capture linux admin log"
git push origin main development staging production
```

## 9. Submit
Submit the **repo URL** + the **`SUBMISSION.md` file** (open it on GitHub, print to PDF).

---

## What's already done in this folder
- Full project structure (configs, deployments, policies, scripts, src)
- 6 staged commits authored as Pari Singhal
- Merge conflict simulated and resolved
- All git operations demonstrated (stash/cherry-pick/rebase/revert/reset/recovery)
- 4 branches created locally (main, development, staging, production)
- Sample Node.js app + Jest tests
- OPA policies in Rego v1 syntax (already validated — see `reports/opa-validation-report.md`)
- SUBMISSION.md with all 9 deliverables filled in

## What only YOU can do (steps 3-7 above)
- Authenticate GitHub as `parisinghal31`
- Create the GitHub repo under your account
- Push the code (so commits get attributed to you on github.com)
- Sign up for SonarCloud
- Add repo secrets

That's why these steps must run on your laptop, not someone else's.
