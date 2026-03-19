---
layout: default
title: Auditor-Checkliste
---

# Auditor-Checkliste ISO 27001:2022

Strukturierte Übersicht der Nachweise, die ein ISO-27001-Zertifizierungsauditor in
Stage 1 (Dokumentenprüfung) und Stage 2 (Prozessaudit) erwartet.

Geeignet als Vorbereitungs-Checkliste für interne Audits und den Zertifizierungsaudit.

---

## Stage 1 — Dokumentenprüfung

Der Auditor prüft ob alle Pflichtdokumente vorhanden, aktuell und genehmigt sind.

### Pflichtdokumente nach ISO 27001:2022

| Dokument | Normstelle | Wo abgelegt | ✓ |
|----------|-----------|-------------|---|
| Informationssicherheitsleitlinie (IS-Policy) | 5.2 | Forgejo `isms-policies` | ☐ |
| Scope-Statement (Geltungsbereich) | 4.3 | Forgejo `isms-policies` | ☐ |
| Risikobeurteilungsprozess (Methodik) | 6.1.2 | Forgejo `isms-policies` | ☐ |
| Risikobehandlungsprozess | 6.1.3 | Forgejo `isms-policies` | ☐ |
| Risikoakzeptanzkriterien | 6.1.2c | Forgejo `isms-policies` | ☐ |
| Statement of Applicability (SoA) | 6.1.3d | Forgejo / BookStack | ☐ |
| Ziele der Informationssicherheit | 6.2 | BookStack ISMS-Handbuch | ☐ |
| Nachweise zur Kompetenz (Schulungsnachweise) | 7.2 | BookStack / Dateiablage | ☐ |
| Internes Auditprogramm | 9.2 | BookStack / OTOBO | ☐ |
| Ergebnisse interner Audits (Auditberichte) | 9.2 | BookStack / OTOBO | ☐ |
| Ergebnisse der Managementbewertung | 9.3 | BookStack | ☐ |
| Nichtkonformitäten und Korrekturmaßnahmen | 10.1 | OTOBO `Aufgaben::Audit` | ☐ |
| Risikoregister (Ergebnis der Risikobeurteilung) | 6.1.2 | OTOBO `Risiken::*` | ☐ |
| Risikobehandlungsplan (RTP) | 6.1.3 | OTOBO / Forgejo | ☐ |
| Ergebnisse der Risikoüberwachung | 8.2–8.3 | OTOBO | ☐ |

### Zusätzliche Dokumente (empfohlen / NIS2)

| Dokument | Bezug | Wo abgelegt | ✓ |
|----------|-------|-------------|---|
| Zugangssteuerungsrichtlinie | A.5.15 | Forgejo `isms-policies` | ☐ |
| Kryptographierichtlinie | A.8.24 | Forgejo `isms-policies` | ☐ |
| Backup- und Wiederherstellungsrichtlinie | A.8.13 | Forgejo `isms-policies` | ☐ |
| Incident-Response-Verfahren | A.5.24-5.28 | Forgejo `isms-policies` | ☐ |
| NIS2-Meldepflicht-Verfahren | NIS2 Art. 23 | Forgejo `isms-policies` | ☐ |
| Lieferanten- und Dienstleisterrichtlinie | A.5.19-5.22 | Forgejo `isms-policies` | ☐ |
| Passwort- und Authentifizierungsrichtlinie | A.8.2, A.8.5 | Forgejo `isms-policies` | ☐ |
| Notfallhandbuch / BCM-Plan | A.5.29-5.30 | Forgejo / BookStack | ☐ |
| Asset-Inventar | A.5.9 | DataGerry | ☐ |
| Netzwerkarchitektur-Dokumentation | A.8.20-8.22 | BookStack IT-Betrieb | ☐ |

---

## Stage 2 — Prozessaudit (Vor-Ort)

Der Auditor prüft durch Interviews, Begehungen und Stichproben, ob die dokumentierten
Prozesse tatsächlich gelebt werden.

### Risikomanagement

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Risiken werden systematisch identifiziert und bewertet | OTOBO: Tickets in `Risiken::*` mit befüllten Dynamic Fields | ☐ |
| Risikowert korrekt berechnet (W × S) | Stichprobe: 3-5 Tickets prüfen | ☐ |
| Risikobehandlungsplan für alle Hochrisiken vorhanden | Verlinkung Risiko-Ticket → Maßnahmen-Ticket | ☐ |
| Restrisiken sind durch Management genehmigt | Dokumentierte Genehmigung (E-Mail, Protokoll) | ☐ |
| SoA aktuell und vollständig | Alle 93 Controls mit Status und Begründung | ☐ |
| Risikoregister wird regelmäßig überprüft | OTOBO-Verlauf, Datum letztes Review | ☐ |

### Zugangsteuerung

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Benutzerkonten basieren auf Rollen (RBAC) | AD/LDAP-Gruppen, Dokumentation | ☐ |
| Privilegierte Konten sind dokumentiert und beschränkt | Liste der Admin-Konten, PAM | ☐ |
| MFA für privilegierte Zugänge und Remote-Access aktiv | Screenshot / Konfigurationsauszug | ☐ |
| Zugriffsrechte werden bei Personaländerungen angepasst | Offboarding-Protokoll: letzten 3 Fälle | ☐ |
| Regelmäßige Access Reviews durchgeführt | Protokoll letzter Access Review | ☐ |

