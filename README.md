# homelab

Kubernetes manifests and automation scripts for a self-hosted homelab stack.

## Overview

This repository manages infrastructure and services deployed to Kubernetes, including:

- Storage classes for local-path backed volumes
- LLM workloads
- Paperless-ngx workloads and related integrations
- SMB sharing for scanner/file ingestion flows
- Spacelift helper scripts for secret/config workflows

## Repository Structure

- `host.yaml`: Cluster-level storage classes (`spinning`, `mirrored`, `fast`)
- `llm.yaml`: LLM-related workloads/services
- `paperless.yaml`: Base Paperless deployment resources
- `paperless-llm.yaml`: Paperless + LLM integration resources
- `paperless-smb.yaml`: Paperless + SMB integration resources
- `server-plan.yaml`: Server/workload planning notes/manifests
- `.spacelift/scripts/`: Spacelift shell helpers (for CI/CD and secrets workflows)
- `devspace.yaml`: Devspace commands for validate/deploy/diff/status/logs/clean

## Requirements

- Kubernetes cluster reachable from your terminal
- `kubectl` configured with the correct context
- For local development workflow: Devspace CLI
- For containerized IDE workflow: VS Code Dev Containers or GitHub Codespaces

## Quick Start

### 1) Validate manifests

```bash
kubectl apply -f host.yaml --dry-run=client
kubectl apply -f llm.yaml --dry-run=client
kubectl apply -f paperless.yaml --dry-run=client
kubectl apply -f paperless-llm.yaml --dry-run=client
kubectl apply -f paperless-smb.yaml --dry-run=client
```

### 2) Deploy manifests

```bash
kubectl apply -f host.yaml
kubectl apply -f llm.yaml
kubectl apply -f paperless.yaml
kubectl apply -f paperless-llm.yaml
kubectl apply -f paperless-smb.yaml
```

### 3) Verify cluster resources

```bash
kubectl get nodes -o wide
kubectl get pv
kubectl get storageclasses
kubectl get pods -A
```

## Dev Environment

For Devspace and Dev Container usage, see:

- `DEVSPACE_SETUP.md`

## Operational Notes

These notes are captured from prior work on this repository and are important for stable Paperless behavior:

- If a Service is named `paperless`, injected env var `PAPERLESS_PORT` can break startup in some images. Set `enableServiceLinks: false` in the Paperless pod spec.
- If `PAPERLESS_REDIS` includes a password, Redis must enforce auth (for example `--requirepass`) and probes should authenticate.
- `paperless-smb` with `dperson/samba` may reject older scanners due to SMB/NTLM defaults (SMB2 minimum, NTLMv2-only). Relax compatibility settings only if required.

## Common Operations

### Show what would change before apply

```bash
kubectl diff -f host.yaml || true
kubectl diff -f llm.yaml || true
kubectl diff -f paperless.yaml || true
kubectl diff -f paperless-llm.yaml || true
kubectl diff -f paperless-smb.yaml || true
```

### Remove deployed resources

```bash
kubectl delete -f host.yaml
kubectl delete -f llm.yaml
kubectl delete -f paperless.yaml
kubectl delete -f paperless-llm.yaml
kubectl delete -f paperless-smb.yaml
```

## Troubleshooting

- `kubectl` command fails:
  - Check context: `kubectl config current-context`
  - Check connectivity: `kubectl cluster-info`
- PVCs pending:
  - Confirm storage classes exist and node paths are available (`/mnt/spinning`, `/mnt/mirrored`, `/mnt/fast`)
- Workloads not starting:
  - Inspect events: `kubectl get events -A --sort-by=.lastTimestamp`
  - Check logs: `kubectl logs -n <namespace> <pod-name> --all-containers`

## Notes on Secrets and CI/CD

Spacelift scripts live in `.spacelift/scripts/`. Keep secret material out of git and inject via your CI/CD secret store.

## License

No explicit license file is currently present in this repository.
