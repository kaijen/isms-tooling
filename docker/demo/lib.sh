#!/usr/bin/env bash
# Gemeinsame Hilfsfunktionen für Demo-Seed-Skripte

set -euo pipefail

# --- Ausgabe ---

info()    { echo -e "\033[0;34m[INFO]\033[0m  $*"; }
success() { echo -e "\033[0;32m[OK]\033[0m    $*"; }
warn()    { echo -e "\033[0;33m[WARN]\033[0m  $*"; }
error()   { echo -e "\033[0;31m[ERR]\033[0m   $*" >&2; }
step()    { echo -e "\n\033[1;37m── $* \033[0m"; }

# --- Service-Verfügbarkeit ---

wait_for_http() {
  local url="$1"
  local label="${2:-$url}"
  local max_attempts="${3:-30}"
  local attempt=0
  info "Warte auf ${label}..."
  until curl -fsS --max-time 3 "${url}" > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [[ ${attempt} -ge ${max_attempts} ]]; then
      error "${label} nach ${max_attempts} Versuchen nicht erreichbar."
      return 1
    fi
    sleep 5
  done
  success "${label} erreichbar."
}

# --- Forgejo API ---

forgejo_api() {
  local method="$1"; local path="$2"; shift 2
  curl -fsS -X "${method}" \
    -H "Authorization: token ${FORGEJO_TOKEN}" \
    -H "Content-Type: application/json" \
    "${FORGEJO_URL}/api/v1${path}" "$@"
}

forgejo_create_org() {
  local org="$1"
  forgejo_api POST /orgs -d "{\"username\":\"${org}\",\"visibility\":\"private\"}" \
    || warn "Org ${org} existiert möglicherweise bereits."
}

forgejo_create_repo() {
  local org="$1"; local repo="$2"; local description="$3"
  forgejo_api POST "/orgs/${org}/repos" \
    -d "{\"name\":\"${repo}\",\"description\":\"${description}\",\"private\":true,\"auto_init\":true,\"default_branch\":\"main\"}" \
    || warn "Repo ${org}/${repo} existiert möglicherweise bereits."
}

forgejo_create_file() {
  local owner="$1"; local repo="$2"; local path="$3"
  local message="$4"; local content_b64="$5"
  forgejo_api POST "/repos/${owner}/${repo}/contents/${path}" \
    -d "{\"message\":\"${message}\",\"content\":\"${content_b64}\"}" \
    || warn "Datei ${path} in ${owner}/${repo} existiert möglicherweise bereits."
}

# --- DataGerry API ---

datagerry_api() {
  local method="$1"; local path="$2"; shift 2
  curl -fsS -X "${method}" \
    -H "Authorization: Bearer ${DATAGERRY_TOKEN}" \
    -H "Content-Type: application/json" \
    "${DATAGERRY_URL}${path}" "$@"
}

# --- Plane API ---

plane_api() {
  local method="$1"; local path="$2"; shift 2
  curl -fsS -X "${method}" \
    -H "X-API-Key: ${PLANE_TOKEN}" \
    -H "Content-Type: application/json" \
    "${PLANE_URL}/api/v1${path}" "$@"
}

# --- BookStack API ---

bookstack_api() {
  local method="$1"; local path="$2"; shift 2
  curl -fsS -X "${method}" \
    -H "Authorization: Token ${BOOKSTACK_TOKEN_ID}:${BOOKSTACK_TOKEN_SECRET}" \
    -H "Content-Type: application/json" \
    "${BOOKSTACK_URL}/api${path}" "$@"
}

# --- Wekan API ---

wekan_login() {
  WEKAN_AUTH=$(curl -fsS -X POST "${WEKAN_URL}/users/login" \
    -d "username=${WEKAN_USER}&password=${WEKAN_PASSWORD}" \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['token']+'|'+d['id'])")
  WEKAN_TOKEN="${WEKAN_AUTH%%|*}"
  WEKAN_USER_ID="${WEKAN_AUTH##*|}"
}

wekan_api() {
  local method="$1"; local path="$2"; shift 2
  curl -fsS -X "${method}" \
    -H "Authorization: Bearer ${WEKAN_TOKEN}" \
    -H "Content-Type: application/json" \
    "${WEKAN_URL}${path}" "$@"
}
