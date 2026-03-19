---
layout: page
title: Werkzeugkandidaten
permalink: /werkzeuge/
---

Bewertung von Open-Source-Kandidaten je Tool-Klasse anhand der in
[Aufgaben & Tool-Klassen](../aufgaben) abgeleiteten Anforderungen.

Legende: ✓ vorhanden · ~ eingeschränkt oder via Plugin · ✗ nicht vorhanden

---

## Git-Plattform (VCS + CI)

Anforderungen: PR/Review-Workflow, CI/CD-Integration, Zugriffssteuerung, selbst-hostbar.

| Kriterium | Gitea / Forgejo | GitLab CE | GitHub |
|-----------|:-:|:-:|:-:|
| PR/Review-Workflow | ✓ | ✓ | ✓ |
| Integrierte CI/CD | ~ (Actions, eingeschränkt) | ✓ | ✓ |
| Branch-Schutzregeln | ✓ | ✓ | ✓ |
| Selbst-hostbar | ✓ | ✓ | ✗ |
| Open Source | ✓ (Forgejo: FOSS-Fork) | ~ (CE: MIT, EE proprietär) | ✗ |
| Ressourcenbedarf | gering | hoch | — |
| Issue-Tracker integriert | ~ (sehr einfach) | ✓ | ~ |

**Einschätzung**

- **Forgejo** (Community-Fork von Gitea): Erste Wahl für selbst-gehostete Setups mit
  geringem Ressourcenbedarf. CI/CD über Forgejo Actions (Gitea-kompatibel, GitHub-Actions-Syntax).
  Issue-Tracker zu rudimentär für ISMS-Anforderungen — separates Werkzeug nötig.
- **GitLab CE**: Vollständigste Lösung aus einer Hand, aber ressourcenintensiv. Issues mit
  Templates und Labels ausreichend für einfache Setups; Custom Fields und Recurring fehlen in CE.
- **GitHub**: Keine Selbst-Hosting-Option. Für Organisationen die bereits GitHub nutzen
  dennoch pragmatisch — GitHub Actions und Pages sind ausgereift.

---

## Issue Tracker

Anforderungen: Templates, wiederkehrende Tickets, benutzerdefinierte Felder, Tags für
Statusmodellierung, Ticket-Verlinkung, Filteransichten, Zugriffssteuerung per Projekt/Queue,
Open Source, selbst-hostbar.

| Kriterium | Plane | OpenProject | Redmine | OTOBO | GitLab Issues |
|-----------|:-:|:-:|:-:|:-:|:-:|
| Issue-Templates | ✓ | ✓ | ~ (Plugin) | ✓ (Prozesse) | ✓ |
| Wiederkehrende Tickets | ✗ | ~ (manuell) | ✓ (Plugin) | ✓ (Prozess-Engine) | ✗ |
| Benutzerdefinierte Felder | ✓ | ✓ | ✓ | ✓ (Dynamic Fields) | ✗ (CE) |
| Tags / Labels | ✓ | ~ | ~ (Plugin) | ✓ (Queues + Felder) | ✓ |
| Ticket-Verlinkung | ✓ | ✓ | ✓ | ✓ | ✓ |
| Filteransichten | ✓ | ✓ | ✓ | ✓ | ~ |
| Zugriffssteuerung (Queues) | ~ (Projekte) | ✓ | ✓ | ✓ (nativ) | ✓ |
| Selbst-hostbar | ✓ | ✓ | ✓ | ✓ | ✓ |
| Open Source | ✓ (AGPL) | ✓ (GPL) | ✓ (GPL) | ✓ (GPL) | ~ (CE) |
| Ressourcenbedarf | mittel | mittel-hoch | gering | mittel | hoch (mit GitLab) |
| Moderne UI | ✓ | ~ | ✗ | ~ | ✓ |

**Einschätzung**

- **Plane**: Modernste UI, gute Custom Fields und Labels, aktive Entwicklung. Schwachstelle:
  keine nativen wiederkehrenden Tickets (Stand 2025) — Workaround über Templates und manuelle
  Erzeugung oder externe Automatisierung (Webhooks/Cron).
