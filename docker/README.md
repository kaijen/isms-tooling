# ISMS Docker Deployment

Dieses Verzeichnis enthält Docker-Compose-Konfigurationen für den On-Premise-Betrieb
des ISMS-Tool-Stacks. Alle Szenarien nutzen [Traefik](https://traefik.io) als Reverse
Proxy mit automatischer TLS-Zertifikatsverwaltung via Let's Encrypt.

## Voraussetzungen

- Docker 24+ und Docker Compose v2 (`docker compose`)
- DNS-Einträge für alle Subdomains zeigen auf die Server-IP
- Ports 80 und 443 sind erreichbar (für Let's Encrypt HTTP-Challenge)
- Mindest-RAM je nach Szenario (siehe Szenario-README)

## Struktur

```
docker/
├── compose/              # Wiederverwendbare Service-Definitionen
│   ├── traefik.yml       # Reverse Proxy (in jedem Szenario)
│   ├── forgejo.yml       # Git-Plattform + CI
│   ├── otobo.yml         # Ticket-System, ITIL-orientiert (Szenario A)
│   ├── plane.yml         # Ticket-System, modern (Szenario B)
│   ├── datagerry.yml     # Asset Management / CMDB
│   ├── bookstack.yml     # Wiki
│   ├── wekan.yml         # Kanban-Board
│   └── docs.yml          # Nginx für MkDocs-Output (SSG)
└── szenarien/
    ├── szenario-a/       # Greenfield, NIS2-betroffen — voller Stack
    └── szenario-b/       # Supplier, KMU — minimaler Stack
```

## Szenarien

| Szenario | Beschreibung | Stack |
|----------|-------------|-------|
| [A](szenarien/szenario-a/) | Greenfield, NIS2-betroffen | Forgejo + OTOBO + DataGerry + BookStack + Wekan |
| [B](szenarien/szenario-b/) | Supplier, KMU | Forgejo + Plane + DataGerry |

## Overlay-Prinzip

Jedes Szenario kombiniert mehrere Compose-Files via `-f`-Flags und ein
szenarienspezifisches `override.yml`. Das `up.sh`-Skript übernimmt die Verkettung:

```bash
docker compose \
  -f compose/traefik.yml \
  -f compose/forgejo.yml \
  -f compose/otobo.yml \
  ...
  -f szenarien/szenario-a/override.yml \
  up -d
```

## Secrets und .env

Jedes Szenario hat eine `.env.example`. Vor dem ersten Start:

```bash
cd szenarien/szenario-X
cp .env.example .env
$EDITOR .env        # Alle Passwörter und Schlüssel setzen
```

Passwörter generieren:
```bash
openssl rand -hex 32    # 64-stelliger Hex-String
openssl rand -base64 32 # Base64-kodierter String
htpasswd -nb admin 'passwort'  # Traefik Dashboard
```

`.env`-Dateien sind in `.gitignore` eingetragen und werden nicht eingecheckt.

## Häufige Befehle

```bash
./up.sh up -d        # Stack starten
./up.sh ps           # Status anzeigen
./up.sh logs -f      # Logs verfolgen
./up.sh down         # Stack stoppen (Volumes bleiben erhalten)
./up.sh pull         # Images aktualisieren
./up.sh down && ./up.sh up -d  # Stack neu starten
```
