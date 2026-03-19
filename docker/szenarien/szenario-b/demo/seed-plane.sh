#!/usr/bin/env bash
# Szenario B – Plane: Workspace, Projekte, Labels, Issues anlegen
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

PLANE_URL="https://plane.${DOMAIN}"
DATA_DIR="${SCRIPT_DIR}/../../../demo/data"

step "Plane – Warte auf Service"
wait_for_http "${PLANE_URL}" "Plane"

step "Plane – Workspace-Slug ermitteln"
WORKSPACE_SLUG=$(plane_api GET /workspaces/ \
  | python3 -c "import sys,json; ws=json.load(sys.stdin)['results']; print(ws[0]['slug'])")
info "Workspace: ${WORKSPACE_SLUG}"

step "Plane – Projekt: Risikomanagement"
RISK_PROJECT=$(plane_api POST "/workspaces/${WORKSPACE_SLUG}/projects/" -d '{
  "name": "Risikomanagement",
  "identifier": "RISK",
  "description": "Risikoregister und Behandlungsmaßnahmen",
  "network": 0
}' | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
success "Projekt Risikomanagement (ID: ${RISK_PROJECT})"

step "Plane – Status-Labels anlegen"
for label in \
  "status:identifiziert:#6B7280" \
  "status:bewertet:#F59E0B" \
  "status:behandlung_geplant:#3B82F6" \
  "status:in_behandlung:#8B5CF6" \
  "status:akzeptiert:#10B981" \
  "status:geschlossen:#6B7280"; do
  name="${label%%:*:*}"
  # extract name and color
  IFS=':' read -r lname lcolor <<< "${label#*:}"
  plane_api POST "/workspaces/${WORKSPACE_SLUG}/projects/${RISK_PROJECT}/labels/" \
    -d "{\"name\": \"status:${lname}\", \"color\": \"${lcolor}\"}" > /dev/null \
    || warn "Label status:${lname} existiert möglicherweise bereits"
  success "Label: status:${lname}"
done

step "Plane – Risiko-Issues anlegen"
python3 - "${DATA_DIR}/risks.json" "${PLANE_URL}" "${PLANE_TOKEN}" \
  "${WORKSPACE_SLUG}" "${RISK_PROJECT}" << 'PYEOF'
import sys, json, urllib.request, urllib.error

risks_file, base_url, token, ws, project = sys.argv[1:]

with open(risks_file) as f:
    risks = json.load(f)

for risk in risks:
    desc = (
        f"{risk['description']}\n\n"
        f"**Wahrscheinlichkeit**: {risk['wahrscheinlichkeit']}\n"
        f"**Schadenshöhe**: {risk['schadenshoehe']}\n"
        f"**Risikowert**: {risk['risikowert']}\n"
        f"**Bezugsobjekt**: {risk['bezugsobjekt_typ']} – {risk['bezugsobjekt_id']}\n\n"
        "**Geplante Maßnahmen**:\n" +
        "\n".join(f"- {m}" for m in risk["massnahmen"])
    )
    payload = json.dumps({
        "name": risk["title"],
        "description_html": f"<p>{desc.replace(chr(10), '</p><p>')}</p>",
        "priority": "high" if int(risk["risikowert"]) >= 9 else "medium"
    }).encode()

    req = urllib.request.Request(
        f"{base_url}/api/v1/workspaces/{ws}/projects/{project}/issues/",
        data=payload,
        headers={"X-API-Key": token, "Content-Type": "application/json"},
        method="POST"
    )
    try:
        with urllib.request.urlopen(req) as resp:
            issue = json.load(resp)
            print(f"  OK  Issue: {risk['title'][:60]}")
    except urllib.error.HTTPError as e:
        print(f"  WARN {risk['title'][:50]}: {e}")
PYEOF

step "Plane – Projekt: ISMS-Aufgaben"
TASK_PROJECT=$(plane_api POST "/workspaces/${WORKSPACE_SLUG}/projects/" -d '{
  "name": "ISMS-Aufgaben",
  "identifier": "ISMS",
  "description": "Wiederkehrende ISMS-Aufgaben: Audits, Schulungen, Lieferantenbewertungen",
  "network": 0
}' | python3 -c "import sys,json; print(json.load(sys.stdin)['id'])")
success "Projekt ISMS-Aufgaben (ID: ${TASK_PROJECT})"

step "Plane – Beispiel-Aufgaben anlegen"
for task in \
  "Interner Audit Q1 $(date +%Y)|high" \
  "Security Awareness Schulung $(date +%Y)|medium" \
  "Lieferantenbewertung Cloud-Provider|medium" \
  "Managementbewertung $(date +%Y)|high"; do
  name="${task%%|*}"
  prio="${task##*|}"
  plane_api POST "/workspaces/${WORKSPACE_SLUG}/projects/${TASK_PROJECT}/issues/" \
    -d "{\"name\": \"${name}\", \"priority\": \"${prio}\"}" > /dev/null
  success "Aufgabe: ${name}"
done

success "Plane Demo-Daten vollständig."
