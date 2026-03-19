# Szenario B — Supplier, KMU

Minimaler ISMS-Stack für kleine Organisationen mit Nachweispflicht gegenüber
Auftraggebern oder Vorbereitung auf ISO-27001-Zertifizierung.

## Stack

| Service | URL | Zweck |
|---------|-----|-------|
| Traefik | `traefik.<domain>` | Reverse Proxy, TLS |
| Forgejo | `git.<domain>` | VCS, CI/CD, PR-Freigaben |
| Plane | `plane.<domain>` | Ticket-System (Risiken, Aufgaben) |
| DataGerry | `assets.<domain>` | Asset Management / CMDB |
| Docs | `docs.<domain>` | Veröffentlichte Richtlinien (MkDocs-Output) |

Wiki und Kanban entfallen — Awareness-Material auf der Docs-Site,
Projektsteuerung über Plane-Boards.

## Systemanforderungen

| Ressource | Minimum | Empfohlen |
|-----------|---------|-----------|
| CPU | 2 Kerne | 4 Kerne |
| RAM | 4 GB | 8 GB |
| Disk | 30 GB | 60 GB SSD |
| OS | Linux, Docker 24+ | Ubuntu 22.04 LTS |

Geeignet für Hetzner CX22 (4 GB RAM, 2 vCPUs, ~5 €/Monat).

## Schnellstart

```bash
cp .env.example .env
$EDITOR .env
./up.sh up -d
./up.sh ps
```

## Einrichtungsreihenfolge

### 1. Traefik & Forgejo

Identisch mit Szenario A — siehe [Szenario A README](../szenario-a/README.md#1-traefik--forgejo).

### 2. Plane

Nach dem ersten Start unter `https://plane.<domain>`:

- Workspace anlegen
- Projekt **Risikomanagement** anlegen
  - Labels für Status-Tags:
    `status:identifiziert`, `status:bewertet`, `status:behandlung_geplant`,
    `status:in_behandlung`, `status:akzeptiert`, `status:geschlossen`
  - Custom Fields (Plane Pro oder Community-Feature prüfen):
    `Wahrscheinlichkeit`, `Schadenshöhe`, `Risikowert`, `Bezugsobjekt-Typ`
  - Issue-Template **Risiko** anlegen mit Pflichtfeldern
- Projekt **ISMS-Aufgaben** anlegen
  - Issue-Templates: `Interner Audit`, `Managementbewertung`, `Schulung`, `Lieferantenbewertung`
  - Boards-Ansicht für Projektsteuerung aktivieren

### 3. DataGerry

Minimal-Schema:

- **Informationsasset**: Name, Verantwortlicher, Schutzbedarf
- **Dienstleister**: Name, Kontakt, Kritikalität

### 4. MkDocs CI-Pipeline

Identisch mit Szenario A — siehe
[Szenario A README](../szenario-a/README.md#5-mkdocs-ci-pipeline).

## Wiederkehrende Aufgaben ohne nativen Recurring-Mechanismus

Plane unterstützt keine automatisch wiederkehrenden Tickets. Empfohlener Workaround:

1. Issue-Template je wiederkehrende Aufgabe anlegen (Audit, Schulung etc.)
2. Kalender-Erinnerung im Team für Erstellungstermin
3. Neues Ticket aus Template erzeugen, Fälligkeit setzen

Alternativ: Cron-Job via Plane-API

```bash
# Beispiel: Monatliche Erinnerung via Plane REST API
curl -X POST https://plane.<domain>/api/v1/workspaces/<slug>/projects/<id>/issues/ \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name": "Monatliche Risiko-Wiedervorlage", "label_ids": ["status:bewertet"]}'
```

## Backup

```bash
for vol in forgejo-data forgejo-db plane-db plane-media datagerry-db; do
  docker run --rm \
    -v ${vol}:/source:ro \
    -v /backup:/backup \
    alpine tar czf /backup/${vol}-$(date +%Y%m%d).tar.gz -C /source .
done
```
