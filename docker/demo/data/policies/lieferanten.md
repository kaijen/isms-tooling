# Lieferanten- und Dienstleisterrichtlinie

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: Informationssicherheitsbeauftragter
**Gültig ab**: 2025-01-01
**Nächste Überprüfung**: 2026-01-01

---

## 1. Zweck und Geltungsbereich

Diese Richtlinie regelt die Sicherheitsanforderungen an externe Lieferanten und Dienstleister,
die im Auftrag der Organisation Informationen verarbeiten, auf Systeme zugreifen oder sicherheits-
relevante Dienstleistungen erbringen. Sie gilt ab der ersten Auftragsanbahnung bis zur vollständigen
Beendigung der Geschäftsbeziehung. (Ref: A.5.19, A.5.20, A.5.21, A.5.22)

## 2. Lieferantenklassifizierung

| Klasse | Kriterien | Beispiele |
|--------|-----------|-----------|
| Kritisch | Zugriff auf vertrauliche oder personenbezogene Daten; Einfluss auf kritische Systeme; Verarbeitung im Auftrag (AVV erforderlich) | Managed-Service-Provider, Cloud-Hosting-Anbieter, externe IT-Administratoren, Softwareentwickler mit Produktionszugang |
| Wichtig | Indirekter Zugang zu Systemen oder Informationen; regelmäßige Interaktion | Facility-Management mit Zugang zu Serverräumen, Beratungsunternehmen mit Akteneinsicht, Druckdienstleister |
| Unkritisch | Kein Zugang zu Informationen oder Systemen der Organisation | Büromateriallieferanten, Reisebüros, Caterer |

Die Klassifizierung wird durch den ISB bei Vertragsabschluss festgelegt und im Lieferantenregister
dokumentiert. Eine Reklassifizierung bei Änderung des Leistungsumfangs ist verpflichtend.

## 3. Sicherheitsanforderungen je Klasse

| Anforderung | Kritisch | Wichtig | Unkritisch |
|-------------|:-------:|:-------:|:----------:|
| Sicherheitsfragebogen vor Vertragsabschluss | Ja | Ja | Nein |
| Nachweispflicht (ISO 27001, SOC 2 o. ä.) | Ja | empfohlen | Nein |
| Vertragliche Sicherheitsklauseln | Ja | Ja | Nein |
| Auftragsverarbeitungsvertrag (AVV) | bei PB-Daten | bei PB-Daten | Nein |
| Jährliches Review | Ja | Ja | Nein |
| Auditrecht | Ja | Ja (eingeschränkt) | Nein |

## 4. Pflichtklauseln in Verträgen

Verträge mit kritischen und wichtigen Lieferanten müssen mindestens folgende Klauseln enthalten:

1. **Vertraulichkeit**: Geheimhaltungsverpflichtung für alle im Rahmen der Leistung bekannt gewordenen Informationen
2. **Sicherheitsanforderungen**: Verpflichtung zur Einhaltung der für die Organisation relevanten Sicherheitsstandards
3. **Incident-Meldepflicht**: Meldung von Sicherheitsvorfällen mit Auswirkung auf die Organisation innerhalb von 24 Stunden
4. **Auditrecht**: Recht der Organisation oder beauftragter Dritter auf Sicherheitsaudits mit angemessener Vorankündigung (mind. 2 Wochen)
5. **Subunternehmer**: Einschaltung von Sub-Dienstleistern nur mit vorheriger schriftlicher Zustimmung der Organisation
6. **Datenrückgabe und -löschung**: Vollständige Rückgabe oder nachweisliche Löschung aller Daten bei Vertragsende
7. **Rechtswahl und Gerichtsstand**: Gültige und durchsetzbare Rechtswahl (EU-Recht bevorzugt)

## 5. Onboarding-Prozess

Vor Gewährung von Systemzugängen oder Informationsübermittlung gilt für kritische Lieferanten:

1. Prüfung und Genehmigung durch ISB und Fachverantwortlichen
2. Unterzeichnung der Vertraulichkeitsvereinbarung und Sicherheitsklauseln
3. Einweisung in relevante Sicherheitsrichtlinien (Mindest-Awareness)
4. Vergabe von Zugängen nach Least-Privilege-Prinzip mit dokumentierter Genehmigung
5. Eintrag im Lieferantenregister mit Verantwortlichem, Klassifizierung und Zugangsübersicht
6. Festlegung eines internen Verantwortlichen (Lieferantenverantwortlicher)

## 6. Laufendes Monitoring und jährliches Review

Für kritische und wichtige Lieferanten führt der ISB jährlich ein Lieferanten-Review durch:

- Prüfung aktueller Sicherheitsnachweise (Zertifikate, Auditberichte, Penetrationstest-Ergebnisse)
- Bewertung von Vorfällen oder Sicherheitsmeldungen des Lieferanten im vergangenen Jahr
- Überprüfung der vergebenen Zugriffsrechte auf Aktualität und Notwendigkeit
- Aktualisierung des Sicherheitsfragebogens bei wesentlichen Änderungen im Leistungsumfang

## 7. Cloud-Anbieter und SaaS-Dienste

Für Cloud-Dienste (IaaS, PaaS, SaaS) gelten ergänzend:

- Datenstandort muss dokumentiert sein; Verarbeitung außerhalb des EWR erfordert zusätzliche Rechtsgrundlage (SCCs, Angemessenheitsbeschluss)
- Shared-Responsibility-Modell ist schriftlich geklärt und für den ISB nachvollziehbar dokumentiert
- Verfügbarkeits-SLAs müssen mit den RTO-Anforderungen der genutzten Dienste vereinbar sein
- Exit-Strategie und Datenportabilität sind vor Vertragsabschluss zu prüfen

## 8. Offboarding

Bei Beendigung einer Lieferantenbeziehung ist sicherzustellen:

1. Widerruf aller Systemzugänge und Löschung aller Benutzerkonten — spätestens am letzten Vertragstag
2. Rückforderung oder nachweisliche Löschung aller übergebenen Daten und Dokumente
3. Rückgabe von Hardware, Zugangsmedien und Schlüsseln
4. Abschlussgespräch zur Übergabe offener Vorgänge und Dokumentation
5. Aktualisierung des Lieferantenregisters (Status: beendet, Datum, Verantwortlicher)

## 9. Verstöße

Verstöße gegen diese Richtlinie — insbesondere die eigenmächtige Einbindung von Subunternehmern
oder die Unterlassung des Offboarding-Prozesses — sind dem ISB zu melden und haben arbeitsrechtliche
Konsequenzen. Bei Lieferantenseitigem Verstoß gegen Vertragsklauseln prüft die Rechtsabteilung
weitere Schritte.
