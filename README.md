# ISMS mit einfachen Mitteln

Konzept und Deployment-Infrastruktur für die Umsetzung eines
**Information Security Management Systems (ISMS)** mit Open-Source-Werkzeugen —
ohne proprietäre ISMS-Software, ohne Vendor Lock-in, mit pragmatischem Blick auf
ISO-27001-Zertifizierungsreife.

**Zielgruppe**: NIS2-betroffene Organisationen, die neu anfangen oder bestehende
Strukturen modernisieren, sowie deren Supplier.

→ **[Zur veröffentlichten Dokumentation](https://kaijen.github.io/isms-tooling/)**

---

## Inhalt dieses Repositories

### Konzeptdokumentation (Jekyll-Site)

| Seite | Inhalt |
|-------|--------|
| [Konzept & Anforderungen](konzept.md) | Leitprinzipien, Werkzeuganforderungen, Zertifizierungsreife |
| [Aufgaben & Tool-Klassen](aufgaben.md) | ISMS-Prozesse generisch beschrieben |
| [Werkzeugkandidaten](werkzeuge.md) | Bewertung konkreter OSS-Tools, Self-hosted vs. SaaS |
| [Szenarien](szenarien.md) | Deployment-Anleitungen für konkrete Ausgangssituationen |

### Docker-Deployment

Produktionsreife Docker-Compose-Konfigurationen mit Traefik als Reverse Proxy:

```
docker/
├── compose/           # Service-Definitionen (Traefik, Forgejo, OTOBO, Plane, ...)
├── szenarien/
│   ├── szenario-a/    # Greenfield NIS2 — voller Stack
│   └── szenario-b/    # Supplier KMU — minimaler Stack
└── demo/
    ├── data/          # Statische Beispieldaten
    └── generate/      # KI-gestützter Demo-Datengenerator (OpenRouter)
```

---

## Schnellstart

### Szenario B — Supplier/KMU (minimaler Stack)

```bash
git clone https://github.com/kaijen/isms-tooling.git
cd isms-tooling/docker/szenarien/szenario-b

cp .env.example .env
$EDITOR .env           # Domain, Passwörter, API-Keys setzen

./up.sh up -d
./up.sh ps
```

Systemanforderungen: 4 GB RAM, 2 vCPUs, Docker 24+. Läuft auf einem günstigen VPS.

### Szenario A — Greenfield NIS2 (voller Stack)

```bash
cd isms-tooling/docker/szenarien/szenario-a
cp .env.example .env && $EDITOR .env
./up.sh up -d
```

Systemanforderungen: 8 GB RAM, 4 vCPUs.

### Demo-Daten generieren

**Statisch** (sofort einsatzbereit):
```bash
cd docker/szenarien/szenario-a
./demo/seed-all.sh
```

**KI-generiert** (organisationsspezifisch via OpenRouter):
```bash
cd docker/demo/generate
cp org.json.example org.json && $EDITOR org.json
export OPENROUTER_API_KEY=sk-or-...
python generate.py all

cp output/risks.json ../data/risks.json
cp output/policies/*.md ../data/policies/
cd ../../szenarien/szenario-a && ./demo/seed-all.sh
```

---

## Leitprinzipien

1. **Git** für Versionskontrolle und Freigaben — PR = Vier-Augen-Prinzip, Merge = Freigabe
2. **Static Site Generator** für Dokumentenveröffentlichung — CI/CD als Freigabe-Trigger
3. **Git-Clones** als dezentrales Notfall-Backup
4. **Tickets** für Aufgabenplanung — Templates und wiederkehrende Aufgaben
5. **Risiken als Tickets** — Lebenszyklus via Tags/Labels, nicht Workflow-Engine
6. **Queue-Hierarchie** für Risikoebenen — Zugriffssteuerung und Ebene in einem Schritt
7. **Flexibles Bezugsobjekt** — Asset, Prozess, OE, Regulatorisch oder keines
8. **KI** reduziert Dokumentationsaufwand ohne Verantwortung zu delegieren

---

## Werkzeugstack

| Tool-Klasse | Szenario A | Szenario B |
|-------------|-----------|-----------|
| Git-Plattform + CI | Forgejo | Forgejo |
| Issue Tracker | OTOBO | Plane |
| Asset Management | DataGerry | DataGerry |
| Wiki | BookStack | — |
| Kanban | Wekan | — |
| Reverse Proxy | Traefik | Traefik |
| SSG | MkDocs Material | MkDocs Material |

Alle Werkzeuge Open Source, selbst-hostbar via Docker.

---

## Offene Punkte

Siehe [TODO.md](TODO.md).

## Lizenz

Inhalte dieses Repositories stehen unter [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
