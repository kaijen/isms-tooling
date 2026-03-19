# Offene Punkte

## Konzept

- [ ] **Risikoebenen / Queue-Struktur**: Queue-Hierarchie (Strategisch / Operativ / Technisch)
      weiter ausarbeiten — Eskalationspfade, Übergabeprozesse zwischen Ebenen, Berichtslinien
- [ ] **SSG-Zugriffssteuerung**: Welche Inhalte intern/extern sichtbar? Authentifizierung
      vor statischen Seiten (z.B. nur im VPN erreichbar vs. öffentlich)?
- [ ] **Risikoregister-Export**: Weg von Ticket-Filteransicht zu auditortauglichem Dokument
- [ ] **Meldepflichten NIS2**: Fristen (24h Erstmeldung, 72h Folgemeldung) als Ticket-Workflow
      abbilden — Statusübergänge, Eskalation, Nachweisführung
- [ ] **Metriken / ISMS-Kennzahlen**: Welche KPIs lassen sich aus Ticket-Daten ableiten?
      (offene Risiken je Ebene, Behandlungsquote, Audit-Findings, Schulungsquote)
- [ ] **Backup Ticket-System**: Git-Clones sichern Dokumentation — was sichert die
      Ticket-Daten? Export-Strategie je Werkzeug klären

## Werkzeuge

- [ ] **Wiederkehrende Tickets**: Kein OSS-Kandidat löst das vollständig — Ansatz je
      Szenario konkretisieren. Bekannte Alternativen:
      - OTOBO Prozess-Engine (nativ, kein Plugin)
      - Redmine Recurring Tasks Plugin (abhängig von Plugin-Pflege)
      - Cron-Job via API (Plane, GitLab) — eigene Automatisierung nötig
      - Manuelle Erzeugung aus Template — Disziplinfrage
- [ ] **Ticket-System-Konfiguration**: Verschiedene Ansätze je Szenario beleuchten —
      Initialaufwand für Workflows, Custom Fields und Templates einplanen
- [ ] **KI-Tool-Auswahl**: KI als Tool-Klasse benannt, aber nicht bewertet — Kandidaten
      (cloud-basiert vs. lokal/Ollama) und Datenschutzimplikationen für ISMS-Inhalte
- [ ] **Integration zwischen Tools**: Wie viel API-Automatisierung ist pragmatisch?
      DataGerry ↔ Issue Tracker, VCS ↔ CI ↔ SSG — Mindestintegration vs. Vollautomatisierung
- [ ] **Starter-Templates**: Richtlinien- und Verfahrensvorlagen als Repository-Inhalt
      bereitstellen — Umfang und Normkonformität klären

## Szenarien

- [ ] Szenario A ausarbeiten (Greenfield, NIS2-betroffen)
- [ ] Szenario B ausarbeiten (Supplier, KMU)
- [ ] Szenario C ausarbeiten (Modernisierung von Legacy)
- [ ] Transition Guide für Szenario C (Word/SharePoint → git-basiert)
- [ ] Zertifizierungsbegleitung: Welche Artefakte braucht der Auditor konkret —
      Checkliste je Szenario
