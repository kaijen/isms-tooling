# Offene Punkte

## Konzept

- [ ] **Risikoebenen / Queue-Struktur**: Queue-Hierarchie (Strategisch / Operativ / Technisch)
      weiter ausarbeiten — Eskalationspfade, Übergabeprozesse zwischen Ebenen, Berichtslinien
- [ ] **Risikoregister-Export**: Weg von Ticket-Filteransicht zu auditortauglichem Dokument
- [x] **Meldepflichten NIS2**: Queue `Meldepflichten`, States und Dynamic Fields
      in `setup-otobo.sh` — Statusübergänge: erkannt → Erst-/Folge-/Abschlussmeldung
      → abgeschlossen. Seed-Ticket fehlt noch (seed-otobo.sh).
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
- [x] **Starter-Templates**: 9 Richtlinien in `docker/demo/data/policies/`,
      werden via `seed-forgejo.sh` in `isms/isms-policies` eingecheckt.

## Szenarien

- [ ] Szenario A ausarbeiten (Greenfield, NIS2-betroffen)
- [ ] Szenario B ausarbeiten (Supplier, KMU)
- [ ] Szenario C ausarbeiten (Modernisierung von Legacy)
- [ ] Transition Guide für Szenario C (Word/SharePoint → git-basiert)
- [x] Zertifizierungsbegleitung: `audit-checkliste.md` mit Stage-1/Stage-2-Nachweisen,
      häufigen NCs und Artefakt-Mapping je ISMS-Tool.
