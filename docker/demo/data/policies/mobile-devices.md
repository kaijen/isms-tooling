# Mobile-Device- und Telearbeitsrichtlinie

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: IT-Leitung
**Gültig ab**: 2025-01-01
**Nächste Überprüfung**: 2026-01-01

---

## 1. Zweck und Geltungsbereich

Diese Richtlinie legt Anforderungen an die sichere Nutzung mobiler Endgeräte sowie an die
Telearbeit (Homeoffice und mobiles Arbeiten) fest. Sie gilt für alle Mitarbeitenden, die
dienstliche Informationen auf portablen Geräten verarbeiten oder außerhalb der Unternehmensräume
auf Systeme der Organisation zugreifen. (Ref: A.8.1, A.6.7)

## 2. Gerätekategorien

### 2.1 COPE — Corporate-Owned Personally Enabled

Von der Organisation bereitgestellte Geräte, auf denen eingeschränkte private Nutzung
gestattet ist. COPE-Geräte werden durch die IT-Leitung verwaltet und konfiguriert.
Diese Kategorie ist der Standard für alle Mitarbeitenden mit mobilem Arbeitsbedarf.

### 2.2 BYOD — Bring Your Own Device

Private Geräte für dienstliche Nutzung sind nur zulässig, wenn:

- eine schriftliche Genehmigung der IT-Leitung vorliegt,
- das Gerät vollständig in das MDM-System eingebunden wurde,
- der Mitarbeitende der Fernlöschung des dienstlichen Containers zugestimmt hat.

BYOD ist auf Ausnahmefälle beschränkt und wird nicht aktiv gefördert.

## 3. MDM-Enrollment

Alle mobilen Geräte (Smartphones, Tablets, Laptops), die auf dienstliche Systeme zugreifen,
müssen vor der ersten Nutzung in das Mobile Device Management (MDM) der Organisation eingebunden sein.

Das MDM stellt folgende Basiskonfigurationen sicher:

- Geräteverschlüsselung (AES-256 oder plattformäquivalent)
- Konfiguration der Bildschirmsperre und Inaktivitätssperren
- Fernlöschung (Remote Wipe) für das gesamte Gerät (COPE) bzw. den Unternehmenscontainer (BYOD)
- Verteilung von VPN-Profilen und WLAN-Konfigurationen
- Erzwingen von OS- und Sicherheitsupdates innerhalb von 14 Tagen nach Release

## 4. Mindestsicherheitskonfiguration

| Anforderung | Vorgabe |
|-------------|---------|
| Bildschirmsperre | PIN (min. 6-stellig), Muster oder biometrisch |
| Automatische Sperre | Nach spätestens 2 Minuten Inaktivität |
| Geräteverschlüsselung | Aktiviert (zwingend) |
| Betriebssystem | Hersteller-Supportzeitraum nicht überschritten; aktuelle Sicherheitsupdates installiert |
| Remote Wipe | Aktiviert und regelmäßig auf Funktionsfähigkeit getestet |
| Jailbreak / Root | Verboten; MDM blockiert Zugriff auf kompromittierten Geräten |

## 5. Zulässige und verbotene Apps

- Apps werden ausschließlich aus offiziellen Stores (Apple App Store, Google Play Store)
  oder dem unternehmenseigenen App-Katalog installiert
- Sideloading von Apps aus unbekannten Quellen ist verboten
- Folgende App-Kategorien sind auf COPE-Geräten untersagt: VPN-Apps ohne IT-Freigabe,
  Alternative App-Stores (z. B. Cydia), Apps mit bekannten Datenschutzverletzungen
  (Blacklist wird durch IT-Leitung gepflegt)
- Dienstliche Daten dürfen nicht in privaten Cloud-Speichern abgelegt werden
  (z. B. privates Google Drive, Dropbox ohne Unternehmensfreigabe)

## 6. Nutzung öffentlicher Netze

- In öffentlichen WLAN-Netzen (Hotel, Café, Bahnhof, Flughafen) ist die Nutzung des
  Unternehmens-VPN verpflichtend, bevor auf interne Systeme zugegriffen wird
- Ungesicherte Hotspots ohne WPA2/WPA3 dürfen ausschließlich über VPN genutzt werden
- Bluetooth ist in öffentlichen Umgebungen auf notwendige Verbindungen zu beschränken
  und im Ruhezustand zu deaktivieren
- USB-Ladevorgänge an öffentlichen Ladestationen sind nur mit USB-Datenblocker zulässig
  (Juice Jacking-Prävention)

## 7. Verlust oder Diebstahl

Bei Verlust oder Diebstahl eines dienstlichen oder BYOD-Geräts gilt:

1. Unverzügliche Meldung an IT-Leitung und ISB — spätestens innerhalb von 2 Stunden
2. IT-Leitung initiiert Remote Wipe des Geräts bzw. des Unternehmenscontainers
3. Zugehörige Passwörter und Zertifikate werden gesperrt und erneuert
4. Dokumentation als Sicherheitsvorfall (Klassifizierung P3 oder höher)
5. Bei Verdacht auf Datenzugriff durch Dritte: Eskalation gemäß Incident-Response-Verfahren

## 8. Homeoffice — physische Sicherheitsanforderungen

- Der häusliche Arbeitsplatz ist so einzurichten, dass unberechtigte Dritte (einschließlich
  Familienangehörige) keinen Einblick in Bildschirminhalte oder Dokumente erhalten
- Vertrauliche Unterlagen dürfen nicht unbeaufsichtigt zugänglich liegen
- Dienstliche Ausdrucke sind nach Gebrauch zu schreddern oder gesichert zur Entsorgung
  in das Büro mitzubringen; private Drucker sind für vertrauliche Dokumente nur nach
  Absprache mit der IT-Leitung zulässig
- Ein abschließbarer Schrank für physische Dokumente ist empfohlen
- Webcam-Abdeckungen werden durch die IT-Leitung bereitgestellt

## 9. Verstöße

Die eigenmächtige Nutzung nicht genehmigter Geräte oder Apps für dienstliche Zwecke,
das Unterlassen der Verlustmeldung sowie die Nutzung öffentlicher Netze ohne VPN verstoßen
gegen diese Richtlinie. Verstöße haben arbeitsrechtliche Konsequenzen und sind dem ISB zu melden.
