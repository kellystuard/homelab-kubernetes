# Devspace Setup

This file documents the Devspace and Dev Container workflow for this repository.

## Prerequisites

- Docker or Podman
- Kubernetes access (`kubectl` context configured)
- Devspace CLI

## Install Devspace

### Windows (Chocolatey)

```powershell
choco install devspace
```

### Linux

```bash
curl -s -L "https://github.com/loft-sh/devspace/releases/latest/download/devspace-linux-amd64" -o /tmp/devspace
sudo install -c -m 0755 /tmp/devspace /usr/local/bin/devspace
```

### macOS

```bash
curl -s -L "https://github.com/loft-sh/devspace/releases/latest/download/devspace-darwin-amd64" -o /tmp/devspace
sudo install -c -m 0755 /tmp/devspace /usr/local/bin/devspace
```

## Using Devspace

Run these from the repository root:

```bash
devspace run validate
devspace run diff
devspace run deploy
devspace run status
```

Log streaming:

```bash
devspace run logs <namespace>
```

Cleanup:

```bash
devspace run clean
```

## Dev Container / Codespace

1. Open repository in VS Code
2. Use Reopen in Container
3. Wait for first-time build to finish
4. Run `devspace run <command>` in terminal

The Dev Container is defined in `.devcontainer/devcontainer.json` and uses `.devcontainer/post-create.sh` for bootstrapping.

## What Gets Installed in the Dev Container

- `kubectl`, `helm`, and Docker-in-Docker feature set
- Devspace CLI (installed by post-create script if missing)
- Utilities: `jq`, `vim`, `curl`, `git`, `openssh-client`
- Kubernetes/YAML VS Code extensions

## Environment Variables

Optional registry credentials used by `devspace.yaml`:

```bash
export REGISTRY_USERNAME=myuser
export REGISTRY_PASSWORD=mypass
```

## Devspace Commands Defined in This Repo

`devspace.yaml` provides:

- `validate`: dry-run all manifests
- `deploy`: apply all manifests
- `diff`: show manifest changes
- `status`: cluster + workloads overview
- `logs`: tail logs by namespace
- `clean`: delete applied resources

## Notes

- Codespaces generally cannot reach private/local clusters unless network access is explicitly provided.
- For local cluster management, local Devspace + local kubeconfig is usually the most reliable workflow.
