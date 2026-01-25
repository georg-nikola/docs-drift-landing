# docs-drift Landing Page

Landing page for [docs-drift](https://github.com/georg-nikola/docs-drift) - CLI tool that detects documentation drift by validating code examples in Markdown files.

**Live site**: [https://docs-drift.georg-nikola.com](https://docs-drift.georg-nikola.com)

## Overview

This repository contains the landing page for docs-drift, a static site built with HTML, CSS, and JavaScript, served via nginx in a Docker container and deployed to Kubernetes.

## Features

- Modern, responsive design with dark mode
- Lightweight static files (HTML/CSS/JS)
- Fast nginx-based serving
- Health check endpoint at `/health`
- Kubernetes-ready with Helm chart
- CI/CD with GitHub Actions

## Local Development

### Prerequisites

- Docker (for containerized development)
- Or any static file server (Python, Node.js, etc.)

### Running Locally

**Option 1: Using Python**

```bash
# Python 3
python -m http.server 8080

# Open http://localhost:8080 in your browser
```

**Option 2: Using Node.js**

```bash
npx serve -l 8080

# Open http://localhost:8080 in your browser
```

**Option 3: Using Docker**

```bash
# Build the image
docker build -t docs-drift-landing .

# Run the container
docker run -p 8080:8080 docs-drift-landing

# Open http://localhost:8080 in your browser
```

### File Structure

```
docs-drift-landing/
├── index.html          # Main HTML page
├── styles.css          # Stylesheet
├── script.js           # JavaScript for interactivity
├── favicon.svg         # Site favicon
├── nginx.conf          # Nginx configuration
├── Dockerfile          # Container build instructions
├── .dockerignore       # Docker build exclusions
├── helm/               # Kubernetes Helm chart
│   └── landing-page/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingressroute.yaml
└── .github/
    └── workflows/
        └── docker-publish.yml  # CI/CD workflow
```

## Deployment

### Docker Image

Docker images are automatically built and pushed to GitHub Container Registry on release tags.

```bash
# Pull the latest image
docker pull ghcr.io/georg-nikola/docs-drift-landing:latest

# Or a specific version
docker pull ghcr.io/georg-nikola/docs-drift-landing:1.0.0
```

### Kubernetes with Helm

```bash
# Install directly
helm install docs-drift-landing ./helm/landing-page \
  --namespace default \
  --set ingress.hosts[0].host=docs-drift.your-domain.com \
  --set image.tag=1.0.0

# Or upgrade
helm upgrade docs-drift-landing ./helm/landing-page \
  --namespace default \
  --set image.tag=1.1.0
```

### ArgoCD GitOps

For production deployments, use ArgoCD with the Helm chart. See `helm/landing-page/README.md` for detailed instructions.

## Health Check

The landing page includes a health check endpoint:

```bash
curl http://localhost:8080/health
# Returns: OK
```

## Configuration

### Helm Values

Key configuration options in `helm/landing-page/values.yaml`:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of pods | `2` |
| `image.tag` | Docker image tag | `latest` |
| `resources.limits.memory` | Memory limit | `64Mi` |
| `resources.limits.cpu` | CPU limit | `100m` |
| `ingress.hosts[0].host` | Hostname | `docs-drift.example.com` |

### Security

The container runs with:
- Non-root user (UID 101)
- Read-only root filesystem
- No privilege escalation
- Dropped capabilities
- Seccomp profile enabled

## Creating a Release

1. Update version in `helm/landing-page/Chart.yaml`
2. Commit and push changes
3. Create a git tag:

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

4. GitHub Actions will automatically build and push the Docker image

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Related Projects

- [docs-drift](https://github.com/georg-nikola/docs-drift) - The CLI tool this landing page promotes
