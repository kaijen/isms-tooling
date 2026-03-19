# Informationssicherheits-Incident-Response-Verfahren

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: Informationssicherheitsbeauftragter
**Gültig ab**: 2025-01-01
**Nächste Überprüfung**: 2026-01-01

---

## 1. Zweck und Geltungsbereich

Dieses Verfahren regelt die Erkennung, Klassifizierung, Bearbeitung und Nachbereitung von
Informationssicherheitsvorfällen. Es gilt für alle Mitarbeitenden, Systeme und Dienstleister
der Organisation. (Ref: A.5.24, A.5.25, A.5.26, A.5.27, A.5.28, NIS2 Art. 23)

## 2. Incident-Klassifizierung

| Priorität | Beschreibung | Beispiele |
|-----------|-------------|-----------|
| P1 — Kritisch | Erhebliche Betriebsunterbrechung oder Datenverlust; unmittelbarer Schaden | Ransomware-Angriff, Kompromittierung privilegierter Konten, Datenleck mit personenbezogenen Daten im großen Maßstab |
| P2 — Hoch | Signifikante Beeinträchtigung; Eskalationspotenzial | Phishing-Kampagne mit erfolgreicher Credential-Entwendung, ungepatchte kritische Schwachstelle unter aktiver Ausnutzung |
| P3 — Mittel | Begrenzte Auswirkung; kein unmittelbarer Schaden | Verdächtiger Login-Versuch ohne Erfolg, verlorenes Unternehmensgerät (verschlüsselt), Malware-Fund auf isoliertem Endgerät |
| P4 — Niedrig | Potenzielle Schwachstelle oder Richtlinienverstoß ohne aktuellen Schaden | Missachtung der Clear-Desk-Richtlinie, Versand interner Dokumente per privater E-Mail |

## 3. Meldewege und Erkennungskanäle

Vorfälle können über folgende Kanäle gemeldet oder erkannt werden:

- **Mitarbeitermeldung**: Direktmeldung an ISB oder IT-Leitung (Telefon, Ticket-System, E-Mail)
- **Monitoring**: Automatische Alerts aus SIEM, Antivirus, IDS/IPS
- **Externe Meldung**: Hinweise von Behörden, CERT, Lieferanten oder Kunden
- **Audit-Befund**: Unregelmäßigkeiten aus internen oder externen Audits

Alle Mitarbeitenden sind verpflichtet, Sicherheitsvorfälle oder -verdachtsfälle unverzüglich zu melden.
Anonyme Meldungen sind über das Ticket-System möglich.

## 4. Sofortmaßnahmen

Bei Eingang einer Meldung gilt für den ISB bzw. den ersten Ansprechpartner:

1. **Validierung**: Ist der Vorfall real? Handelt es sich um ein False Positive?
2. **Erstisolation**: Betroffene Systeme vom Netz trennen, sofern ohne Datenverlust möglich
3. **Klassifizierung**: Priorität P1–P4 gemäß Abschnitt 2 festlegen
4. **Protokollierung**: Vorfallsticket anlegen mit Zeitstempel, Beschreibung, betroffenen Systemen
5. **Eskalation**: Zuständige Stellen gemäß Abschnitt 5 informieren

Systeme dürfen nur nach Rücksprache mit dem ISB neugestartet oder bereinigt werden,
um Beweismittel nicht zu vernichten.

## 5. Eskalationskette

| Priorität | Sofort (< 1 h) | Innerhalb 4 h | Innerhalb 24 h |
|-----------|---------------|---------------|----------------|
| P1 | ISB + IT-Leitung + Geschäftsführung | Externe Forensik, Rechtsabteilung | BSI/ENISA (NIS2-Pflicht) |
| P2 | ISB + IT-Leitung | Geschäftsführung bei Datenschutzbezug | ISB-Bericht |
| P3 | ISB | IT-Leitung | Wöchentliches Reporting |
| P4 | Zuständiger Mitarbeiter | ISB zur Kenntnis | Monatliches Reporting |

## 6. Meldepflichten nach NIS2 (Art. 23)

Für Vorfälle mit erheblicher Auswirkung auf wesentliche oder wichtige Einrichtungen gelten:

| Frist | Inhalt |
|-------|--------|
| 24 Stunden nach Erkennung | Frühwarnung an BSI (DE) / zuständige nationale Behörde — Art des Vorfalls, vorläufige Einschätzung |
| 72 Stunden nach Erkennung | Vollständige Erstmeldung — Ausmaß, betroffene Dienste, Gegenmaßnahmen |
| 1 Monat nach Erkennung | Abschlussbericht — vollständige Analyse, Ursache, ergriffene Maßnahmen, Präventionsschritte |

Die Einschätzung, ob ein Vorfall meldepflichtig ist, trifft der ISB in Abstimmung mit der
Rechtsabteilung oder externem Datenschutzbeauftragten. Im Zweifel wird gemeldet.

## 7. Beweissicherung

- Systemlogs, Netzwerkaufzeichnungen und E-Mail-Header sind vor Bereinigungsmaßnahmen zu sichern
- Forensische Images betroffener Systeme werden erstellt, sofern technisch möglich
- Alle Sicherungsmaßnahmen werden mit Zeitstempel dokumentiert (Chain of Custody)
- Beweismittel werden mindestens bis zum Abschluss des Nachbereitungsprozesses aufbewahrt,
  bei strafrechtlicher Relevanz mindestens 10 Jahre

## 8. Nachbereitung und Lessons Learned

Für jeden P1- und P2-Vorfall sowie auf Entscheidung des ISB für P3-Vorfälle:

1. **Post-Incident-Review**: Spätestens 5 Werktage nach Schließung des Vorfalls
2. **Root-Cause-Analyse**: Was war die Ursache? Hätte der Vorfall früher erkannt werden können?
3. **Maßnahmenplan**: Konkrete, terminierte Korrekturmaßnahmen mit Verantwortlichkeiten
4. **Richtlinienaktualisierung**: Relevante Richtlinien werden ggf. überarbeitet
5. **Dokumentation**: Ergebnisse werden im ISMS-Wiki festgehalten und fließen in den Managementbericht ein

## 9. Kontaktliste

Die aktuelle Kontaktliste (intern und extern) wird durch den ISB geführt und mindestens
halbjährlich aktualisiert. Sie enthält mindestens:

- ISB (Hauptkontakt und Vertretung) mit 24/7-Erreichbarkeit
- IT-Leitung (Hauptkontakt und Vertretung)
- Geschäftsführung (Notfallkontakt)
- Externe Forensikdienstleister (Rahmenvertrag empfohlen)
- CERT-Bund / BSI-Meldestelle
- Externer Datenschutzbeauftragter (sofern bestellt)

Die Kontaktliste ist als vertraulich eingestuft und nur dem Incident-Response-Team zugänglich.

## 10. Verstöße

Wer erkannte oder vermutete Sicherheitsvorfälle nicht meldet oder Beweismittel wissentlich
vernichtet, handelt grob fahrlässig. Solche Verstöße haben arbeitsrechtliche Konsequenzen
und können bei strafrechtlicher Relevanz zur Anzeige gebracht werden.
