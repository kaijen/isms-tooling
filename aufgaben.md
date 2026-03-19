---
layout: page
title: Aufgaben & Tool-Klassen
permalink: /aufgaben/
---

Die folgende Tabelle beschreibt die wesentlichen ISMS-Prozessaufgaben und ordnet ihnen
generische Tool-Klassen zu. Konkrete Werkzeuge werden in den [Szenarien](../szenarien)
bewertet.

## Tool-Klassen

| Kürzel | Tool-Klasse | Kernfunktion |
|--------|-------------|--------------|
| **VCS** | Version Control System | Versionierung, Branching, Merge/Review-Workflow |
| **SSG** | Static Site Generator | Transformation von Markup zu statischen Webseiten |
| **CI** | CI/CD-Pipeline | Automatisierte Builds und Deployments bei Git-Events |
| **IT** | Issue Tracker | Tickets, Status-Workflows, Felder, Templates, Wiederholung |
| **KI** | KI-Assistent | Textentwürfe, Formulierungen, Konsistenzprüfung |

---

## Aufgaben

### Dokumentenmanagement

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Richtlinien & Verfahren erstellen | VCS, KI | Markdown-Dateien im Repository, KI für Erstentwürfe |
| Freigabe & Versionierung | VCS | Pull Request als Vier-Augen-Prinzip, Merge = Freigabe |
| Dokumentenveröffentlichung | SSG, CI | Automatischer Build bei Merge auf Hauptbranch |
| Änderungsnachweis | VCS | Git-Log und Diffs als revisionssicherer Verlauf |
| Notfall-Zugriff auf Dokumente | VCS | Lokale Clones als dezentrale Offline-Kopien |

---

### Risikomanagement

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Risikoidentifikation | IT, KI | Risiko-Ticket anlegen, KI für Beschreibung und Kategorisierung |
| Risikobewertung | IT | Felder: Wahrscheinlichkeit, Schadenshöhe, Risikowert |
| Statusverfolgung | IT | Status-Tags am Ticket (kein nativer Workflow nötig); History als Audit-Trail |
| Risikobehandlung verknüpfen | IT | Verlinkung zu Behandlungs-Tickets (ggf. anderes Werkzeug) |
| Risikoakzeptanz dokumentieren | IT | Tag `status:akzeptiert`, Kommentar mit Begründung und Genehmiger |
| Risikoreporting | IT | Filteransichten nach Status-Tag, Risikowert, Fälligkeit |
| Risikoregister publizieren | IT | Reporting über Filteransichten im Ticket-System; Export für externe Empfänger (Auditoren, Management) noch offen |

---

### Maßnahmen & Behandlung

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Behandlungsmaßnahmen planen | IT | Maßnahmen-Tickets mit Fälligkeit und Verantwortlichem |
| Statement of Applicability | VCS, KI | Markdown-Dokument im Repository, KI für Begründungstexte |
| Maßnahmenfortschritt verfolgen | IT | Statusübergänge, Kommentare als Nachweis |
| Wirksamkeitsprüfung | IT | Abnahme-Kriterium im Ticket, Review vor Abschluss |

---

### Audit & Bewertung

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Internen Audit planen | IT | Recurring Ticket mit Template und Checkliste |
| Auditnachweise sammeln | IT | Kommentare, Anhänge, Ticket-Verknüpfungen |
| Nichtkonformitäten verwalten | IT | Eigener Ticket-Typ mit Korrekturmaßnahmen-Verlinkung |
| Managementbewertung | IT | Recurring Ticket mit Tagesordnung und Ergebnisprotokoll |

---

### Awareness & Schulung

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Schulungsmaßnahmen planen | IT | Recurring Tickets nach Schulungsplan |
| Teilnahme dokumentieren | IT | Teilnehmerliste im Ticket, Abschluss als Nachweis |
| Schulungsmaterial bereitstellen | SSG | Veröffentlichung über dieselbe Dokumentationssite |
| Inhalte erstellen | KI | Entwurf zielgruppengerechter Inhalte |

---

### Lieferantenmanagement

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Lieferantenbewertung planen | IT | Recurring Ticket je Lieferant |
| Fragebogen-Antworten dokumentieren | IT, VCS | Ergebnisse als Ticket-Kommentar oder Markdown-Datei |
| Vertragsanforderungen verwalten | VCS | Anforderungsdokument im Repository |

---

### Incident Management

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Sicherheitsvorfall erfassen | IT | Incident-Ticket mit definiertem Workflow |
| Analyse & Maßnahmen | IT | Verknüpfte Maßnahmen-Tickets |
| Meldepflicht dokumentieren | IT, VCS | Statusübergang "gemeldet", Nachweis im Ticket oder Dokument |
| Lessons Learned | IT, VCS | Abschlusskommentar oder Dokument im Repository |

---

## Offene Punkte

| Thema | Status |
|-------|--------|
| SSG-Zugriffssteuerung | Offen — zu klären welche Inhalte intern/extern sichtbar sein sollen |
| Risikoregister-Export | Offen — Weg von Ticket-Filteransicht zu auditortauglichem Dokument |
| Ticket-System-Konfiguration | Verschiedene Ansätze je Szenario zu beleuchten |
