#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/secret-lib.sh"

PAPERLESS_NAMESPACE="${PAPERLESS_NAMESPACE:-paperless}"

main() {
  require_bin kubectl
  ensure_namespace "$PAPERLESS_NAMESPACE"

  ensure_secret "$PAPERLESS_NAMESPACE" "postgres-auth" \
    "POSTGRES_PASSWORD" "40" "alnum"

  ensure_secret "$PAPERLESS_NAMESPACE" "redis-auth" \
    "REDIS_PASSWORD" "40" "alnum"

  ensure_secret "$PAPERLESS_NAMESPACE" "paperless-core" \
    "PAPERLESS_SECRET_KEY" "40" "alnum" \
    "PAPERLESS_ADMIN_PASSWORD" "40" "alnum"

  ensure_secret "$PAPERLESS_NAMESPACE" "paperless-ai-auth" \
    "PAPERLESS_TOKEN" "40" "hex" \
    "API_KEY" "40" "alnum" \
    "JWT_SECRET" "64" "alnum"

  ensure_secret "$PAPERLESS_NAMESPACE" "paperless-smb-auth" \
    "SMB_PASSWORD" "40" "alnum"
}

main
