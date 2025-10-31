# SonarQube integration

This repository uses Maven and is a multi-module microservices project. The CI workflow (`.github/workflows/ci-dev.yml`) runs a SonarQube analysis step during the `maven-build` job using the Maven `sonar:sonar` goal.

## What you need

1. A running SonarQube server reachable from the runner (you mentioned you have a local runner). Make sure the runner host can reach the SonarQube server (network, ports).
2. A Sonar token with `Execute Analysis` permission. Create it in SonarQube (Your Account > Security > Tokens).
3. Set these repository secrets in GitHub:
   - `SONAR_HOST_URL` — URL of SonarQube (e.g. `http://sonarqube.local:9000`)
   - `SONAR_TOKEN` — the analysis token value

## CI behavior

- The workflow runs `./mvnw verify` so JaCoCo can produce an aggregated coverage report for the whole multi-module project.
- After `verify` the workflow runs the Maven Sonar plugin and passes the aggregated JaCoCo XML to Sonar using:

  `-Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco-aggregate/jacoco.xml`

- If the secrets are not set, the job will skip Sonar analysis (prints a message and exits 0). This avoids breaking CI while you configure secrets.
- The Maven plugin will automatically detect modules from the root `pom.xml` and analyze them together.

## Running analysis locally (using your local runner)

On the machine that runs the self-hosted runner (and that can reach the Sonar server):

1. Export the variables (example):

```bash
export SONAR_HOST_URL="http://localhost:9000"
export SONAR_TOKEN="<your-token-here>"
```

2. From the repository root run:

```bash
chmod +x ./mvnw
./mvnw -DskipTests sonar:sonar -Dsonar.host.url="$SONAR_HOST_URL" -Dsonar.login="$SONAR_TOKEN"
```

This will perform the same analysis the CI would run.

## Optional improvements / next steps

- Add `sonar.projectKey` and `sonar.organization` explicitly to `pom.xml` or to a `sonar-project.properties` if you want more control over project keys per environment.
- Configure coverage reporting (JaCoCo) so Sonar shows coverage metrics. Typical steps:
  - Add JaCoCo plugin to Maven
  - Generate report during `mvn test`/`mvn verify`
  - Add `-Dsonar.java.coveragePlugin=jacoco` and proper `sonar.coverage.jacoco.xmlReportPaths` to the analysis command.
- If you prefer to run a separate Sonar job or publish per microservice, adjust `sonar.projectKey` per module.

If you want, I can:
- Add JaCoCo configuration and example coverage wiring.
- Add finer sonar property overrides per module.
- Add GitHub Action secrets guidance or a workflow that uses a dedicated Sonar GitHub Action plugin.
