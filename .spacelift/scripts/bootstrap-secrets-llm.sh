#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/secret-lib.sh"

LLM_NAMESPACE="${LLM_NAMESPACE:-llm}"

main() {
  require_bin kubectl
  ensure_namespace "$LLM_NAMESPACE"

  ensure_secret "$LLM_NAMESPACE" "open-webui-env" \
    "WEBUI_SECRET_KEY" "40" "alnum"
}

main