### Incident Management

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Meldewege für Vorfälle bekannt (Awareness) | Schulungsnachweis, Aushang, Intranet | ☐ |
| Vorfälle werden klassifiziert und dokumentiert | OTOBO: Tickets in `Incidents` | ☐ |
| Eskalationsprozess ist definiert und wird eingehalten | Verfahren, letzte Eskalation prüfen | ☐ |
| NIS2-Meldefristen eingehalten (24h/72h/30 Tage) | OTOBO `Meldepflichten`: Zeitstempel | ☐ |
| Post-Incident-Reviews werden durchgeführt | Abschlussberichte, Lessons Learned | ☐ |

### Backup und Verfügbarkeit

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Backup-Konfiguration entspricht Richtlinie | Backup-Logs, Konfiguration | ☐ |
| Restore-Tests wurden durchgeführt und dokumentiert | Testprotokolle (Datum, Umfang, Ergebnis) | ☐ |
| Offsite- oder Cloud-Kopie vorhanden | Nachweis externer Speicherort | ☐ |
| RPO/RTO für kritische Systeme definiert | Notfallhandbuch / BCM-Dokument | ☐ |

### Lieferantenmanagement

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Kritische Lieferanten sind klassifiziert | DataGerry: Objekte Typ `Dienstleister` | ☐ |
| Sicherheitsanforderungen in Verträgen verankert | Vertragsauszüge (Klauseln) | ☐ |
| Lieferanten werden regelmäßig bewertet | Bewertungsprotokolle | ☐ |
| Offboarding-Prozess für Lieferanten vorhanden | Verfahren, letzter Fall prüfen | ☐ |

### Kryptographie und Datenschutz

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Transportverschlüsselung aktiv (TLS 1.2+) | SSL-Labs-Scan oder Konfigurationsauszug | ☐ |
| Datenspeicherung verschlüsselt (Disks, Backups) | Konfigurationsnachweis | ☐ |
| Schlüsselverwaltung dokumentiert | Kryptographierichtlinie, Key-Management | ☐ |
| Verbotene Algorithmen (MD5, SHA-1) nicht im Einsatz | Scan-Ergebnis | ☐ |

### Awareness und Schulung

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Alle Mitarbeitenden wurden geschult | Teilnehmerlisten mit Unterschriften | ☐ |
| Schulung war inhaltlich angemessen | Schulungsunterlagen aus BookStack | ☐ |
| Neue Mitarbeitende werden im Onboarding geschult | Onboarding-Checkliste | ☐ |
| Schulungen werden regelmäßig wiederholt (jährlich) | Schulungsplan, letzte 2 Durchführungen | ☐ |

### Internes Auditprogramm

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Auditprogramm für das Jahr existiert | Auditplan in BookStack | ☐ |
| Interne Auditoren sind unabhängig vom Auditgegenstand | RACI, Rollendokumentation | ☐ |
| Auditberichte wurden erstellt | BookStack `Risiken und Audits` | ☐ |
| Findings wurden verfolgt und abgeschlossen | OTOBO `Aufgaben::Audit` | ☐ |

### Kontinuierliche Verbesserung

| Prüfpunkt | Nachweisform | ✓ |
|-----------|-------------|---|
| Nichtkonformitäten werden dokumentiert | OTOBO-Tickets, Auditberichte | ☐ |
| Ursachenanalyse für NCs wird durchgeführt | Auditbericht-Abschnitt | ☐ |
| Wirksamkeit von Korrektivmaßnahmen wird geprüft | Follow-up-Audit / Ticket-Abschluss | ☐ |
| Managementbewertung hat stattgefunden | Protokoll inkl. Beschlüsse | ☐ |

---

## Häufige Auditfeststellungen (Hinweise zur Vorbereitung)

Diese Punkte führen in der Praxis am häufigsten zu Nonconformities:

| Bereich | Typische NC |
|---------|------------|
| SoA | Controls als "nicht anwendbar" markiert ohne ausreichende Begründung |
| Risikoregister | Risiken vorhanden, aber Behandlungsplan fehlt oder ist veraltet |
| Zugang | Admin-Konten ohne MFA, Ex-Mitarbeitende noch aktiv |
| Backup | Restore-Tests nicht dokumentiert oder nie durchgeführt |
| Awareness | Schulung stattgefunden, aber kein Nachweis (Teilnehmerliste) |
| Lieferanten | Cloud-Anbieter mit kritischen Daten nicht in Lieferantenliste |
| Incident | Vorfälle mündlich behandelt, keine Dokumentation |
| NIS2 | Meldepflichten bekannt, aber Workflow nicht definiert oder geübt |

---

## Artefakte im ISMS-Stack

| Artefakt | System |
|---------|--------|
| Richtlinien | Forgejo `isms/isms-policies` (versioniert, PR-Freigabe) |
| Veröffentlichte Richtlinien | MkDocs unter `docs.<domain>` |
| Risikoregister | OTOBO `Risiken::*` (Dynamic Fields) |
| Maßnahmen / Findings | OTOBO `Aufgaben::*` |
| Meldepflichten | OTOBO `Meldepflichten` |
| Asset-Inventar | DataGerry |
| Wiki / Schulungen | BookStack |
| Projekte / Roadmap | Wekan Board `ISMS-Aufbau` |
| Managementbewertung | BookStack `Risiken und Audits` |
