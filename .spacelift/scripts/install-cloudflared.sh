#!/usr/bin/env bash
set -euo pipefail

CLOUDFLARED_VERSION="2026.3.0"
CLOUDFLARED_SHA256="4a9e50e6d6d798e90fcd01933151a90bf7edd99a0a55c28ad18f2e16263a5c30"
CLOUDFLARED_BIN="${CLOUDFLARED_BIN:-/tmp/cloudflared}"
CLOUDFLARED_URL="https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-amd64"
CLOUDFLARED_CHECKSUM_FILE="$(mktemp)" \
  || { echo "ERROR: failed to create temporary file"; exit 1; }

echo "==> Installing cloudflared ${CLOUDFLARED_VERSION}..."
curl -fsSL --output "${CLOUDFLARED_BIN}" "${CLOUDFLARED_URL}" \
  || { echo "ERROR: cloudflared download failed"; exit 1; }
printf "%s  %s\n" "${CLOUDFLARED_SHA256}" "${CLOUDFLARED_BIN}" > "${CLOUDFLARED_CHECKSUM_FILE}"
sha256sum -c -s "${CLOUDFLARED_CHECKSUM_FILE}" \
  || { echo "ERROR: cloudflared checksum verification failed"; exit 1; }
rm -f "${CLOUDFLARED_CHECKSUM_FILE}"
echo "cloudflared checksum verified"
chmod +x "${CLOUDFLARED_BIN}"

if "${CLOUDFLARED_BIN}" --version; then
  echo "cloudflared installed successfully"
else
  echo "ERROR: cloudflared installation failed"
  exit 1
fi