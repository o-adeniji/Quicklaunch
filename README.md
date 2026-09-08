# QuickLaunch DevOps Project

QuickLaunch is a beginner CI/CD project that demonstrates how a static website moves from source code through automated testing and artifact creation to deployment on an Nginx web server.

## Project Objective

The objective was to build a repeatable delivery process that:

- Tests the application before packaging
- Creates versioned deployment artifacts
- Uses GitHub Actions for continuous integration
- Deploys a tested artifact to Nginx
- Verifies the live application version
- Supports rollback to a previous known-good artifact

## CI/CD Workflow

```text
Developer changes source code
→ Git→ Git feature branch and pull request
→ GitHub Actions starts
→ Smoke test runs
→ Versioned artifact is built
→ Artifact is stored
→ Artifact is manually deployed to Nginx
→ Live application is verified
→ Previous known-good artifact is available for rollback

## Project Structure
 
quicklaunch/
├── .github/workflows/ci.yml
├── scripts/
│   ├── build.sh
│   └── deploy.sh
├── src/
│   ├── app.js
│   ├── index.html
│   └── styles.css
├── tests/
│   └── smoke-test.sh
├── .gitignore
└── README.md
```

## 1. Run the Smoke Test

```bash
./tests/smoke-test.sh
```

The smoke test:

1. Confirms the required website files exist.
2. Starts a temporary Python server on port `8080`.
3. Requests the website.
4. Confirms an HTTP `200` response.
5. Confirms the page contains `QuickLaunch`.
6. Stops the temporary server.

## 2. Build a Versioned Artifact

```bash
./scripts/build.sh 1.1.0
```

This packages the files inside `src/` into:

```text
dist/quicklaunch-1.1.0.tar.gz
```

Inspect the artifact without extracting it:

```bash
tar -tzf dist/quicklaunch-1.1.0.tar.gz
```

## 3. Continuous Integration

The workflow is defined in:

```text
.github/workflows/ci.yml
```

GitHub Actions starts when:

- Code is pushed to `main`.
- A pull request targeting `main` is opened or updated.

The workflow checks out the repository, runs the smoke test, builds an artifact and uploads it to GitHub Actions artifact storage.

## 4. Deploy to Nginx

```bash
./scripts/deploy.sh dist/quicklaunch-1.1.0.tar.gz
```

The deployment script:

1. Confirms the artifact exists.
2. Extracts it into `/var/www/html`.
3. Validates the Nginx configuration.
4. Reloads Nginx.
5. Confirms the live page contains `QuickLaunch`.

## 5. Verify the Live Application

Check server availability:

```bash
curl -I http://localhost
```

Check the deployed application version:

```bash
curl -s http://localhost/app.js
```

A successful deployment of version `1.1.0` displays:

```javascript
const version = "1.1.0";
```

## 6. Roll Back

If version `1.1.0` is faulty, redeploy the previous known-good artifact:

```bash
./scripts/deploy.sh dist/quicklaunch-1.0.0.tar.gz
```

Then verify the live version:

```bash
curl -s http://localhost/app.js
```

Rollback changes the live environment only. It does not reverse Git history or change the `main` branch.

## 7. Inspect Nginx Logs

Recent access requests:

```bash
sudo tail -n 5 /var/log/nginx/access.log
```

Recent notices and errors:

```bash
sudo tail -n 5 /var/log/nginx/error.log
```

## Troubleshooting Experience

During deployment, every deployment message appeared twice. I inspected `scripts/deploy.sh` with line numbers and discovered that the script had been duplicated. I removed the repeated section, validated the syntax with `bash -n`, redeployed the artifact and verified that the script executed only once.

## Skills Demonstrated

- Git feature-branch and pull-request workflow
- Continuous integration with GitHub Actions
- Automated smoke testing
- Artifact creation and storage
- Nginx deployment and validation
- Live-version verification
- Rollback procedures
- Log inspection and troubleshooting

## Future Improvements

- Automate deployment after approval
- Add stronger functional and version tests
- Add automated health monitoring
- Use separate development, staging and production environments
- Containerize the application with Docker
