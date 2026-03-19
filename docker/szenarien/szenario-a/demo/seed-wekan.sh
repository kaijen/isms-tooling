#!/usr/bin/env bash
# Szenario A – Wekan: Demo-Board für ISMS-Projektsteuerung anlegen
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

WEKAN_URL="https://board.${DOMAIN}"

step "Wekan – Warte auf Service"
wait_for_http "${WEKAN_URL}" "Wekan"

step "Wekan – Login"
wekan_login

step "Wekan – Board: ISMS-Einführung"
BOARD_ID=$(wekan_api POST "/api/boards" -d "{
  \"title\": \"ISMS-Einführung\",
  \"permission\": \"private\",
  \"color\": \"belize\"
}" | python3 -c "import sys,json; print(json.load(sys.stdin)['_id'])")
success "Board angelegt (ID: ${BOARD_ID})"

step "Wekan – Listen (Spalten) anlegen"
declare -A LIST_IDS
for list in "Backlog" "In Planung" "In Umsetzung" "Review" "Abgeschlossen"; do
  LID=$(wekan_api POST "/api/boards/${BOARD_ID}/lists" \
    -d "{\"title\": \"${list}\"}" \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['_id'])")
  LIST_IDS["${list}"]="${LID}"
  success "Liste angelegt: ${list}"
done

step "Wekan – Beispiel-Karten anlegen"

# Backlog
for card in \
  "Scope und Geltungsbereich definieren" \
  "Asset-Inventar aufbauen (DataGerry)" \
  "Lieferantenliste erstellen" \
  "Gap-Analyse gegen ISO 27001:2022"; do
  wekan_api POST "/api/boards/${BOARD_ID}/lists/${LIST_IDS["Backlog"]}/cards" \
    -d "{\"title\": \"${card}\", \"authorId\": \"${WEKAN_USER_ID}\"}" > /dev/null
  success "Karte: ${card}"
done

# In Planung
for card in \
  "Risikobeurteilungsmethodik festlegen" \
  "OTOBO Queue-Struktur konfigurieren"; do
  wekan_api POST "/api/boards/${BOARD_ID}/lists/${LIST_IDS["In Planung"]}/cards" \
    -d "{\"title\": \"${card}\", \"authorId\": \"${WEKAN_USER_ID}\"}" > /dev/null
  success "Karte: ${card}"
done

# In Umsetzung
for card in \
  "Informationssicherheitsrichtlinie erstellen" \
  "Erstes Risikoregister befüllen"; do
  wekan_api POST "/api/boards/${BOARD_ID}/lists/${LIST_IDS["In Umsetzung"]}/cards" \
    -d "{\"title\": \"${card}\", \"authorId\": \"${WEKAN_USER_ID}\"}" > /dev/null
  success "Karte: ${card}"
done

step "Wekan – Board: Managementbewertung $(date +%Y)"
MB_BOARD=$(wekan_api POST "/api/boards" -d "{
  \"title\": \"Managementbewertung $(date +%Y)\",
  \"permission\": \"private\",
  \"color\": \"nephritis\"
}" | python3 -c "import sys,json; print(json.load(sys.stdin)['_id'])")

for list in "Vorbereitung" "Tagesordnung" "Ergebnisse" "Maßnahmen"; do
  wekan_api POST "/api/boards/${MB_BOARD}/lists" -d "{\"title\": \"${list}\"}" > /dev/null
done
success "Board Managementbewertung angelegt"

success "Wekan Demo-Daten vollständig."
