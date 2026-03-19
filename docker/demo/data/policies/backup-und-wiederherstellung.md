# Backup- und Wiederherstellungsrichtlinie

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: IT-Leitung
**Gültig ab**: 2025-01-01
**Nächste Überprüfung**: 2026-01-01

---

## 1. Zweck und Geltungsbereich

Diese Richtlinie legt verbindliche Anforderungen an die Datensicherung und Wiederherstellung fest.
Sie gilt für alle produktiven Systeme, Datenbanken, Konfigurationsdaten und Dokumente der Organisation,
unabhängig davon, ob diese On-Premise oder in Cloud-Umgebungen betrieben werden. (Ref: A.8.13)

## 2. Klassifizierung und Backup-Frequenz

Systeme und Daten werden anhand ihrer Kritikalität in drei Klassen eingeteilt:

| Klasse | Beispiele | Backup-Frequenz | Aufbewahrung |
|--------|-----------|-----------------|--------------|
| Kritisch | Produktionsdatenbanken, ISMS-Daten, Active Directory | Täglich (vollständig), stündlich (inkrementell) | 90 Tage |
| Wichtig | Fileserver, Konfigurationsdaten, Wiki-Inhalte | Täglich (inkrementell), wöchentlich (vollständig) | 30 Tage |
| Standard | Archivdaten, Berichte, Schulungsunterlagen | Wöchentlich (vollständig) | 12 Monate |

Die Klassifizierung erfolgt durch die IT-Leitung in Abstimmung mit den Prozessverantwortlichen.
Änderungen sind im Asset-Verzeichnis zu dokumentieren.

## 3. 3-2-1-Regel

Für alle Backup-Kopien gilt verbindlich die 3-2-1-Regel:

- **3** Kopien der Daten (Produktionsdaten + mindestens 2 Sicherungskopien)
- **2** verschiedene Speichermedien oder -technologien (z. B. NAS + Tape oder NAS + Object Storage)
- **1** Kopie an einem physisch getrennten Standort (Offsite-Speicherung)

Die Offsite-Kopie muss mindestens 50 km vom primären Rechenzentrum entfernt sein oder
in einer logisch isolierten Cloud-Region gespeichert werden.

## 4. Verschlüsselung

Alle Backup-Daten müssen verschlüsselt gespeichert werden:

- **Verschlüsselung in Transit**: TLS 1.3 oder vergleichbar
- **Verschlüsselung at Rest**: AES-256 oder stärker
- Verschlüsselungsschlüssel werden getrennt von den Backup-Daten aufbewahrt (Key-Management-System oder separates Vault)
- Der Verlust eines Schlüssels ist dem ISB unverzüglich zu melden

## 5. RTO und RPO je Systemklasse

| Klasse | RPO (Recovery Point Objective) | RTO (Recovery Time Objective) |
|--------|-------------------------------|-------------------------------|
| Kritisch | max. 1 Stunde | max. 4 Stunden |
| Wichtig | max. 24 Stunden | max. 8 Stunden |
| Standard | max. 7 Tage | max. 48 Stunden |

RTO und RPO werden mindestens jährlich mit der Geschäftsführung abgestimmt und im
Business-Continuity-Plan dokumentiert.

## 6. Wiederherstellungstests

Backup-Kopien ohne nachgewiesene Wiederherstellbarkeit gelten nicht als valide Sicherung.

| Klasse | Testfrequenz | Testart |
|--------|--------------|---------|
| Kritisch | Vierteljährlich | Vollständige Wiederherstellung in Testumgebung |
| Wichtig | Halbjährlich | Stichprobenartige Dateiwiederherstellung |
| Standard | Jährlich | Stichprobenartige Dateiwiederherstellung |

Jeder Test ist in einem Wiederherstellungsprotokoll zu dokumentieren (Datum, System, wiederhergestellte
Datenmenge, gemessene RTO, Ergebnis, Durchführender). Protokolle werden mindestens 3 Jahre aufbewahrt.

## 7. Verantwortlichkeiten

| Rolle | Aufgabe |
|-------|---------|
| IT-Leitung | Planung, Betrieb und Überwachung des Backup-Systems |
| Systemadministratoren | Tägliche Prüfung der Backup-Jobs, Eskalation bei Fehlern |
| ISB | Jährliche Prüfung der Richtlinieneinhaltung, Risikobeurteilung |
| Geschäftsführung | Freigabe der RTO/RPO-Vorgaben, Ressourcenbereitstellung |

Fehler in Backup-Jobs sind innerhalb von 4 Stunden zu eskalieren. Kann eine ausgefallene
Sicherung nicht nachgeholt werden, ist der ISB zu informieren.

## 8. Verstöße

Verstöße gegen diese Richtlinie — insbesondere das Unterlassen von Wiederherstellungstests oder
das Speichern unverschlüsselter Backups — haben arbeitsrechtliche Konsequenzen und sind dem ISB
zu melden. Schwere Verstöße werden der Geschäftsführung berichtet.