- **OpenProject**: Stärkste Abdeckung für Projektmanagement-Anforderungen, gute
  Custom Fields. Wiederkehrende Aufgaben eingeschränkt umsetzbar. UI veraltet, Einstieg
  aufwändiger. Gut geeignet wenn PM-Funktionen (Gantt, Budgets) ebenfalls benötigt werden.
- **Redmine**: Bewährt und ressourcenschonend. Entscheidende Funktionen (Recurring Tasks,
  Tags, Templates) über Plugins verfügbar — Abhängigkeit von Plugin-Pflege ist ein Risiko.
  UI veraltet, aber stabil.
- **OTOBO** (OSS-Fork von OTRS, Rother OSS): ITIL-orientiertes Service-Management-System
  mit nativer Queue-basierter Zugriffssteuerung — das passt direkt zu unserem Anforderungsprofil.
  Prozess-Engine ermöglicht wiederkehrende und mehrstufige Workflows ohne Plugins. Dynamic Fields
  decken Custom-Field-Bedarf ab. Stärker auf Service-Desk ausgerichtet als auf Projektmanagement,
  was für ISMS-Prozesse (Incidents, Audits, wiederkehrende Aufgaben) gut passt. UI funktional,
  nicht modern.
- **GitLab Issues**: Ausreichend wenn GitLab bereits als VCS-Plattform gewählt wird und
  die Anforderungen einfach sind. Custom Fields und Recurring fehlen in der CE-Edition —
  für vollständiges ISMS-Tracking nicht empfehlenswert ohne EE-Lizenz.

### Offener Punkt: Wiederkehrende Tickets

Kein evaluierter OSS-Kandidat löst wiederkehrende Tickets vollständig und wartungsarm.
Pragmatische Alternativen:

| Ansatz | Aufwand | Abhängigkeit |
|--------|---------|-------------|
| Redmine Recurring Tasks Plugin | gering | Plugin-Aktualität |
| Cron-Job via API (Plane, GitLab) | mittel | eigene Automatisierung |
| Manuelle Erzeugung aus Template | hoch | Disziplin |

---

## Asset Management / CMDB

Anforderungen: Frei definierbare Objekt-Schemata, Pflichtfelder je Typ, Verlinkung zu
Risiko-Tickets, Export für Auditoren, Open Source, selbst-hostbar.

Das Kernproblem klassischer CMDB-Lösungen für ISMS-Zwecke: starre Asset-Typen die auf
IT-Infrastruktur ausgelegt sind. Ein ISMS-Inventar umfasst aber auch Datensätze, Prozesse,
Dienstleister und Räume — das Schema muss frei definierbar sein.

| Kriterium | DataGerry | i-doit (Community) | Ralph | Snipe-IT |
|-----------|:-:|:-:|:-:|:-:|
| Frei definierbare Schemata | ✓ | ✓ | ~ | ✗ |
| Pflichtfelder je Typ | ✓ | ✓ | ~ | ~ |
| ISMS-relevante Asset-Typen | ✓ | ✓ | ✗ (IT-fokus) | ✗ (IT-fokus) |
| Verlinkung zwischen Objekten | ✓ | ✓ | ~ | ✗ |
| REST API (für IT-Integration) | ✓ | ✓ | ✓ | ✓ |
| Export (für Auditoren) | ✓ | ✓ | ~ | ~ |
| Selbst-hostbar | ✓ | ✓ | ✓ | ✓ |
| Open Source | ✓ (GPL) | ~ (Community gratis) | ✓ (Apache) | ✓ (AGPL) |
| Ressourcenbedarf | gering | mittel | gering | gering |
| Moderne UI | ~ | ~ | ~ | ✓ |

**Einschätzung**

