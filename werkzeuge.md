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

| Kriterium | Plane | OpenProject | Redmine | GitLab Issues |
|-----------|:-:|:-:|:-:|:-:|
| Issue-Templates | ✓ | ✓ | ~ (Plugin) | ✓ |
| Wiederkehrende Tickets | ✗ | ~ (manuell) | ✓ (Plugin) | ✗ |
| Benutzerdefinierte Felder | ✓ | ✓ | ✓ | ✗ (CE) |
| Tags / Labels | ✓ | ~ | ~ (Plugin) | ✓ |
| Ticket-Verlinkung | ✓ | ✓ | ✓ | ✓ |
| Filteransichten | ✓ | ✓ | ✓ | ~ |
| Zugriffssteuerung (Projekte) | ✓ | ✓ | ✓ | ✓ |
| Selbst-hostbar | ✓ | ✓ | ✓ | ✓ |
| Open Source | ✓ (AGPL) | ✓ (GPL) | ✓ (GPL) | ~ (CE) |
| Ressourcenbedarf | mittel | mittel-hoch | gering | hoch (mit GitLab) |
| Moderne UI | ✓ | ~ | ✗ | ✓ |

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

| Profil | VCS-Plattform | Issue Tracker | SSG |
|--------|--------------|--------------|-----|
| Minimale Abhängigkeiten, selbst-gehostet | Forgejo | Plane | MkDocs Material |
| Alles aus einer Hand | GitLab CE | GitLab Issues (+ Redmine für Recurring) | GitLab Pages |
| SaaS, kein Selbst-Hosting | GitHub | Plane (Cloud) | GitHub Pages |
| Bewährt, ressourcenschonend | Forgejo | Redmine | MkDocs Material |

Die Kombination **Forgejo + Plane + MkDocs** wird in den Szenarien als Referenz verwendet,
da sie Open-Source-Anforderungen vollständig erfüllt und die geringsten Infrastruktur-
abhängigkeiten hat.
