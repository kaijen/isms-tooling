---
layout: page
title: Werkzeugkandidaten
permalink: /werkzeuge/
---

Bewertung von Kandidaten je Tool-Klasse anhand der in
[Aufgaben & Tool-Klassen](../aufgaben) abgeleiteten Anforderungen.
Jede Kategorie listet sowohl selbst-gehostete Open-Source-Lösungen als auch relevante
Cloud-/SaaS-Alternativen. Die grundsätzliche Abwägung zwischen beiden Betriebsmodellen
ist am Ende dieses Dokuments beschrieben.

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

**Cloud-Alternativen**: GitHub.com (SaaS), GitLab.com (SaaS), Codeberg.org
(Forgejo-basiert, gemeinnützig, kostenlos für OSS und kleine Organisationen).

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
- **OTOBO** (OSS-Fork von OTRS, Rother OSS): Stärkster Kandidat wenn Queue-basierte
  Zugriffssteuerung und wiederkehrende Tickets Priorität haben. Queue-Hierarchie bildet
  Risikoebenen (Strategisch / Operativ / Technisch) nativ ab — Zugriffssteuerung, Ebene
  und Zuständigkeit werden durch die Queue-Zuordnung in einem Schritt geregelt. Prozess-Engine
  für wiederkehrende Workflows ohne Plugins. Dynamic Fields für Custom-Field-Bedarf.
  Service-Desk-Ausrichtung passt gut zu ISMS-Prozessen (Incidents, Audits, Meldepflichten).
  UI funktional, nicht modern.
- **GitLab Issues**: Ausreichend wenn GitLab bereits als VCS-Plattform gewählt wird und
  die Anforderungen einfach sind. Custom Fields und Recurring fehlen in der CE-Edition —
  für vollständiges ISMS-Tracking nicht empfehlenswert ohne EE-Lizenz.

**Cloud-Alternativen**: Plane Cloud (SaaS, gehostete Plane-Instanz), Jira Cloud
(Atlassian, proprietär, weit verbreitet, starke Integration mit Confluence),
Linear (SaaS, moderne UI, kein Self-Hosting). Keiner der Cloud-Kandidaten ist Open Source;
Plane Cloud ist die einzige Option mit self-hosted Fallback ohne Datenmigration.

---

## Kanban-Board (Projektsteuerung)

Anforderungen: Karten-Templates, Checklisten, Swimlanes, Fälligkeiten, Open Source,
selbst-hostbar. Kanban-Boards ergänzen den Issue Tracker — sie ersetzen ihn nicht.

| Kriterium | Wekan | Kanboard | Planka |
|-----------|:-:|:-:|:-:|
| Karten-Templates | ✓ | ~ | ✗ |
| Checklisten auf Karten | ✓ | ✓ | ✓ |
| Swimlanes | ✓ | ✓ | ~ |
| Fälligkeiten | ✓ | ✓ | ✓ |
| Labels / Tags | ✓ | ✓ | ✓ |
| Zugriffssteuerung (Board-Ebene) | ✓ | ✓ | ✓ |
| Selbst-hostbar | ✓ | ✓ | ✓ |
| Open Source | ✓ (MIT) | ✓ (MIT) | ~ (Fair-Code, internes Hosting kostenfrei) |
| Ressourcenbedarf | mittel | gering | gering |
| Moderne UI | ~ | ✗ | ✓ |

**Einschätzung**

- **Wekan**: Funktional stärkster OSS-Kandidat mit nativen Karten-Templates und Swimlanes.
  Templates ermöglichen standardisierte Initiativstrukturen (Gap-Analyse, Awareness-Kampagne)
  ohne Wiederholungsaufwand. UI wirkt veraltet, ist aber vollständig. Aktive Entwicklung.
- **Kanboard**: Sehr leichtgewichtig, minimale Infrastruktur. Checklisten und Swimlanes
  vorhanden, Templates rudimentär. Gut für kleine Teams mit einfachen Anforderungen.
**Cloud-Alternativen**: Trello (Atlassian, proprietär, weit verbreitet),
Asana (proprietär, SaaS). Beide ohne Self-Hosting-Option und ohne OSS-Lizenz —
für ISMS-Zwecke nur akzeptabel wenn Datenschutzanforderungen über DPA abgedeckt sind.

