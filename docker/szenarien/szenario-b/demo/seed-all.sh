#!/usr/bin/env bash
# Szenario B – Alle Demo-Daten erzeugen
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║   ISMS Demo – Szenario B (Supplier KMU)  ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

STEPS=(
  "seed-forgejo.sh:Forgejo (VCS)"
  "seed-datagerry.sh:DataGerry (Assets)"
  "seed-plane.sh:Plane (Tickets)"
)

FAILED=()

for entry in "${STEPS[@]}"; do
  script="${entry%%:*}"
  label="${entry##*:}"
  echo ""
  info "Starte: ${label}"
  if bash "${SCRIPT_DIR}/${script}"; then
    success "${label} abgeschlossen"
  else
    warn "${label} fehlgeschlagen – weiter mit nächstem Schritt"
    FAILED+=("${label}")
  fi
done

echo ""
echo "═══════════════════════════════════════════"
if [[ ${#FAILED[@]} -eq 0 ]]; then
  success "Alle Demo-Daten erfolgreich erzeugt."
else
  warn "Abgeschlossen mit Fehlern in: ${FAILED[*]}"
fi
echo ""
echo "Zugänge:"
echo "  Forgejo:    https://git.${DOMAIN}"
echo "  Plane:      https://plane.${DOMAIN}"
echo "  DataGerry:  https://assets.${DOMAIN}"
echo "  Docs:       https://docs.${DOMAIN}"
echo ""
