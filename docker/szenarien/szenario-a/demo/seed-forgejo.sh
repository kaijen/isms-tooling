#!/usr/bin/env bash
# Szenario A – Forgejo: Org, Repos und Beispiel-Richtlinien anlegen
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

FORGEJO_URL="https://git.${DOMAIN}"
DATA_DIR="${SCRIPT_DIR}/../../../demo/data"

step "Forgejo – Warte auf Service"
wait_for_http "${FORGEJO_URL}" "Forgejo"

step "Forgejo – Organisation anlegen"
forgejo_create_org "isms"

step "Forgejo – Repositories anlegen"
forgejo_create_repo "isms" "isms-policies" "ISMS-Richtlinien und Verfahrensanweisungen"
forgejo_create_repo "isms" "isms-docs"     "ISMS-Dokumentationssite (MkDocs)"
forgejo_create_repo "isms" "isms-config"   "ISMS-Infrastruktur-Konfiguration"

step "Forgejo – Beispiel-Richtlinien einchecken"

for file in "${DATA_DIR}/policies/"*.md; do
  filename="$(basename "${file}")"
  content_b64="$(base64 -w 0 "${file}")"
  forgejo_create_file "isms" "isms-policies" \
    "richtlinien/${filename}" \
    "docs: add ${filename}" \
    "${content_b64}"
  success "Richtlinie eingecheckt: ${filename}"
done

step "Forgejo – Branch-Schutz für main aktivieren"
forgejo_api POST "/repos/isms/isms-policies/branch_protections" -d '{
  "branch_name": "main",
  "enable_push": true,
  "enable_push_whitelist": true,
  "required_approvals": 1,
  "enable_approvals_whitelist": false,
  "block_on_official_review_requests": true
}' || warn "Branch-Schutz konnte nicht gesetzt werden (ggf. bereits aktiv)"

success "Forgejo Demo-Daten vollständig."
