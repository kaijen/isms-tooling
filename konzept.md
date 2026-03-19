---
layout: page
title: Konzept & Anforderungen
permalink: /konzept/
---

## Kontext

Die NIS2-Richtlinie verpflichtet eine wachsende Zahl von Organisationen zur Einführung eines
Informationssicherheits-Managementsystems (ISMS). Betroffen sind nicht nur die direkt adressierten
Unternehmen, sondern zunehmend auch deren Lieferanten, die über Vertragsbedingungen oder
Zertifizierungsanforderungen in die Pflicht genommen werden.

Viele dieser Organisationen stehen vor ähnlichen Ausgangssituationen:

- **Neueinstieg**: Kein ISMS vorhanden, Handlungsdruck durch NIS2 oder Kundenanforderungen
- **Modernisierung**: Gewachsene Strukturen aus Word-Dokumenten, SharePoint-Ablagen und
  E-Mail-Freigaben, die weder skalieren noch auditierbar sind
- **Supplier-Position**: Begrenzte Ressourcen, aber Nachweispflicht gegenüber Auftraggebern

Gemeinsames Ziel aller drei Ausgangslagen ist **Zertifizierungsreife nach ISO 27001** — erreichbar
mit minimalem Budget, ohne proprietäre ISMS-Software und ohne jahrelange Einführungsprojekte.

---

## Leitprinzipien

### 1. Versionskontrolle und Freigaben mit Git

Alle ISMS-Dokumente — Richtlinien, Verfahrensanweisungen, Risikoregister, Erklärungen zur
Anwendbarkeit — werden in einem Git-Repository verwaltet.

Git liefert damit kostenlos, was kommerzielle Dokumentenmanagementsysteme als Premium-Feature
verkaufen:

- **Vollständige Versionshistorie** jedes Dokuments
- **Nachvollziehbare Freigaben** über Pull Requests (Vier-Augen-Prinzip durch Review und Merge)
- **Vergleichbarkeit** von Versionen durch Diffs

Wo eine Web-UI benötigt wird, bieten selbst-gehostete Plattformen wie Gitea oder GitLab eine
zugängliche Oberfläche, ohne das Grundprinzip aufzugeben.

### 2. Dokumentenveröffentlichung per Static Site Generator

Was im Git-Repository liegt, wird automatisch veröffentlicht. Ein Static Site Generator (Jekyll,
Hugo, MkDocs) transformiert Markdown-Dokumente bei jedem Merge auf den Hauptbranch in eine
durchsuchbare, verlinkte Website.

Vorteile:

- Aktuelle Dokumente sind für alle Mitarbeitenden jederzeit zugänglich
- Der Veröffentlichungsprozess ist transparent und automatisiert (CI/CD-Pipeline)
- Auditoren erhalten eine strukturierte Übersicht ohne Zugang zum Repository

Der CI/CD-Lauf ist selbst ein Nachweis: Dokumente, die nicht freigegeben sind, erscheinen nicht
auf der Site.

### 3. Git-Clones als dezentrales Notfall-Backup

Jeder vollständige Clone eines Git-Repositorys enthält die gesamte History. Damit ist jeder
Arbeitsplatz mit lokalem Clone ein Backup — ohne separate Backup-Infrastruktur, ohne Zusatzkosten.

Für Notfallszenarien (Ausfall des zentralen Servers) bedeutet das: Wiederherstellung ist trivial,
der Stand ist aktuell, und das Backup-Konzept für die ISMS-Dokumentation ist durch die normale
Arbeitsweise bereits erfüllt.

### 4. Aufgabenplanung mit Ticket-Systemen

Wiederkehrende ISMS-Aufgaben — interne Audits, Managementbewertungen, Schulungen,
Lieferantenbewertungen — werden als Tickets geplant und nachverfolgt. Entscheidend sind:

- **Templates**: Standardisierte Aufgaben mit vordefinierten Checklisten und Akzeptanzkriterien
- **Wiederkehrende Tickets**: Automatische Erzeugung nach Zeitplan, kein manueller Aufwand
- **Nachweisführung**: Abgeschlossene Tickets mit Kommentaren und Anhängen sind Audit-Nachweise

### 5. Risikomanagement als endlicher Automat

Risiken werden als Tickets modelliert, die einen definierten Lebenszyklus durchlaufen:

```
identifiziert → bewertet → behandlung_geplant → in_behandlung → akzeptiert / geschlossen
```

Der Lebenszyklus wird **nicht über native Workflow-Engines** des Ticket-Systems abgebildet,
sondern über Tags/Labels und Attribute. Das hat einen entscheidenden Vorteil: Die Lösung
funktioniert in nahezu jedem Ticket-System ohne aufwändige Workflow-Konfiguration.

