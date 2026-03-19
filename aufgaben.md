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
| **AM** | Asset Management / CMDB | Inventar mit frei definierbaren Schemata, Verlinkung zu Risiken |
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
| Risikoregister publizieren | IT | Reporting über Filteransichten im Ticket-System |

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

### Asset Management

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Asset-Inventar aufbauen | AM | Objekte je Asset-Typ mit frei definierbarem Schema |
| Asset-Typen definieren | AM | Schemata für Server, Anwendungen, Datensätze, Prozesse, Standorte |
| Eigentümer & Klassifikation | AM | Felder: Verantwortlicher, Schutzbedarf (Vertraulichkeit, Integrität, Verfügbarkeit) |
| Assets mit Risiken verknüpfen | AM, IT | Asset-ID als optionales Bezugsobjekt im Risiko-Ticket |
| Asset-Inventar aktuell halten | AM, IT | Änderungsticket bei Lifecycle-Ereignissen (Inbetriebnahme, Außerbetriebnahme) |
| Asset-Inventar publizieren | AM | Filteransicht oder Export für Auditoren |

**Bezugsobjekt statt Pflicht-Asset**: Nicht jedes Risiko lässt sich sinnvoll mit einem
Asset verknüpfen. Schlüsselpersonenabhängigkeit, mangelndes Sicherheitsbewusstsein oder
regulatorische Risiken haben keinen natürlichen Asset-Anker — eine erzwungene Zuordnung
("das Asset ist der Prozess") erzeugt Overhead ohne Erkenntnisgewinn.

Das Risiko-Ticket verwendet daher ein optionales Feld **Bezugsobjekt** mit Typ-Auswahl:
Asset (CMDB-Referenz), Prozess, Organisationseinheit, Externer Akteur, Regulatorisch oder
keines. Ein leeres Feld ist eine bewusste Entscheidung, keine Lücke — und wird als solche
im Ticket dokumentiert.

Das Asset-Inventar bleibt trotzdem zentral: Es ist die Grundlage für asset-bezogene
Risikobeurteilungen und liefert den Kontext für Schutzbedarfsanalysen. Die Verknüpfung
ist aber optional, nicht erzwungen.

---

### Incident Management

| Aufgabe | Tool-Klassen | Umsetzung |
|---------|-------------|-----------|
| Sicherheitsvorfall erfassen | IT | Incident-Ticket mit definiertem Workflow |
| Analyse & Maßnahmen | IT | Verknüpfte Maßnahmen-Tickets |
| Meldepflicht dokumentieren | IT, VCS | Statusübergang "gemeldet", Nachweis im Ticket oder Dokument |
| Lessons Learned | IT, VCS | Abschlusskommentar oder Dokument im Repository |

---

