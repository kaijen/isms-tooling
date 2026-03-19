#!/usr/bin/env bash
# Szenario A – DataGerry: Objekt-Typen und Beispiel-Assets anlegen
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

DATAGERRY_URL="https://assets.${DOMAIN}"
DATA_DIR="${SCRIPT_DIR}/../../../demo/data"

step "DataGerry – Warte auf Service"
wait_for_http "${DATAGERRY_URL}" "DataGerry"

step "DataGerry – Objekt-Typ: Informationsasset"
datagerry_api POST /rest/types -d '{
  "name": "informationsasset",
  "label": "Informationsasset",
  "fields": [
    {"type": "text",     "name": "name",             "label": "Name"},
    {"type": "text",     "name": "verantwortlicher",  "label": "Verantwortlicher"},
    {"type": "select",   "name": "schutzbedarf_v",    "label": "Vertraulichkeit",
     "options": ["Niedrig","Mittel","Hoch","Sehr hoch"]},
    {"type": "select",   "name": "schutzbedarf_i",    "label": "Integrität",
     "options": ["Niedrig","Mittel","Hoch","Sehr hoch"]},
    {"type": "select",   "name": "schutzbedarf_a",    "label": "Verfügbarkeit",
     "options": ["Niedrig","Mittel","Hoch","Sehr hoch"]},
    {"type": "text",     "name": "standort",          "label": "Standort"},
    {"type": "textarea", "name": "beschreibung",      "label": "Beschreibung"}
  ]
}' || warn "Typ Informationsasset existiert möglicherweise bereits"
success "Objekt-Typ Informationsasset angelegt"

step "DataGerry – Objekt-Typ: Prozess"
datagerry_api POST /rest/types -d '{
  "name": "prozess",
  "label": "Prozess",
  "fields": [
    {"type": "text",     "name": "name",                   "label": "Name"},
    {"type": "text",     "name": "prozessverantwortlicher", "label": "Prozessverantwortlicher"},
    {"type": "select",   "name": "kritikalitaet",           "label": "Kritikalität",
     "options": ["Niedrig","Mittel","Hoch","Kritisch"]},
    {"type": "textarea", "name": "beschreibung",            "label": "Beschreibung"}
  ]
}' || warn "Typ Prozess existiert möglicherweise bereits"
success "Objekt-Typ Prozess angelegt"

step "DataGerry – Objekt-Typ: Dienstleister"
datagerry_api POST /rest/types -d '{
  "name": "dienstleister",
  "label": "Dienstleister",
  "fields": [
    {"type": "text",   "name": "name",          "label": "Name"},
    {"type": "text",   "name": "kontakt",        "label": "Kontakt"},
    {"type": "select", "name": "vertragsart",    "label": "Vertragsart",
     "options": ["AVV","Dienstleistungsvertrag","SLA","Rahmenvertrag"]},
    {"type": "select", "name": "kritikalitaet",  "label": "Kritikalität",
     "options": ["Niedrig","Mittel","Hoch","Kritisch"]},
    {"type": "text",   "name": "standort",       "label": "Standort / Region"}
  ]
}' || warn "Typ Dienstleister existiert möglicherweise bereits"
success "Objekt-Typ Dienstleister angelegt"

step "DataGerry – Beispiel-Assets anlegen"
# Typen-IDs abrufen
INFO_TYPE_ID=$(datagerry_api GET /rest/types | python3 -c \
  "import sys,json; types=json.load(sys.stdin)['results']; \
   print(next(t['public_id'] for t in types if t['name']=='informationsasset'))")
PROC_TYPE_ID=$(datagerry_api GET /rest/types | python3 -c \
  "import sys,json; types=json.load(sys.stdin)['results']; \
   print(next(t['public_id'] for t in types if t['name']=='prozess'))")
DL_TYPE_ID=$(datagerry_api GET /rest/types | python3 -c \
  "import sys,json; types=json.load(sys.stdin)['results']; \
   print(next(t['public_id'] for t in types if t['name']=='dienstleister'))")

# Assets aus JSON anlegen
python3 - "${DATA_DIR}/assets.json" "${INFO_TYPE_ID}" "${PROC_TYPE_ID}" "${DL_TYPE_ID}" "${DATAGERRY_URL}" "${DATAGERRY_TOKEN}" << 'PYEOF'
import sys, json, urllib.request, urllib.error

assets_file, info_id, proc_id, dl_id, base_url, token = sys.argv[1:]
type_map = {"Informationsasset": info_id, "Prozess": proc_id, "Dienstleister": dl_id}

with open(assets_file) as f:
    assets = json.load(f)

for asset in assets:
    type_id = type_map.get(asset["type"])
    if not type_id:
        print(f"  SKIP unbekannter Typ: {asset['type']}")
        continue

    fields = [{"name": k, "value": v} for k, v in asset.items() if k != "type"]
    payload = json.dumps({"type_id": int(type_id), "fields": fields}).encode()
    req = urllib.request.Request(
        f"{base_url}/rest/objects",
        data=payload,
        headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json"},
        method="POST"
    )
    try:
        urllib.request.urlopen(req)
        print(f"  OK  {asset['type']}: {asset['name']}")
    except urllib.error.HTTPError as e:
        print(f"  WARN {asset['name']}: {e}")
PYEOF

success "DataGerry Demo-Daten vollständig."