Der Audit-Trail entsteht durch die Attribut-History des Tickets — jedes Ticket-System
protokolliert, wer wann welchen Tag oder Feldwert geändert hat.

**Attribute am Risiko-Ticket:**

| Attribut | Typ | Zweck |
|----------|-----|-------|
| `status:identifiziert` / `status:bewertet` / … | Tag | Aktueller Zustand im Lebenszyklus |
| Eintrittswahrscheinlichkeit | Feld (Zahl/Stufe) | Bewertung |
| Schadenshöhe | Feld (Zahl/Stufe) | Bewertung |
| Risikowert | Feld (berechnet oder manuell) | Priorisierung, Reporting |
| Asset-Referenz | Feld / Verlinkung | Scope |
| Verantwortlicher | Assignee | Steuerung |
| Fälligkeit Neubewertung | Datum-Feld | Wiedervorlage |

**Risikoebenen und Zugriffssteuerung**: Risiken werden nach Ebene in separate Queues
aufgeteilt. Die Queue definiert gleichzeitig Risikoebene, Zuständigkeitskreis und
Sichtbarkeit — ohne zusätzliche Attribute:

```
Risiken/
├── Strategisch     → CISO, Geschäftsführung
├── Operativ        → Prozessverantwortliche, Abteilungsleiter
└── Technisch       → IT-Betrieb, Systemverantwortliche
```

Eskalationspfade folgen der Queue-Hierarchie. Strategische Risiken bleiben für technisches
Personal unsichtbar — eine häufige und legitime Anforderung. Das Bezugsobjekt-Modell ist
orthogonal zur Queue-Ebene: Ein strategisches Risiko kann einen Asset-Bezug haben oder
keinen, unabhängig von seiner Einordnung.

Diese Anforderung bevorzugt Ticket-Systeme mit nativem Queue-Konzept (OTOBO) gegenüber
projektbasierter Zugriffssteuerung (Plane), wo dieselbe Struktur mit mehr Konfigurationsaufwand
nachgebaut werden müsste.

**Bezugsobjekt statt Pflicht-Asset**: ISO 27001:2022 fordert keine asset-zentrierte
Risikobeurteilung. Risiken mit erzwungener Asset-Zuordnung ("das Asset ist der Prozess X")
erzeugen Overhead ohne Erkenntnisgewinn. Das Risiko-Ticket enthält stattdessen ein optionales
Feld **Bezugsobjekt** mit flexiblem Typ:

| Typ | Beispiele |
|-----|-----------|
| Asset | Server, Anwendung, Datensatz (Referenz auf CMDB) |
| Prozess | Patch-Management, Onboarding, Incident Response |
| Organisationseinheit | IT-Betrieb, Einkauf, Geschäftsführung |
| Externer Akteur | Schlüssellieferant, Cloud-Provider, Auftraggeber |
| Regulatorisch | NIS2-Meldepflicht, DSGVO Art. 32, Vertragsklausel |
| — | Organisationales Risiko ohne spezifischen Anker |

Ein leeres Bezugsobjekt ist eine bewusste, dokumentierte Entscheidung — keine Lücke.
Asset-referenzierte Risiken profitieren von der Verlinkung zur CMDB; organisationale Risiken
verlieren nichts dadurch, dass sie keinen Asset-Anker haben.

**Verknüpfung mit Behandlung**: Behandlungsmaßnahmen werden als eigene Tickets erfasst —
gegebenenfalls in einem anderen Werkzeug — und mit dem Risiko-Ticket verknüpft. Risiko- und
Behandlungs-Tracking sind logisch verbunden, aber werkzeugmäßig unabhängig. Das verhindert
Vendor Lock-in und erlaubt, das jeweils geeignetste Werkzeug zu wählen.

**Reporting**: Risikoberichte entstehen durch Filterung nach Status-Tags, Risikowert oder
Fälligkeit — ohne separates Reporting-Tool. KI kann auf Basis der Attribute prüfen, ob ein
Statusübergang vollständig dokumentiert ist, bevor der Tag gesetzt wird.

---

## Anforderungen an Werkzeuge

Aus den Leitprinzipien ergeben sich folgende Anforderungen:

### Dokumentenmanagement
- Git-Backend (oder nativer Git-Workflow)
- Markdown als primäres Format
- Branch-basierter Review-Prozess
- Integration mit CI/CD für automatische Veröffentlichung

### Ticket-System
- Templates für Aufgaben und Risiken
- Wiederkehrende Tickets (zeitgesteuert)
- Benutzerdefinierte Felder (für Risikomaße)
- Konfigurierbare Statusübergänge
- Verlinkung zwischen Tickets
- Filterung und Listenansichten für Reporting
- Zugriffssteuerung per Queue oder Projekt
- Open Source, selbst-hostbar

