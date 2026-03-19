# Szenario A — Greenfield, NIS2-betroffen

Vollständiger ISMS-Stack für Organisationen die neu mit ISO 27001 beginnen und
unter NIS2-Handlungsdruck stehen.

## Stack

| Service | URL | Zweck |
|---------|-----|-------|
| Traefik | `traefik.<domain>` | Reverse Proxy, TLS |
| Forgejo | `git.<domain>` | VCS, CI/CD, PR-Freigaben |
| OTOBO | `tickets.<domain>` | Ticket-System (Risiken, Audits, Aufgaben) |
| DataGerry | `assets.<domain>` | Asset Management / CMDB |
| BookStack | `wiki.<domain>` | Wiki, Handbücher, Awareness |
| Wekan | `board.<domain>` | Kanban, Projektsteuerung |
| Docs | `docs.<domain>` | Veröffentlichte Richtlinien (MkDocs-Output) |

## Systemanforderungen

| Ressource | Minimum | Empfohlen |
|-----------|---------|-----------|
| CPU | 4 Kerne | 8 Kerne |
| RAM | 8 GB | 16 GB |
| Disk | 50 GB | 100 GB SSD |
| OS | Linux, Docker 24+ | Ubuntu 22.04 LTS |

## Schnellstart

```bash
# 1. Umgebungsvariablen konfigurieren
cp .env.example .env
$EDITOR .env

# 2. Stack starten
./up.sh up -d

# 3. Status prüfen
./up.sh ps
```

## Einrichtungsreihenfolge

### 1. Traefik & Forgejo

Nach `./up.sh up -d` zuerst DNS-Auflösung prüfen:

```bash
curl -I https://git.<domain>
```

In Forgejo:
- Erstinstallation abschließen (Admin-User anlegen)
- Organisation `isms` anlegen
- Repositories erstellen: `isms-policies`, `isms-docs`
- Forgejo Actions aktivieren (Site Administration → Actions)

### 2. OTOBO

OTOBO Erstinstallation über `https://tickets.<domain>/otobo/installer.pl`.

Nach der Installation Queue-Hierarchie anlegen:

```
Risiken::Strategisch
Risiken::Operativ
Risiken::Technisch
Aufgaben::Audit
Aufgaben::Schulung
Aufgaben::Lieferant
Incidents
```

Dynamic Fields für Risiko-Tickets:
| Feldname | Typ | Werte |
|----------|-----|-------|
| `RisikoWahrscheinlichkeit` | Dropdown | 1-Selten, 2-Möglich, 3-Wahrscheinlich, 4-Fast sicher |
| `RisikoSchadenshoehe` | Dropdown | 1-Gering, 2-Mittel, 3-Hoch, 4-Kritisch |
| `RisikoWert` | Text | berechnet (W × S) |
| `BezugsobjektTyp` | Dropdown | Asset, Prozess, OE, Extern, Regulatorisch |
| `BezugsobjektID` | Text | Referenz auf DataGerry-Objekt oder Freitext |
| `Risikoebene` | Dropdown | Strategisch, Operativ, Technisch |

Status-Tags als Ticket-Priorität oder eigenes Dynamic Field:
`identifiziert → bewertet → behandlung_geplant → in_behandlung → akzeptiert / geschlossen`

### 3. DataGerry

Objekt-Typen anlegen unter `https://assets.<domain>`:

- **Informationsasset**: Name, Verantwortlicher, Schutzbedarf (VIV), Standort
- **Prozess**: Name, Prozessverantwortlicher, Abhängige Assets
- **Organisationseinheit**: Name, Leiter, übergeordnete OE
- **Dienstleister**: Name, Kontakt, Vertragsart, Kritikalität

### 4. BookStack

Bücherstruktur für ISMS-Handbuch:

```
Buch: ISMS-Handbuch
├── Kapitel: Grundlagen & Scope
├── Kapitel: Rollen & Verantwortlichkeiten
├── Kapitel: Risikomanagement
└── Kapitel: Notfallmanagement

Buch: Awareness
├── Kapitel: Phishing & Social Engineering
└── Kapitel: Passwort & Zugangssicherheit
```

### 5. MkDocs CI-Pipeline

In Forgejo unter `isms-docs` eine Actions-Workflow-Datei anlegen
(`.forgejo/workflows/docs.yml`):

```yaml
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: docker
    container:
      image: squidfunk/mkdocs-material
    steps:
      - uses: actions/checkout@v4
      - run: mkdocs build
      - name: Deploy to docs volume
        run: |
          # Artefakt in docs-public Volume deployen
          cp -r site/* /docs-public/
```

## Backup

Volumes täglich sichern:

```bash
for vol in forgejo-data forgejo-db otobo-opt otobo-db datagerry-db bookstack-data bookstack-db wekan-db; do
  docker run --rm \
    -v ${vol}:/source:ro \
    -v /backup:/backup \
    alpine tar czf /backup/${vol}-$(date +%Y%m%d).tar.gz -C /source .
done
```
