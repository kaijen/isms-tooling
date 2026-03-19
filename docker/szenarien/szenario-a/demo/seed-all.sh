#!/usr/bin/env bash
# Szenario A – Alle Demo-Daten erzeugen
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║   ISMS Demo – Szenario A (Greenfield NIS2)  ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Reihenfolge: Infrastruktur zuerst, dann abhängige Dienste
STEPS=(
  "seed-forgejo.sh:Forgejo (VCS)"
  "seed-datagerry.sh:DataGerry (Assets)"
  "seed-otobo.sh:OTOBO (Tickets)"
  "seed-bookstack.sh:BookStack (Wiki)"
  "seed-wekan.sh:Wekan (Kanban)"
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
echo "═══════════════════════════════════════════════"
if [[ ${#FAILED[@]} -eq 0 ]]; then
  success "Alle Demo-Daten erfolgreich erzeugt."
else
  warn "Abgeschlossen mit Fehlern in: ${FAILED[*]}"
fi
echo ""
echo "Zugänge:"
echo "  Forgejo:    https://git.${DOMAIN}"
echo "  OTOBO:      https://tickets.${DOMAIN}"
echo "  DataGerry:  https://assets.${DOMAIN}"
echo "  BookStack:  https://wiki.${DOMAIN}"
echo "  Wekan:      https://board.${DOMAIN}"
echo "  Docs:       https://docs.${DOMAIN}"
echo ""
