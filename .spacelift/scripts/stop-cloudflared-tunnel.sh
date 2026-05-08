#!/usr/bin/env bash
set -euo pipefail

if [ -f /dev/shm/cloudflared.pid ]; then
  CLOUDFLARED_PID=$(cat /dev/shm/cloudflared.pid)
  echo "==> Stopping cloudflared tunnel (PID ${CLOUDFLARED_PID})..."

  if kill "${CLOUDFLARED_PID}" 2>/dev/null; then
    echo "SIGTERM sent to cloudflared; waiting up to 10 seconds..."

    # Wait with a timeout: check every second for up to 10 seconds.
    for i in $(seq 1 10); do
      if ! kill -0 "${CLOUDFLARED_PID}" 2>/dev/null; then
        echo "cloudflared tunnel stopped (after ${i}s)"
        break
      fi
      sleep 1
    done

    # Force-kill if still running after grace period.
    if kill -0 "${CLOUDFLARED_PID}" 2>/dev/null; then
      echo "WARNING: cloudflared did not exit gracefully; sending SIGKILL..."
      kill -9 "${CLOUDFLARED_PID}" 2>/dev/null || true
      wait "${CLOUDFLARED_PID}" 2>/dev/null || true
      echo "cloudflared tunnel force-stopped"
    fi
  else
    echo "cloudflared process already exited"
  fi

  rm -f /dev/shm/cloudflared.pid
else
  echo "No cloudflared PID file found at /dev/shm/cloudflared.pid; skipping tunnel teardown"
fi