- **DataGerry**: Beste Passung für ISMS-Anforderungen. Objekt-Typen und -Schemata sind
  vollständig frei definierbar — Server, Anwendungen, Datensätze, Prozesse, Dienstleister
  lassen sich alle abbilden. REST API ermöglicht Verlinkung mit Risiko-Tickets im Issue
  Tracker. Aktiv entwickelt, schlanke Architektur.
- **i-doit Community**: Umfangreichere CMDB-Funktionen, viele vordefinierte Asset-Typen,
  erweiterbar. Community-Edition funktional ausreichend. Lizenzmodell der kommerziellen
  Erweiterungen beobachten.
- **Ralph**: IT-Asset-Management mit Fokus auf Rechenzentrum und Hardware-Lifecycle.
  Für reine IT-Infrastruktur gut geeignet, für ISMS-Vollabdeckung (Datensätze, Prozesse)
  zu eingeschränkt.
- **Snipe-IT**: Hardware-Asset-Management. Für ISMS-Zwecke zu eingeschränkt — kein
  geeigneter Kandidat für den Anforderungsumfang.

### Verbindung Asset Management → Risikomanagement

Die Verknüpfung zwischen CMDB und Issue Tracker ist konzeptuell zentral, aber technisch
oft manuell: Die Asset-ID aus dem AM-System wird als Referenzfeld im Risiko-Ticket geführt.
Vollautomatische Synchronisation ist möglich (API-zu-API), aber in pragmatischen Setups
nicht zwingend erforderlich — eine konsistente ID-Konvention und Prozessdisziplin reichen
für Auditierbarkeit aus.

---

## Static Site Generator (SSG)

Anforderungen: Markdown, CI-Integration, Suchfunktion, niedrige Einstiegshürde.

| Kriterium | Jekyll | MkDocs Material | Hugo |
|-----------|:-:|:-:|:-:|
| Markdown | ✓ | ✓ | ✓ |
| GitHub/Forgejo CI | ✓ (nativ GH Pages) | ✓ | ✓ |
| Suche | ~ (Plugin) | ✓ (integriert) | ~ (Plugin) |
| Einstiegshürde | mittel (Ruby) | gering (Python) | gering (Binary) |
| Navigation / Struktur | ~ | ✓ | ✓ |
| Versionierte Doku (mehrere Versionen) | ✗ | ~ (mike) | ~ |

**Einschätzung**

- **MkDocs Material**: Beste Kombination aus Einstiegshürde, integrierter Suche und
  Dokumentationsstruktur. Erste Wahl für ISMS-Dokumentation.
- **Jekyll**: Etabliert, GitHub Pages nativ — aber Ruby-Abhängigkeit und schwächere
  Navigation machen es zur zweitbesten Option. Für dieses Projekt bereits im Einsatz.
- **Hugo**: Sehr schnell, keine Laufzeitabhängigkeit (einzelnes Binary). Gute Wahl wenn
  Build-Geschwindigkeit relevant ist oder Ruby/Python vermieden werden sollen.

---

## Zusammenfassung: Empfohlene Kombinationen

| Profil | VCS-Plattform | Issue Tracker | Asset Management | SSG |
|--------|--------------|--------------|-----------------|-----|
| Minimale Abhängigkeiten, selbst-gehostet | Forgejo | Plane | DataGerry | MkDocs Material |
| ITIL-orientiert, Service-Desk-nah | Forgejo | OTOBO | DataGerry | MkDocs Material |
| Alles aus einer Hand | GitLab CE | OTOBO | i-doit Community | GitLab Pages |
| SaaS, kein Selbst-Hosting | GitHub | Plane (Cloud) | DataGerry | GitHub Pages |
| Bewährt, ressourcenschonend | Forgejo | Redmine | DataGerry | MkDocs Material |

Die Kombination **Forgejo + Plane + DataGerry + MkDocs** wird in den Szenarien als
Referenz-Stack verwendet. Die Variante mit **OTOBO** statt Plane ist besonders geeignet
wenn wiederkehrende Tickets und Queue-basierte Zugriffssteuerung im Vordergrund stehen.
