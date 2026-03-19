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

step "Forgejo – Statement of Applicability (soa.yml) einchecken"
forgejo_create_file "isms" "isms-policies" \
  "soa.yml" \
  "docs: add Statement of Applicability (alle 93 ISO 27001:2022 Annex-A-Controls)" \
  "$(base64 -w 0 "${DATA_DIR}/soa.yml")" \
  && success "soa.yml eingecheckt" || warn "soa.yml konnte nicht eingecheckt werden"

step "Forgejo – CI-Workflow für SoA-Publikation einchecken"
SOA_WORKFLOW=$(base64 -w 0 << 'YAML'
# .forgejo/workflows/soa-publish.yml
# Konvertiert soa.yml → docs/soa.md und löst MkDocs-Build aus
name: SoA publizieren

on:
  push:
    branches: [main]
    paths:
      - soa.yml

jobs:
  publish:
    runs-on: docker
    container:
      image: python:3.12-slim
    env:
      OTOBO_URL: ${{ secrets.OTOBO_URL }}
      WIKI_URL:  ${{ secrets.WIKI_URL }}
      DOCS_URL:  ${{ secrets.DOCS_URL }}
    steps:
      - uses: actions/checkout@v4

      - name: SoA YAML → Markdown konvertieren
        run: |
          pip install pyyaml --quiet
          python3 - << 'EOF'
          import yaml, datetime, os

          OTOBO_URL = os.environ.get("OTOBO_URL", "").rstrip("/")
          WIKI_URL  = os.environ.get("WIKI_URL",  "").rstrip("/")
          DOCS_URL  = os.environ.get("DOCS_URL",  "").rstrip("/")

          def render_evidence(ev_list):
              if not ev_list:
                  return "—"
              links = []
              for e in ev_list:
                  t   = e.get("type", "")
                  ref = e.get("ref", "")
                  lbl = e.get("label", ref)
                  if t == "doc":
                      url = f"{DOCS_URL}/{ref}" if DOCS_URL else ref
                      links.append(f"[{lbl}]({url})")
                  elif t == "ticket":
                      url = f"{OTOBO_URL}/otobo/index.pl?Action=AgentTicketQueue" if OTOBO_URL else ""
                      links.append(f"[{lbl}]({url})" if url else lbl)
                  elif t == "wiki":
                      links.append(f"[{lbl}]({WIKI_URL})" if WIKI_URL else lbl)
                  else:  # tool oder unbekannt — kein Link
                      links.append(lbl)
              return " · ".join(links)

          with open("soa.yml") as f:
              data = yaml.safe_load(f)

          controls = data["controls"]
          meta     = data["meta"]

          applicable     = [c for c in controls if c["applicable"]]
          not_applicable = [c for c in controls if not c["applicable"]]
          umgesetzt      = [c for c in applicable if c.get("status") == "umgesetzt"]
          in_umsetzung   = [c for c in applicable if c.get("status") == "in-umsetzung"]
          geplant        = [c for c in applicable if c.get("status") == "geplant"]

          categories = {}
          for c in applicable:
              cat = c["category"]
              categories.setdefault(cat, []).append(c)

          STATUS_BADGE = {
              "umgesetzt":    "✅",
              "in-umsetzung": "🔄",
              "geplant":      "⏳",
          }

          lines = [
              "# Statement of Applicability (SoA)",
              "",
              f"> **Version:** {meta['version']} | "
              f"**Status:** {meta['status']} | "
              f"**Owner:** {meta['owner']}",
              f"> **Nächste Überprüfung:** {meta['next_review']} | "
              f"**Generiert:** {datetime.date.today()}",
              "",
              "## Übersicht",
              "",
              f"| | Anzahl |",
              f"|--|--------|",
              f"| Controls gesamt (Annex A) | 93 |",
              f"| Anwendbar | {len(applicable)} |",
              f"| ✅ Umgesetzt | {len(umgesetzt)} |",
              f"| 🔄 In Umsetzung | {len(in_umsetzung)} |",
              f"| ⏳ Geplant | {len(geplant)} |",
              f"| Nicht anwendbar | {len(not_applicable)} |",
              "",
          ]

          for cat, ctrls in categories.items():
              lines += [f"## {cat}", ""]
              lines += ["| Control | Titel | Status | Maßnahme | Nachweis |",
                        "|---------|-------|--------|----------|---------|"]
              for c in ctrls:
                  badge   = STATUS_BADGE.get(c.get("status",""), "❓")
                  ev      = render_evidence(c.get("evidence", []))
                  lines.append(
                      f"| **{c['id']}** | {c['title']} | {badge} {c.get('status','')} "
                      f"| {c.get('measures','—')[:80]} | {ev} |"
                  )
              lines.append("")

          lines += [
              "## Nicht anwendbare Controls",
              "",
              "| Control | Titel | Begründung |",
              "|---------|-------|-----------|",
          ]
          for c in not_applicable:
              lines.append(f"| **{c['id']}** | {c['title']} | {c['justification']} |")

          with open("docs/soa.md", "w") as f:
              f.write("\n".join(lines) + "\n")

          print("docs/soa.md generiert.")
          EOF

      - name: MkDocs bauen und deployen
        run: |
          pip install mkdocs-material --quiet
          mkdocs build
          cp -r site/* /docs-public/ 2>/dev/null || true
YAML
)
forgejo_create_file "isms" "isms-policies" \
  ".forgejo/workflows/soa-publish.yml" \
  "ci: add SoA-to-Markdown publish workflow" \
  "${SOA_WORKFLOW}" \
  && success "SoA-Workflow eingecheckt" || warn "SoA-Workflow konnte nicht eingecheckt werden"

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
