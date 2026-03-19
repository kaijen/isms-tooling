---
layout: page
title: Szenarien
permalink: /szenarien/
---

Die Szenarien beschreiben konkrete Ausgangssituationen mit passenden Werkzeugkombinationen
und Deployment-Anleitungen. Alle On-Premise-Szenarien nutzen Docker Compose mit
[Traefik](https://traefik.io) als Reverse Proxy.

## Übersicht

| | Szenario A | Szenario B | Szenario C |
|--|------------|------------|------------|
| **Ausgangslage** | Greenfield, NIS2-betroffen | Supplier, KMU | Modernisierung von Legacy |
| **Ziel** | Vollständiges ISMS, zertifizierungsreif | Nachweisfähigkeit mit minimalem Aufwand | Migration von Word/SharePoint |
| **Stack** | Voll | Minimal | Voll + Migrationspfad |
| **Status** | ✓ | ✓ | In Planung |

---

## Szenario A — Greenfield, NIS2-betroffen

### Ausgangslage

Keine bestehende ISMS-Infrastruktur. Handlungsdruck durch NIS2-Betroffenheit oder
Kundenanforderung. Ziel: in möglichst kurzer Zeit eine nachweisfähige und
zertifizierungsreife Grundstruktur aufbauen.

### Stack

| Tool-Klasse | Werkzeug | URL-Pfad |
|-------------|---------|----------|
| VCS + CI | Forgejo | `git.<domain>` |
| Issue Tracker | OTOBO | `tickets.<domain>` |
| Asset Management | DataGerry | `assets.<domain>` |
| Wiki | BookStack | `wiki.<domain>` |
| Kanban | Wekan | `board.<domain>` |
| Docs (SSG) | MkDocs → nginx | `docs.<domain>` |
| Reverse Proxy | Traefik | `traefik.<domain>` |

OTOBO wurde für dieses Szenario gewählt wegen der nativen Queue-Hierarchie
(Strategisch / Operativ / Technisch) und der Prozess-Engine für wiederkehrende Aufgaben.

### Systemanforderungen

| Ressource | Minimum | Empfohlen |
|-----------|---------|-----------|
| CPU | 4 Kerne | 8 Kerne |
| RAM | 8 GB | 16 GB |
| Disk | 50 GB | 100 GB SSD |
| OS | Linux (Docker 24+) | Ubuntu 22.04 LTS |

### Deployment

```bash
# Repository klonen
git clone https://git.example.com/isms/isms-tooling.git
cd isms-tooling/docker/szenarien/szenario-a

# Umgebungsvariablen anpassen
cp .env.example .env
$EDITOR .env

# Stack starten
./up.sh up -d

# Status prüfen
./up.sh ps
```

Das Skript kombiniert folgende Compose-Files:

```
traefik.yml        # Reverse Proxy, TLS
forgejo.yml        # VCS + CI
otobo.yml          # Ticket-System
datagerry.yml      # Asset Management
bookstack.yml      # Wiki
wekan.yml          # Kanban
docs.yml           # Statische Dokumentation
override.yml       # Szenario-A-spezifische Anpassungen
```

### Einrichtungsreihenfolge

1. **Traefik + Forgejo** starten, DNS-Einträge prüfen
2. **Forgejo** einrichten: Organisation, Repositories (`isms-policies`, `isms-docs`),
   Actions aktivieren, ersten Admin-User anlegen
3. **OTOBO** Erstinstallation durchlaufen, Queue-Struktur anlegen
   (`Risiken::Strategisch`, `Risiken::Operativ`, `Risiken::Technisch`),
   Dynamic Fields für Risikobewertung konfigurieren
4. **DataGerry** Objekt-Typen definieren (Informationsasset, Prozess,
   Organisationseinheit, Dienstleister)
5. **BookStack** einrichten: Bücherstruktur für ISMS-Handbuch anlegen
6. **MkDocs-Pipeline** in Forgejo Actions konfigurieren — Build-Output in
   `docs-public` Volume deployen

---

## Szenario B — Supplier, KMU

### Ausgangslage

Kleines Unternehmen mit begrenzten IT-Ressourcen. Nachweispflicht gegenüber einem
NIS2-betroffenen Auftraggeber oder Vorbereitung auf eine ISO-27001-Zertifizierung.
Priorität: minimaler Betriebsaufwand, maximale Zertifizierungsrelevanz.

### Stack

| Tool-Klasse | Werkzeug | URL-Pfad |
|-------------|---------|----------|
| VCS + CI | Forgejo | `git.<domain>` |
| Issue Tracker | Plane | `plane.<domain>` |
| Asset Management | DataGerry | `assets.<domain>` |
| Docs (SSG) | MkDocs → nginx | `docs.<domain>` |
| Reverse Proxy | Traefik | `traefik.<domain>` |

Wiki und Kanban-Board werden in diesem Szenario weggelassen — Awareness-Material
landet direkt auf der Docs-Site, Projektsteuerung erfolgt über Plane-Boards.

Plane wurde gegenüber OTOBO gewählt: einfachere Einrichtung, modernere UI,
geringere Ressourcenanforderungen. Der fehlende Recurring-Tasks-Mechanismus wird
über Plane-Templates und eine kurze manuelle Wiedervorlage-Routine abgedeckt.

### Systemanforderungen

| Ressource | Minimum | Empfohlen |
|-----------|---------|-----------|
| CPU | 2 Kerne | 4 Kerne |
| RAM | 4 GB | 8 GB |
| Disk | 30 GB | 60 GB SSD |
| OS | Linux (Docker 24+) | Ubuntu 22.04 LTS |

Geeignet für einen günstigen VPS (Hetzner CX22, DigitalOcean Droplet).

### Deployment

```bash
cd isms-tooling/docker/szenarien/szenario-b

cp .env.example .env
$EDITOR .env

./up.sh up -d
./up.sh ps
```

Das Skript kombiniert:

```
traefik.yml        # Reverse Proxy, TLS
forgejo.yml        # VCS + CI
plane.yml          # Ticket-System
datagerry.yml      # Asset Management
docs.yml           # Statische Dokumentation
override.yml       # Ressourcenlimits für kleine Hardware
```

### Einrichtungsreihenfolge

1. **Traefik + Forgejo** starten
2. **Forgejo** einrichten: Repository `isms-policies`, Actions aktivieren
3. **Plane** einrichten: Workspace anlegen, Projekte für
   Risikomanagement und Aufgabenverfolgung erstellen,
   Labels für Status-Tags konfigurieren (`status:identifiziert` etc.),
   Issue-Templates für Risiko und Audit anlegen
4. **DataGerry** Minimal-Schema definieren (Informationsasset, Dienstleister)
5. **MkDocs-Pipeline** in Forgejo Actions

---

## Gemeinsame Konfigurationshinweise

### Traefik TLS

Alle Routen erhalten automatisch Let's-Encrypt-Zertifikate. Voraussetzung:
DNS-A-Records für alle Subdomains zeigen auf die Server-IP, Port 80 und 443 sind
erreichbar.

Für interne Setups ohne öffentliche IP: `--certificatesresolvers.letsencrypt.acme.dnschallenge`
verwenden (DNS-01 Challenge, funktioniert ohne eingehenden HTTP-Traffic).

### Secrets

Alle Passwörter und Schlüssel in `.env` generieren:

```bash
# Zufälligen 64-Zeichen-String erzeugen
openssl rand -hex 32

# htpasswd für Traefik Dashboard
htpasswd -nb admin 'meinPasswort'
```

`.env` niemals in Git einchecken — ist in `.gitignore` eingetragen.

### Updates

```bash
# Images aktualisieren
./up.sh pull

# Stack neu starten
./up.sh up -d
```

### Backup

Volumes sichern mit einem täglichen Cronjob:

```bash
docker run --rm \
  -v <volume>:/source:ro \
  -v /backup:/backup \
  alpine tar czf /backup/<volume>-$(date +%Y%m%d).tar.gz -C /source .
```
