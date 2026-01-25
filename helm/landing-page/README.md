# docs-drift-landing Helm Chart

Helm chart for deploying the docs-drift landing page to Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Traefik IngressController (for IngressRoute)

## Installation

### From Local Chart

```bash
helm install docs-drift-landing ./helm/landing-page \
  --namespace default \
  --set ingress.hosts[0].host=docs-drift.example.com
```

### From GitHub Repository (via ArgoCD)

Create an ArgoCD Application that references this chart:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: docs-drift-landing
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/georg-nikola/docs-drift-landing
    targetRevision: main
    path: helm/landing-page
    helm:
      values: |
        image:
          tag: "1.0.0"
        ingress:
          hosts:
            - host: docs-drift.your-domain.com
              paths:
                - path: /
                  pathType: Prefix
  destination:
    server: https://kubernetes.default.svc
    namespace: default
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `2` |
| `image.registry` | Container registry | `ghcr.io` |
| `image.repository` | Container image repository | `georg-nikola/docs-drift-landing` |
| `image.tag` | Container image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `Always` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `service.targetPort` | Container port | `8080` |
| `ingress.enabled` | Enable Traefik IngressRoute | `true` |
| `ingress.className` | Ingress class | `traefik` |
| `ingress.hosts` | List of ingress hosts | See values.yaml |
| `resources.requests.cpu` | CPU request | `50m` |
| `resources.requests.memory` | Memory request | `32Mi` |
| `resources.limits.cpu` | CPU limit | `100m` |
| `resources.limits.memory` | Memory limit | `64Mi` |
| `tolerations` | Node tolerations | Control-plane toleration |

## Security Features

- Runs as non-root user (UID 101)
- Read-only root filesystem
- No privilege escalation
- Drops all capabilities
- Seccomp profile enabled

## Health Checks

- **Liveness probe**: `GET /health` on port 8080
- **Readiness probe**: `GET /health` on port 8080

## Upgrading

```bash
helm upgrade docs-drift-landing ./helm/landing-page \
  --namespace default \
  --set image.tag=1.1.0
```

## Uninstalling

```bash
helm uninstall docs-drift-landing --namespace default
```
