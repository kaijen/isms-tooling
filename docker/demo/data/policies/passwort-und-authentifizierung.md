# Passwort- und Authentifizierungsrichtlinie

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: IT-Leitung
**Gültig ab**: 2025-01-01
**Nächste Überprüfung**: 2026-01-01

---

## 1. Zweck und Geltungsbereich

Diese Richtlinie legt verbindliche Anforderungen an Passwörter, Multi-Faktor-Authentifizierung
und Sitzungsverwaltung fest. Sie gilt für alle Benutzerkonten, Systemkonten und Dienstkonten,
die auf Systeme und Informationen der Organisation zugreifen. (Ref: A.8.2, A.8.5)

## 2. Passwortanforderungen

### 2.1 Standardkonten

| Parameter | Anforderung |
|-----------|------------|
| Mindestlänge | 12 Zeichen |
| Komplexität | Mindestens drei der vier Kategorien: Großbuchstaben, Kleinbuchstaben, Ziffern, Sonderzeichen |
| Wiederverwendung | Die letzten 12 Passwörter dürfen nicht erneut verwendet werden |
| Maximales Alter | Kein erzwungener Ablauf (außer bei Verdacht auf Kompromittierung) |
| Bekannte kompromittierte Passwörter | Müssen durch technische Kontrollen geblockt werden (z. B. HIBP-Prüfung bei Vergabe) |

### 2.2 Privilegierte Konten (Administratoren, Root, Service-Accounts mit erhöhten Rechten)

| Parameter | Anforderung |
|-----------|------------|
| Mindestlänge | 16 Zeichen |
| Komplexität | Alle vier Kategorien: Großbuchstaben, Kleinbuchstaben, Ziffern, Sonderzeichen |
| Wiederverwendung | Die letzten 20 Passwörter sind gesperrt |
| Passwortwechsel | Bei jedem Personalwechsel mit Zugriff auf das Konto, bei Verdacht auf Kompromittierung sofort |

### 2.3 Passwort-Manager

Die Nutzung eines durch die IT-Leitung genehmigten Passwort-Managers ist verpflichtend
für die Verwaltung von Passwörtern für Dienste ohne zentrale Benutzerverwaltung (SSO).
Folgende Anforderungen gelten für den eingesetzten Passwort-Manager:

- Verschlüsselte Ablage (AES-256 oder äquivalent)
- Master-Passwort gemäß Anforderungen für privilegierte Konten
- MFA für den Zugriff auf den Passwort-Manager selbst ist verpflichtend
- Cloud-basierte Passwort-Manager müssen durch den ISB genehmigt sein

## 3. Verbotene Praktiken

Folgende Praktiken sind ausdrücklich verboten und stellen Verstöße gegen diese Richtlinie dar:

- **Geteilte Passwörter**: Passwörter dürfen nicht zwischen Personen geteilt werden, auch nicht
  temporär oder in Notfällen (Ausnahme: Notfallzugang, siehe Abschnitt 6)
- **Passwörter in Klartext**: Passwörter dürfen nicht in unverschlüsselten Dateien, E-Mails,
  Chat-Nachrichten oder Versionskontrollsystemen abgelegt werden
- **Identische Passwörter** für verschiedene Systeme sind zu vermeiden
- **Einfach zu erratende Passwörter**: Tastaturmuster (qwertz, 123456), Wörterbuchwörter,
  Namen von Personen oder Systemen, Geburtsdaten

## 4. Multi-Faktor-Authentifizierung (MFA)

MFA ist für folgende Zugänge verpflichtend:

| Zugangsart | MFA-Pflicht |
|-----------|------------|
| Remote-Zugriff (VPN, RDP, SSH von extern) | Ja |
| Privilegierte Konten (Admins, Root) | Ja |
| Cloud-Dienste (SaaS, IaaS, PaaS) | Ja |
| E-Mail-Zugriff von außerhalb des Unternehmensnetzwerks | Ja |
| Passwort-Manager | Ja |
| Versionskontrollsystem (Forgejo) für Commits mit Produktionszugang | Ja |
| Standard-Intranet-Zugriff im Büronetz | empfohlen, nicht verpflichtend |

Zugelassene MFA-Faktoren (in absteigender Sicherheitspriorität):

1. Hardware-Token (FIDO2/WebAuthn, z. B. YubiKey) — bevorzugt für privilegierte Konten
2. TOTP-Authenticator-App (z. B. Aegis, Microsoft Authenticator) — Standard
3. Push-Notification-App — nur mit Phishing-resistentem Binding

SMS-TAN und E-Mail-OTP gelten nicht als vollwertige MFA und sind nur als Übergangslösung
mit Genehmigung des ISB zulässig.

## 5. Service- und Systemkonten

- Service-Accounts dürfen keine interaktiven Anmeldungen ermöglichen (sofern technisch möglich)
- Passwörter für Service-Accounts werden ausschließlich im Passwort-Manager oder Vault gespeichert
- Service-Account-Passwörter werden bei Mitarbeiterwechsel mit Kenntnis des Passworts gewechselt
  sowie bei Verdacht auf Kompromittierung sofort
- Service-Accounts erhalten nur die minimal notwendigen Berechtigungen (Least Privilege)
- Ungenutzte Service-Accounts werden innerhalb von 30 Tagen deaktiviert und dokumentiert

## 6. Notfallzugang

Für Systeme, auf denen ein Ausfall der primären Authentifizierung möglich ist:

- Notfall-Zugangsdaten werden nach dem Vier-Augen-Prinzip erzeugt und in einem
  physisch gesicherten Tresor hinterlegt (Backup-Vault oder Notfallumschlag)
- Zugriff auf Notfall-Zugangsdaten erfordert Genehmigung von ISB und IT-Leitung
- Jede Nutzung wird dokumentiert und als Sicherheitsereignis im Ticket-System erfasst
- Notfall-Passwörter werden nach jeder Nutzung sofort gewechselt

## 7. Sitzungsverwaltung

| Szenario | Timeout |
|----------|---------|
| Intranet-Webanwendungen | 8 Stunden Inaktivität (mit Warnmeldung) |
| Externe/Cloud-Dienste | 1 Stunde Inaktivität |
| Privilegierte Sitzungen (SSH, Admin-Konsolen) | 15 Minuten Inaktivität |
| Bildschirmsperre am Arbeitsplatz | 5 Minuten (gemäß Clear-Screen-Richtlinie) |

Persistente Sessions ("Remember me") sind für privilegierte Zugänge verboten.

## 8. Auslöser für sofortigen Passwortwechsel

Ein Passwortwechsel ist unverzüglich erforderlich bei:

- Verdacht auf oder Bestätigung einer Kompromittierung
- Meldung eines Phishing-Angriffs, bei dem das Passwort möglicherweise eingegeben wurde
- Personalabgang mit Kenntnis von Passwörtern (Shared Accounts, Service-Accounts)
- Auffinden des Passworts in Klartext (Log-Datei, E-Mail, Chat)
- Fund im HIBP (Have I Been Pwned) oder vergleichbarer Datenbank

## 9. Verstöße

Verstöße gegen diese Richtlinie — insbesondere das Teilen von Passwörtern, das Ablegen
von Zugangsdaten in Klartext oder die Umgehung der MFA-Pflicht — haben arbeitsrechtliche
Konsequenzen. Bekannt gewordene Verstöße sind dem ISB unverzüglich zu melden.
