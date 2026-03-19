# ISMS-Tooling — Projektkontext für Claude

## Zweck

Konzept und Deployment-Infrastruktur für die Umsetzung eines ISMS mit Open-Source-Werkzeugen.
Zielgruppe: NIS2-betroffene Organisationen (Neueinstieg oder Modernisierung) und deren Supplier.
Normbezug: ISO 27001:2022. Roter Faden: pragmatische Zertifizierungsreife.

## Veröffentlichung

Jekyll auf GitHub Pages (`kaijen.github.io/isms-tooling`).
`baseurl: /isms-tooling` — bei Repo-Umbenennung in `_config.yml` anpassen.

## Inhaltliche Struktur (Jekyll-Site)

| Datei | Status | Inhalt |
|-------|--------|--------|
| `index.md` | ✓ | Einstiegsseite |
| `konzept.md` | ✓ | Leitprinzipien, Anforderungen, SSG-Zugriffssteuerung, Zertifizierungsreife, KI |
| `aufgaben.md` | ✓ | Tool-Klassen, ISMS-Aufgaben mit Werkzeugzuordnung |
| `werkzeuge.md` | ✓ | Werkzeugkandidaten, Self-hosted vs. SaaS, Cloud-Alternativen |
| `szenarien.md` | ✓ A+B | Deployment-Szenarien (Szenario C in Planung) |
| `TODO.md` | laufend | Offene Punkte — nicht in Jekyll-Navigation |

## Leitprinzipien

1. Git für Versionskontrolle und Freigaben (PR = Vier-Augen-Prinzip)
2. Static Site Generator für Dokumentenveröffentlichung (CI/CD als Freigabe-Trigger)
3. Git-Clones als dezentrales Notfall-Backup
4. Tickets für Aufgabenplanung (Templates, wiederkehrende Aufgaben)
5. Risikomanagement als endlicher Automat — Status via Tags/Labels, nicht Workflow-Engine
6. Risikoebenen via Queue-Hierarchie (Strategisch / Operativ / Technisch)
7. Flexibles Bezugsobjekt-Modell: Asset, Prozess, OE, Externer Akteur, Regulatorisch oder keines
8. Risiko- und Behandlungs-Tickets logisch verknüpft, werkzeugmäßig unabhängig
9. KI senkt Disziplinaufwand ohne Verantwortung zu delegieren

## Tool-Klassen

| Kürzel | Klasse | Favorit (On-Premise) |
|--------|--------|----------------------|
| VCS | Git-Plattform | Forgejo |
| IT | Issue Tracker | OTOBO (Szenario A), Plane (Szenario B) |
| KB | Kanban | Wekan |
| WK | Wiki | BookStack |
| AM | Asset Management | DataGerry |
| SSG | Static Site Generator | MkDocs Material |
| CI | CI/CD-Pipeline | Forgejo Actions |
| KI | KI-Assistent | Claude via OpenRouter |

## Szenarien

| Szenario | Ausgangslage | Stack | Status |
|----------|-------------|-------|--------|
| A | Greenfield, NIS2-betroffen | Forgejo + OTOBO + DataGerry + BookStack + Wekan | ✓ |
| B | Supplier, KMU | Forgejo + Plane + DataGerry | ✓ |
| C | Modernisierung von Legacy | TBD | Geplant |

## Docker-Infrastruktur

```
docker/
├── compose/          # Wiederverwendbare Service-Definitionen je Tool
├── szenarien/
│   ├── szenario-a/   # up.sh, override.yml, .env.example, demo/seed-*.sh
│   └── szenario-b/   # up.sh, override.yml, .env.example, demo/seed-*.sh
└── demo/
    ├── lib.sh         # Gemeinsame API-Hilfsfunktionen
    ├── data/          # Statische Beispieldaten (Fallback)
    └── generate/      # KI-Generator via OpenRouter
```

- Reverse Proxy: Traefik v3 mit automatischem Let's Encrypt
- Overlay-Prinzip: Basis-Compose-Files + szenarienspezifisches override.yml
- Demo-Workflow: `./demo/seed-all.sh` nach Stack-Start

## Wichtige Konventionen

- Offene Punkte gehören in `TODO.md`, nicht in Inhaltsdateien
- `.env`-Dateien sind in `.gitignore` — nie einchecken
- `org.json` (Generator-Kontext) ebenfalls nicht einchecken
- Szenario C und Transition Guide stehen noch aus (siehe TODO.md)
