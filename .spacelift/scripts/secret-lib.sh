#!/usr/bin/env bash
set -euo pipefail

require_bin() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[error] Required binary not found: $1" >&2
    exit 1
  fi
}

random_value() {
  local charset="$1"
  local length="$2"

  case "$charset" in
    alnum)
      tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$length"
      ;;
    hex)
      tr -dc 'a-f0-9' </dev/urandom | head -c "$length"
      ;;
    *)
      echo "[error] Unsupported charset: $charset" >&2
      exit 1
      ;;
  esac
}

ensure_namespace() {
  local namespace="$1"
  if ! kubectl get namespace "$namespace" >/dev/null 2>&1; then
    echo "[error] Namespace not found: $namespace" >&2
    exit 1
  fi
}

ensure_secret() {
  local namespace="$1"
  local secret_name="$2"
  shift 2

  if kubectl -n "$namespace" get secret "$secret_name" >/dev/null 2>&1; then
    echo "[ok] Secret exists: $namespace/$secret_name"
    return 0
  fi

  local args=()
  while [ "$#" -gt 0 ]; do
    local key="$1"
    local length="$2"
    local charset="$3"
    shift 3

    local value
    value="$(random_value "$charset" "$length")"
    args+=("--from-literal=${key}=${value}")
  done

  kubectl -n "$namespace" create secret generic "$secret_name" "${args[@]}" >/dev/null
  echo "[created] Secret created: $namespace/$secret_name"
}
