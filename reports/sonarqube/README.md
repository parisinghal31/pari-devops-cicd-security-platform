# SonarQube Reports

Reports written by the `Security Validation - SonarQube Scan` step in
`.github/workflows/ci-development.yml`. The CI run uploads the analysis to the
SonarQube server defined by `SONAR_HOST_URL` and the project key
`company-devops-platform` (see `sonar-project.properties`).

## Local scan
```bash
docker compose -f docker-compose.sonarqube.yml up -d
# wait ~60s for SonarQube to boot, then create token at http://localhost:9000
docker run --rm -v "$PWD":/usr/src sonarsource/sonar-scanner-cli \
  -Dsonar.host.url=http://host.docker.internal:9000 \
  -Dsonar.login=$SONAR_TOKEN
```

## Quality gate
The scan is configured with `sonar.qualitygate.wait=true`, so the CI step (and
therefore the pipeline) fails automatically if the gate fails.

## Sample report metrics (placeholder)
| Metric           | Value |
|------------------|-------|
| Bugs             | 0     |
| Vulnerabilities  | 0     |
| Code smells      | 2     |
| Duplications     | 0.0%  |
| Coverage         | 92%   |
| Quality gate     | PASS  |
