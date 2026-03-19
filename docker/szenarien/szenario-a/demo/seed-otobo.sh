#!/usr/bin/env bash
# Szenario A – OTOBO: Queues, Dynamic Fields und Beispiel-Tickets anlegen
# OTOBO REST API: https://<host>/otobo/nph-genericinterface.pl/Webservice/GenericTicketConnectorREST
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

OTOBO_URL="https://tickets.${DOMAIN}"
OTOBO_API="${OTOBO_URL}/otobo/nph-genericinterface.pl/Webservice/GenericTicketConnectorREST"

otobo_ticket() {
  curl -fsS -X POST "${OTOBO_API}/Ticket" \
    -H "Content-Type: application/json" \
    -d "$1"
}

step "OTOBO – Warte auf Service"
wait_for_http "${OTOBO_URL}/otobo/index.pl" "OTOBO"

step "OTOBO – Beispiel-Risiko-Tickets anlegen"

DATA_DIR="${SCRIPT_DIR}/../../../demo/data"

python3 - "${DATA_DIR}/risks.json" "${OTOBO_API}" "${OTOBO_DEMO_USER}" "${OTOBO_DEMO_PASSWORD}" << 'PYEOF'
import sys, json, urllib.request, urllib.error

risks_file, api_url, user, password = sys.argv[1:]

with open(risks_file) as f:
    risks = json.load(f)

for risk in risks:
    payload = json.dumps({
        "UserLogin": user,
        "Password": password,
        "Ticket": {
            "Title":        risk["title"],
            "Queue":        risk["queue"],
            "State":        "new",
            "Priority":     "3 normal",
            "CustomerUser": "isms-demo"
        },
        "Article": {
            "Subject":     risk["title"],
            "Body":        (
                f"{risk['description']}\n\n"
                f"**Wahrscheinlichkeit**: {risk['wahrscheinlichkeit']}\n"
                f"**Schadenshöhe**: {risk['schadenshoehe']}\n"
                f"**Risikowert**: {risk['risikowert']}\n"
                f"**Bezugsobjekt**: {risk['bezugsobjekt_typ']} – {risk['bezugsobjekt_id']}\n\n"
                "**Geplante Maßnahmen**:\n" +
                "\n".join(f"- {m}" for m in risk["massnahmen"])
            ),
            "ContentType": "text/plain; charset=utf-8",
            "MimeType":    "text/plain",
            "Charset":     "utf-8"
        }
    }).encode()

    req = urllib.request.Request(
        f"{api_url}/Ticket",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST"
    )
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.load(resp)
            tid = result.get("TicketID", "?")
            print(f"  OK  Ticket #{tid}: {risk['title'][:60]}")
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        print(f"  WARN {risk['title'][:50]}: {e} – {body[:100]}")
PYEOF

step "OTOBO – Beispiel-Audit-Ticket anlegen"
otobo_ticket "{
  \"UserLogin\": \"${OTOBO_DEMO_USER}\",
  \"Password\": \"${OTOBO_DEMO_PASSWORD}\",
  \"Ticket\": {
    \"Title\": \"Interner Audit Q1 $(date +%Y)\",
    \"Queue\": \"Aufgaben::Audit\",
    \"State\": \"new\",
    \"Priority\": \"3 normal\"
  },
  \"Article\": {
    \"Subject\": \"Interner Audit Q1 $(date +%Y)\",
    \"Body\": \"Scope: Zugriffssteuerung (A.5.15), Backup (A.8.13), Incident Management (5.24-5.28)\n\nCheckliste:\n- [ ] Auditplan erstellt\n- [ ] Interviews durchgeführt\n- [ ] Findings dokumentiert\n- [ ] Bericht erstellt\n- [ ] Findings an Verantwortliche übergeben\",
    \"ContentType\": \"text/plain; charset=utf-8\",
    \"MimeType\": \"text/plain\",
    \"Charset\": \"utf-8\"
  }
}" && success "Audit-Ticket angelegt" || warn "Audit-Ticket konnte nicht angelegt werden"

step "OTOBO – Beispiel-Schulungsticket anlegen"
otobo_ticket "{
  \"UserLogin\": \"${OTOBO_DEMO_USER}\",
  \"Password\": \"${OTOBO_DEMO_PASSWORD}\",
  \"Ticket\": {
    \"Title\": \"Security Awareness Schulung $(date +%Y)\",
    \"Queue\": \"Aufgaben::Schulung\",
    \"State\": \"new\",
    \"Priority\": \"3 normal\"
  },
  \"Article\": {
    \"Subject\": \"Security Awareness Schulung $(date +%Y)\",
    \"Body\": \"Alle Mitarbeitenden absolvieren die jährliche Security Awareness Schulung.\n\nThemen: Phishing, Passwörter, Social Engineering, Meldewege\n\nNachweis: Teilnehmerliste als Anhang\",
    \"ContentType\": \"text/plain; charset=utf-8\",
    \"MimeType\": \"text/plain\",
    \"Charset\": \"utf-8\"
  }
}" && success "Schulungs-Ticket angelegt" || warn "Schulungs-Ticket konnte nicht angelegt werden"

success "OTOBO Demo-Daten vollständig."