- **Planka**: Modernste UI, v2.0 bringt Custom Fields, mehrere Task-Listen pro Karte und
  OIDC-SSO. Lizenz: Fair-Code (PLANKA Community License v1.1) — internes Selbst-Hosting für
  die eigene Organisation ist explizit kostenfrei erlaubt; eine kommerzielle Lizenz wird nur
  fällig wenn Planka als Service für externe Dritte betrieben wird. Für ISMS-Eigennutzung
  damit kein Lizenzproblem. Verbleibende Schwachstelle: Karten-Templates fehlen weiterhin
  (offenes Issue #1397, kein Roadmap-Commitment, Stand März 2026) — damit für Template-
  abhängige Workflows kein geeigneter Kandidat.

---

## Wiki

Anforderungen: Markdown als primäres Format, REST/GraphQL-API für Integration, Open Source,
selbst-hostbar.

**Abgrenzung zum SSG**: Der SSG veröffentlicht freigegebene Dokumente aus dem Git-Repository
— der Freigabeprozess ist der PR-Workflow. Ein Wiki ermöglicht direktes kollaboratives
Bearbeiten ohne diesen Umweg. Beide Klassen schließen sich nicht aus; sie erfüllen
unterschiedliche Zwecke:

| | SSG | Wiki |
|--|-----|------|
| Workflow | Git-PR-Freigabe | Direktes Bearbeiten |
| Zielgruppe | Lesende (Mitarbeitende, Auditoren) | Mitschreibende (Wissensaufbau) |
| ISMS-Einsatz | Freigegebene Richtlinien, Nachweise | Awareness-Inhalte, interne Handbücher |
| Versionierung | Git-History | Interne Wiki-History |

| Kriterium | Wiki.js | BookStack | DokuWiki |
|-----------|:-:|:-:|:-:|
| Markdown (nativ) | ✓ | ✓ | ~ (Plugin) |
| REST API | ~ (GraphQL) | ✓ | ~ (Plugin) |
| Git-Backend (Inhalt in Git) | ✓ | ✗ | ✗ |
| Strukturierung (Hierarchie) | ✓ | ✓ (Bücher/Kapitel) | ✓ (Namespaces) |
| Zugriffssteuerung | ✓ | ✓ | ✓ |
| OIDC / SSO | ✓ | ✓ | ~ (Plugin) |
| Selbst-hostbar | ✓ | ✓ | ✓ |
| Open Source | ✓ (AGPL) | ✓ (MIT) | ✓ (GPL) |
| Ressourcenbedarf | mittel | mittel | gering |
| Moderne UI | ✓ | ✓ | ✗ |

**Einschätzung**

- **Wiki.js**: Markdown-nativ, AGPL, aktive Entwicklung. Herausragendes Feature für ISMS:
  optionales Git-Backend — Wikiseiten werden in einem Git-Repository gespeichert und sind
  damit versioniert, klonbar und in den VCS-Workflow integrierbar. GraphQL-API statt REST
  ist gewöhnungsbedürftig, aber vollständig.
- **BookStack**: Klarste Hierarchie (Bücher → Kapitel → Seiten) — gut geeignet für
  strukturierte ISMS-Dokumentation wie Handbücher und Awareness-Material. REST-API ist
  vollständig und gut dokumentiert. MIT-Lizenz. Kein Git-Backend.
- **DokuWiki**: Bewährt und extrem ressourcenschonend (dateibasiert, keine Datenbank).
  Markdown und API nur über Plugins — Abhängigkeit von Plugin-Pflege. UI veraltet.
  Für neue Setups kein bevorzugter Kandidat.

**Cloud-Alternativen**: Confluence Cloud (Atlassian, proprietär, Marktstandard in
Unternehmensumgebungen — hohe Verbreitung erleichtert Akzeptanz, aber Vendor Lock-in
und Datenschutzfragen sind zu klären), GitBook (Markdown-nativ, API, kostenlose Tier für
kleine Teams, SaaS-only), Notion (proprietär, kein Markdown-Export ohne Verluste).

---

## Asset Management / CMDB

Anforderungen: Frei definierbare Objekt-Schemata, Pflichtfelder je Typ, Verlinkung zu
Risiko-Tickets, Export für Auditoren, Open Source, selbst-hostbar.

Das Kernproblem klassischer CMDB-Lösungen für ISMS-Zwecke: starre Asset-Typen die auf
IT-Infrastruktur ausgelegt sind. Ein ISMS-Inventar umfasst aber auch Datensätze, Prozesse,
Dienstleister und Räume — das Schema muss frei definierbar sein.

Der Fokus liegt auf ISMS-spezifischem Asset-Management — nicht auf IT-CMDB. Die IT-Abteilung
betreibt ihre eigene CMDB (i-doit, NetBox o.ä.); das ISMS-Inventar erfasst Informationsassets,
Prozesse, Organisationseinheiten und Dienstleister. Wo sinnvoll, kann eine Referenz auf die
IT-CMDB als Bezugsobjekt im Risiko-Ticket eingetragen werden — eine Integration ist nicht
zwingend erforderlich.

| Kriterium | DataGerry |
|-----------|:-:|
| Frei definierbare Schemata | ✓ |
| Pflichtfelder je Typ konfigurierbar | ✓ |
| ISMS-relevante Asset-Typen abbildbar | ✓ |
| Verlinkung zwischen Objekten | ✓ |
| REST API | ✓ |
| Export (für Auditoren) | ✓ |
| Selbst-hostbar | ✓ |
| Open Source | ✓ (GPL) |
| Ressourcenbedarf | gering |

**Einschätzung**

- **DataGerry**: Einziger evaluierter Kandidat mit vollständig freien Objekt-Schemata und
  explizitem ISMS-Fokus. Objekt-Typen für Informationsassets, Prozesse, Dienstleister und
  Organisationseinheiten lassen sich ohne Anpassungsaufwand definieren. REST API ermöglicht
  manuelle oder automatisierte Verlinkung mit dem Issue Tracker. Schlanke Architektur,
  aktiv entwickelt.

### Verbindung Asset Management → Risikomanagement

Risiko-Tickets verwenden ein optionales Feld **Bezugsobjekt** mit Typ-Auswahl (Asset,
Prozess, Organisationseinheit, Externer Akteur, Regulatorisch, keines). Nur Asset-Referenzen
zeigen auf die CMDB — andere Typen werden freitextlich oder als interne Verlinkung geführt.

Die technische Verknüpfung ist manuell: Die Asset-ID aus dem AM-System wird als Referenzfeld
im Risiko-Ticket eingetragen. Vollautomatische Synchronisation ist möglich (API-zu-API), aber
in pragmatischen Setups nicht zwingend — eine konsistente ID-Konvention reicht für
Auditierbarkeit aus.

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

| Profil | VCS-Plattform | Issue Tracker | Kanban | Wiki | Asset Management | SSG |
|--------|--------------|--------------|--------|------|-----------------|-----|
| Minimale Abhängigkeiten, selbst-gehostet | Forgejo | Plane | Wekan | BookStack | DataGerry | MkDocs Material |
| ITIL-orientiert, Service-Desk-nah | Forgejo | OTOBO | Wekan | Wiki.js | DataGerry | MkDocs Material |
| Alles aus einer Hand | GitLab CE | OTOBO | Wekan | BookStack | DataGerry | GitLab Pages |
| SaaS, kein Selbst-Hosting | GitHub | Plane (Cloud) | Wekan (Cloud) | BookStack | DataGerry | GitHub Pages |
| Bewährt, ressourcenschonend | Forgejo | Redmine | Kanboard | DokuWiki | DataGerry | MkDocs Material |

Die Kombination **Forgejo + Plane + DataGerry + MkDocs** wird in den Szenarien als
Referenz-Stack verwendet. Die Variante mit **OTOBO** statt Plane ist besonders geeignet
wenn wiederkehrende Tickets und Queue-basierte Zugriffssteuerung im Vordergrund stehen.

---

## Self-hosted vs. SaaS

Die Wahl des Betriebsmodells ist für ein ISMS keine rein technische Entscheidung —
sie hat direkte Auswirkungen auf Datenschutz, Nachweisführung und Betriebsaufwand.

### Bewertungsmatrix

| Kriterium | Self-hosted | SaaS |
|-----------|-------------|------|
| **Datensouveränität** | Vollständige Kontrolle | Daten beim Anbieter; DPA erforderlich |
| **DSGVO / NIS2** | Einfacher nachweisbar | Auftragsverarbeitungsvertrag, Drittlandtransfer prüfen |
| **Betriebsaufwand** | Hoch (Updates, Backup, Monitoring) | Gering (Anbieter verantwortet Betrieb) |
| **Verfügbarkeit** | Abhängig von eigener Infrastruktur | Typisch höhere SLA |
| **Kosten** | Infrastruktur + Personalaufwand | Nutzungsgebühren, vorhersehbar |
| **Vendor Lock-in** | Gering (offene Formate, migrierbar) | Hoch (Export oft eingeschränkt) |
| **Anpassbarkeit** | Vollständig | Begrenzt auf Anbieter-Features |
| **Audit-Zugang** | Direkter Zugriff auf alle Logs | Logs vom Anbieter, ggf. eingeschränkt |

### Besonderheit für ISMS-Daten

Nicht alle ISMS-Inhalte sind gleich schutzbedürftig. Eine differenzierte Betrachtung
nach Inhalt ist pragmatischer als eine pauschale Entscheidung:

| Inhalt | Schutzbedarf | SaaS vertretbar? |
|--------|-------------|-----------------|
| Freigegebene Richtlinien, Awareness | Gering | Ja, auch öffentlich |
| Verfahrensanweisungen, Handbücher | Mittel | Ja, mit DPA |
| Maßnahmen-Tracking, Audit-Nachweise | Mittel–Hoch | Mit DPA und EU-Hosting |
| Risikoregister (operativ, technisch) | Hoch | Nur mit starker Vertragsbasis |
| Strategisches Risikoregister | Sehr hoch | Nein — Self-hosted empfohlen |
| Incident-Details, Schwachstellen | Sehr hoch | Nein — Self-hosted empfohlen |

### Hybride Strategie

Die pragmatische Antwort für die meisten Organisationen ist kein Entweder-Oder:

```
SaaS (GitHub, Confluence)     →  Dokumentation, Policies, Wiki
Self-hosted (OTOBO, DataGerry) →  Risiken, Incidents, Asset-Inventar
```

VCS und SSG können in SaaS betrieben werden wenn nur freigegebene, weniger
schutzbedürftige Inhalte dort landen. Das Risikoregister und Incident-Tracking
bleiben self-hosted unter eigener Kontrolle.

### 100% Cloud

Für Organisationen ohne eigene IT-Infrastruktur oder ohne Bereitschaft zum Betrieb
eigener Server ist ein vollständiger SaaS-Stack eine legitime und pragmatische Wahl.
Die Voraussetzungen sind nicht technischer, sondern vertraglicher Natur:

- **Auftragsverarbeitungsvertrag (AVV/DPA)** mit jedem Anbieter
- **EU-Hosting** bevorzugt oder explizit vereinbart (DSGVO Art. 46)
- **Datenportabilität** sicherstellen: Export-Formate je Tool prüfen, bevor man
  sich bindet — Vendor Lock-in ist das Hauptrisiko

Ein vollständiger Cloud-Stack könnte aussehen:

| Tool-Klasse | Kandidat | Hinweis |
|-------------|---------|---------|
| VCS + CI + SSG | GitHub.com + GitHub Pages | Ausgereift, weit verbreitet |
| Issue Tracker | Plane Cloud | SaaS mit self-hosted Fallback ohne Datenmigration |
| Kanban | Plane Cloud | In Plane integriert |
| Wiki | Confluence Cloud | Marktstandard, hohe Akzeptanz; oder GitBook für schlankere Option |
| Asset Management | — | Schwachstelle: kein leichtgewichtiger SaaS-CMDB mit freien Schemata verfügbar |

**Asset Management** ist der einzige blinde Fleck im 100%-Cloud-Szenario. Verfügbare
Optionen sind entweder IT-fokussiert (Freshservice, ServiceNow — zu schwer und zu teuer)
oder nicht auf ISMS-Informationsassets ausgelegt. Pragmatischer Workaround: Asset-Register
als strukturiertes Spreadsheet (Google Sheets, Microsoft 365) oder als Markdown-Tabellen
im VCS — auditierbar, ohne Zusatzwerkzeug.

**Für Auditoren** ist ein vollständiger SaaS-Stack unproblematisch, solange
Nachweisführung und Zugriffskontrolle sauber umgesetzt sind. Die Frage ist nicht
"wo liegen die Daten" sondern "wer hat Zugriff und was ist dokumentiert".

### Empfehlung je Zielgruppe

| Zielgruppe | Empfehlung |
|-----------|------------|
| KMU ohne IT-Infrastruktur | 100% Cloud mit DPA; Asset-Register als Spreadsheet oder VCS |
| Supplier mit Zertifizierungspflicht | 100% Cloud oder Hybrid; DPA und EU-Hosting prüfen |
| NIS2-betroffen, eigenes IT-Team | Hybrid oder self-hosted für Risiken und Incidents |
| Modernisierer (von SharePoint) | SaaS als Einstieg; Migration zu self-hosted optional |
