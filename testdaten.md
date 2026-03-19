---
layout: page
title: Testdaten & Demo
permalink: /testdaten/
---

Für Demos, Schulungen und Evaluierungen können realistische ISMS-Testdaten erzeugt
und automatisch in die Tool-Stacks eingespielt werden. Es gibt zwei Ansätze:
statische Beispieldaten und KI-generierte, organisationsspezifische Inhalte.

---

## Statische Beispieldaten

Im Repository enthaltene Basisdaten — sofort einsatzbereit, branchenunabhängig:

| Datei | Inhalt |
|-------|--------|
| `docker/demo/data/risks.json` | 5 Risiken (Strategisch/Operativ/Technisch) |
| `docker/demo/data/assets.json` | 6 Assets (Informationsassets, Prozesse, Dienstleister) |
| `docker/demo/data/policies/` | 2 Richtlinien (Informationssicherheit, Zugriffssteuerung) |

Einspielung nach Stack-Start:

```bash
cd docker/szenarien/szenario-a   # oder szenario-b
./demo/seed-all.sh
```

Das Skript befüllt alle Werkzeuge des jeweiligen Szenarios in der richtigen Reihenfolge
und gibt Statusmeldungen je Service aus.

---

## KI-generierte Testdaten

Der Generator unter `docker/demo/generate/` erzeugt via
[OpenRouter](https://openrouter.ai) realistische, auf die Organisation zugeschnittene
Inhalte. Ein Maschinenbauer erhält andere Risiken als ein Krankenhaus oder eine Behörde.

### Voraussetzungen

```bash
cd docker/demo/generate
pip install -r requirements.txt
export OPENROUTER_API_KEY=sk-or-...   # openrouter.ai/keys
```

### Organisationskontext definieren

```bash
cp org.json.example org.json
$EDITOR org.json
```

```json
{
  "org_name":    "Musterwerk GmbH",
  "industry":    "Maschinenbau / Anlagenbau",
  "size":        "250",
  "nis2_scope":  "Wichtige Einrichtung – Fertigungssektor (NIS2 Anhang II)",
  "location":    "Bayern, Deutschland",
  "notes":       "Exportorientiert, IT-OT-Verflechtung, ISO 27001 Zertifizierung angestrebt"
}
```

### Generierung

```bash
# Alle Inhalte auf einmal
python generate.py all

# Einzelne Dokumenttypen
python generate.py leitlinie
python generate.py policies
python generate.py risks --count 10
python generate.py audit --scope "Backup und Notfallvorsorge"
python generate.py incident --type "Ransomware-Angriff" --severity Kritisch
```

### Erzeugte Inhalte

| Befehl | Ausgabe | Format |
|--------|---------|--------|
| `leitlinie` | ISMS-Leitlinie | Markdown + YAML-Frontmatter |
| `policies` | 5 Richtlinien (Zugriff, Passwort, Backup, Mobile, Incident) | Markdown |
| `risks` | Risikoregister | JSON (kompatibel mit Seed-Skripten) |
| `audit` | Interner Auditbericht mit Findings | Markdown |
| `incident` | Incident Report mit Timeline und NIS2-Einschätzung | Markdown |

Alle Dateien landen unter `docker/demo/generate/output/`.

### Modellwahl

| Modell | Qualität | Kosten | Empfehlung |
|--------|----------|--------|------------|
| `anthropic/claude-haiku-4-5` | Sehr gut | Gering | Standard |
| `anthropic/claude-sonnet-4-6` | Exzellent | Mittel | Lange Dokumente, Auditberichte |
| `anthropic/claude-opus-4-6` | Herausragend | Hoch | Höchste Qualität |
| `google/gemini-2.0-flash` | Gut | Sehr gering | Kostensparend, schnell |
| `meta-llama/llama-3.3-70b-instruct` | Gut | Sehr gering | Open-Weight, keine Datenweitergabe an Anbieter |
| `mistralai/mistral-large` | Gut | Mittel | Europäischer Anbieter |

```bash
python generate.py --model google/gemini-2.0-flash risks --count 5
```

---

## Integration: Generierte Daten als Seed

Nach der KI-Generierung Ausgaben als Seed-Daten übernehmen:

```bash
python generate.py all

cp output/risks.json    ../../data/risks.json
cp output/policies/*.md ../../data/policies/

# Dann normalen Seed-Workflow ausführen
cd ../szenarien/szenario-a
./demo/seed-all.sh
```

---

## Was wird wo eingespielt?

### Szenario A (Forgejo + OTOBO + DataGerry + BookStack + Wekan)

| Seed-Skript | Ziel-Service | Eingespielter Inhalt |
|-------------|-------------|---------------------|
| `seed-forgejo.sh` | Forgejo | Organisation `isms`, Repositories, Richtlinien als Commits, Branch-Schutz |
| `seed-datagerry.sh` | DataGerry | Objekt-Typen (Asset, Prozess, Dienstleister), 6 Beispiel-Assets |
| `seed-otobo.sh` | OTOBO | Risiko-Tickets in Queue-Hierarchie, Audit-Ticket, Schulungs-Ticket |
| `seed-bookstack.sh` | BookStack | ISMS-Handbuch (Bücherstruktur + Kapitel), Awareness-Seite |
| `seed-wekan.sh` | Wekan | ISMS-Einführungs-Board, Managementbewertungs-Board |

### Szenario B (Forgejo + Plane + DataGerry)

| Seed-Skript | Ziel-Service | Eingespielter Inhalt |
|-------------|-------------|---------------------|
| `seed-forgejo.sh` | Forgejo | Organisation, Repositories, Richtlinien |
| `seed-datagerry.sh` | DataGerry | Objekt-Typen und Beispiel-Assets |
| `seed-plane.sh` | Plane | Projekte (Risikomanagement, ISMS-Aufgaben), Status-Labels, Issues |

---

## Hinweise

**API-Tokens**: Die Seed-Skripte benötigen API-Tokens der jeweiligen Services.
Diese werden nach der Ersteinrichtung in `.env` eingetragen (siehe `.env.example`
des jeweiligen Szenarios).

**Idempotenz**: Die Skripte geben Warnungen aus wenn Objekte bereits existieren,
brechen aber nicht ab. Ein erneuter Aufruf ist in der Regel sicher.

**`org.json`** enthält keine Geheimnisse, sollte aber nicht ins Repository —
es enthält organisationsspezifische Informationen die nicht öffentlich sein müssen.
