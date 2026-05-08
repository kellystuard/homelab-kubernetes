#!/usr/bin/env bash
set -euo pipefail

echo "==> Validating cloudflared environment variables..."

if [ -z "${k8s_public_hostname:-}" ]; then
  echo "ERROR: k8s_public_hostname is not set"
  exit 1
fi

if [ -z "${service_token_client_id:-}" ]; then
  echo "ERROR: service_token_client_id is not set"
  exit 1
fi

if [ -z "${service_token_client_secret:-}" ]; then
  echo "ERROR: service_token_client_secret is not set"
  exit 1
fi