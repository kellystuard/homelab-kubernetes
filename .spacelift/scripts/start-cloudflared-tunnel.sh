#!/usr/bin/env bash
set -euo pipefail

CLOUDFLARED_BIN="${CLOUDFLARED_BIN:-/tmp/cloudflared}"
CF_TUNNEL_URL="${CF_TUNNEL_URL:-localhost:6443}"

echo "==> Starting cloudflared tunnel: ${k8s_public_hostname} -> ${CF_TUNNEL_URL}"
"${CLOUDFLARED_BIN}" access tcp \
  --hostname "${k8s_public_hostname}" \
  --url "${CF_TUNNEL_URL}" \
  --service-token-id "${service_token_client_id}" \
  --service-token-secret "${service_token_client_secret}" \
  </dev/null >/tmp/cloudflared.log 2>&1 &

CLOUDFLARED_PID=$!
echo "${CLOUDFLARED_PID}" > /dev/shm/cloudflared.pid
echo "cloudflared PID recorded in /dev/shm/cloudflared.pid"

# Give the process a moment to start and verify it did not exit immediately.
sleep 2
if kill -0 "${CLOUDFLARED_PID}" 2>/dev/null; then
  echo "cloudflared tunnel started (PID ${CLOUDFLARED_PID})"
else
  echo "ERROR: cloudflared tunnel exited unexpectedly"
  exit 1
fi