#!/usr/bin/env bash
# Szenario A – BookStack: Bücherstruktur und Beispielinhalte anlegen
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

BOOKSTACK_URL="https://wiki.${DOMAIN}"

step "BookStack – Warte auf Service"
wait_for_http "${BOOKSTACK_URL}" "BookStack"

step "BookStack – Buch: ISMS-Handbuch"
BOOK_ID=$(bookstack_api POST /books -d '{
  "name": "ISMS-Handbuch",
  "description": "Zentrales Handbuch für das Informationssicherheits-Managementsystem"
}' | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
success "Buch angelegt (ID: ${BOOK_ID})"

step "BookStack – Kapitel anlegen"
for chapter in \
  "Grundlagen und Scope|Geltungsbereich, Schutzziele und normative Grundlagen" \
  "Rollen und Verantwortlichkeiten|CISO, ISB, IT-Leitung, Prozessverantwortliche" \
  "Risikomanagement|Bewertungsschema, Risikoregister, Behandlungsprozess" \
  "Maßnahmen und Controls|Implementierte Controls nach ISO 27001 Annex A" \
  "Audit und Bewertung|Interne Audits, Managementbewertung, KVP"; do
  name="${chapter%%|*}"
  desc="${chapter##*|}"
  CH_ID=$(bookstack_api POST /chapters -d \
    "{\"book_id\": ${BOOK_ID}, \"name\": \"${name}\", \"description\": \"${desc}\"}" \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
  success "Kapitel angelegt: ${name} (ID: ${CH_ID})"
done

step "BookStack – Buch: Awareness"
AWARE_ID=$(bookstack_api POST /books -d '{
  "name": "Awareness & Schulung",
  "description": "Schulungsmaterialien und Awareness-Inhalte für Mitarbeitende"
}' | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")

bookstack_api POST /pages -d "{
  \"book_id\": ${AWARE_ID},
  \"name\": \"Phishing erkennen und melden\",
  \"markdown\": \"## Was ist Phishing?\n\nPhishing-E-Mails täuschen eine vertrauenswürdige Quelle vor, um Zugangsdaten oder andere sensible Informationen zu stehlen.\n\n## Erkennungsmerkmale\n\n- Unerwartete Aufforderungen zur Passworteingabe\n- Absenderadresse weicht von bekannter Domain ab\n- Dringlichkeit und Drohungen\n- Links zeigen auf fremde Domains (Mauszeiger drüberhalten!)\n\n## Was tun?\n\n1. Nicht klicken\n2. Vorfall an IT-Sicherheit melden: security@example.com\n3. E-Mail als Spam markieren und löschen\"
}" > /dev/null && success "Awareness-Seite angelegt: Phishing"

success "BookStack Demo-Daten vollständig."