Die Konfiguration eines Ticket-Systems für ISMS-Zwecke ist echter Initialaufwand: Workflows,
Custom Fields und Templates müssen eingerichtet und gepflegt werden. Dieser Aufwand ist
einmalig und zahlt sich durch konsistente Nachweisführung aus — er sollte aber in der
Einführungsplanung explizit eingeplant werden.

### Asset Management / CMDB
- Frei definierbare Objekt-Schemata (keine starren Asset-Typen)
- Pflichtfelder je Asset-Typ konfigurierbar (Verantwortlicher, Schutzbedarf, Standort)
- Verlinkung zu Risiko-Tickets (über ID oder API-Integration)
- Filterung und Export für Auditor-Zugriff
- Open Source, selbst-hostbar

Asset-Management ist das am häufigsten unterschätzte Teilproblem des ISMS. Ohne
strukturiertes Inventar mit klaren Eigentümern und Schutzbedarfen ist eine valide
Risikobeurteilung nicht möglich. Die Flexibilität des Schemas ist entscheidend:
ISMS-Assets umfassen nicht nur IT-Infrastruktur, sondern auch Datensätze, Prozesse,
Dienstleister und Räumlichkeiten — eine starre CMDB genügt nicht.

### Static Site Generator
- Markdown-kompatibel
- CI/CD-Integration (GitHub Actions, Gitea Actions)
- Durchsuchbare Ausgabe
- Niedrige Einstiegshürde für Inhaltsredaktion

---

## Zertifizierungsreife als Gestaltungsprinzip

Die Werkzeugwahl folgt einer zentralen Frage:

> **Was muss ein Auditor sehen können — und wie entsteht dieser Nachweis aus dem normalen
> Betrieb heraus, ohne Zusatzaufwand?**

Konkret bedeutet das:

| ISO 27001 Anforderung | Nachweis im vorgeschlagenen Ansatz |
|-----------------------|-------------------------------------|
| Dokumentenlenkung (7.5) | Git-History, Commit-Metadaten, Merge-Records |
| Freigabeprozess | Pull Request mit Review und Merge durch Berechtigten |
| Risikobeurteilung (6.1) | Risiko-Tickets mit Attributen und Statusverlauf |
| Risikobehandlung (6.1.3) | Verknüpfte Behandlungs-Tickets, Statusübergänge |
| Interne Audits (9.2) | Audit-Tickets mit Checklisten, Befunden, Abschluss |
| Managementbewertung (9.3) | Recurring Ticket mit Tagesordnung und Ergebnisprotokoll |
| Awareness (7.3) | Schulungs-Tickets mit Teilnahmenachweis |
| Notfallvorsorge (8.1) | Git-Clones als dokumentiertes Backup-Konzept |
| Zugriffssteuerung (A.5.15) | Queue-Hierarchie im Ticket-System je Risikoebene und Zuständigkeitsbereich |

Der Ansatz funktioniert nur, wenn Konventionen eingehalten werden: Commit-Messages müssen
aussagekräftig sein, Statusübergänge müssen begründet werden, Templates müssen gepflegt werden.
Diese Disziplin ist keine Schwäche des Ansatzes — sie entspricht genau dem, was ISO 27001 als
gelebtes Managementsystem fordert.

### KI-Unterstützung als Disziplin-Verstärker

Die geforderte Disziplin ist der häufigste Grund, warum pragmatische Ansätze in der Praxis
scheitern. KI-Werkzeuge senken diese Hürde erheblich — nicht indem sie die Anforderungen
umgehen, sondern indem sie den Aufwand für regelkonforme Ausführung minimieren:

| Aufgabe | KI-Unterstützung |
|---------|-----------------|
| Commit-Messages | Generierung aus Diff — aussagekräftig, konsistent |
| Risikobeschreibungen | Entwurf aus Asset und Bedrohungskontext |
| Ticket-Templates befüllen | Vorausfüllen aus natürlichsprachlicher Beschreibung |
| Statusübergang begründen | Formulierungsvorschlag auf Basis des Ticket-Inhalts |
| Richtlinien-Entwürfe | Erstellung nach ISO-27001-Struktur, angepasst an Kontext |
| Review-Kommentare | Prüfung auf Vollständigkeit und Normkonformität |

KI ersetzt dabei keine Entscheidung — Risikobewertungen, Freigaben und Statusübergänge bleiben
menschliche Verantwortung. Aber sie beseitigt die Reibung zwischen "ich weiß was zu tun ist"
und "ich habe es auch korrekt dokumentiert".
