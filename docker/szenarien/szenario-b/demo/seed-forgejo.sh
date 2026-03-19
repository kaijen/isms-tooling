#!/usr/bin/env bash
# Szenario B – Forgejo (identisch mit A, minimaler Repo-Satz)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

FORGEJO_URL="https://git.${DOMAIN}"
DATA_DIR="${SCRIPT_DIR}/../../../demo/data"

step "Forgejo – Warte auf Service"
wait_for_http "${FORGEJO_URL}" "Forgejo"

step "Forgejo – Organisation und Repositories anlegen"
forgejo_create_org "isms"
forgejo_create_repo "isms" "isms-policies" "ISMS-Richtlinien"
forgejo_create_repo "isms" "isms-docs"     "ISMS-Dokumentationssite"

step "Forgejo – Richtlinien einchecken"
for file in "${DATA_DIR}/policies/"*.md; do
  filename="$(basename "${file}")"
  content_b64="$(base64 -w 0 "${file}")"
  forgejo_create_file "isms" "isms-policies" \
    "richtlinien/${filename}" "docs: add ${filename}" "${content_b64}"
  success "Richtlinie: ${filename}"
done

success "Forgejo Demo-Daten vollständig."
