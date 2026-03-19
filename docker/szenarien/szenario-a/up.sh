#!/usr/bin/env bash
# Szenario A – Greenfield, NIS2-betroffen
# Startet den vollständigen Stack: Forgejo + OTOBO + DataGerry + BookStack + Wekan + Docs
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_DIR="${SCRIPT_DIR}/../../compose"
ENV_FILE="${SCRIPT_DIR}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Fehler: ${ENV_FILE} nicht gefunden."
  echo "Kopiere .env.example nach .env und passe die Werte an."
  exit 1
fi

docker compose \
  --env-file "${ENV_FILE}" \
  -f "${COMPOSE_DIR}/traefik.yml" \
  -f "${COMPOSE_DIR}/forgejo.yml" \
  -f "${COMPOSE_DIR}/otobo.yml" \
  -f "${COMPOSE_DIR}/datagerry.yml" \
  -f "${COMPOSE_DIR}/bookstack.yml" \
  -f "${COMPOSE_DIR}/wekan.yml" \
  -f "${COMPOSE_DIR}/docs.yml" \
  -f "${SCRIPT_DIR}/override.yml" \
  "$@"
