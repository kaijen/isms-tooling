# Kryptographierichtlinie

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: IT-Leitung
**Gültig ab**: 2025-01-01
**Nächste Überprüfung**: 2026-01-01

---

## 1. Zweck und Geltungsbereich

Diese Richtlinie legt verbindliche Anforderungen an den Einsatz kryptographischer Verfahren fest.
Sie gilt für alle Systeme, Anwendungen und Kommunikationsverbindungen der Organisation, die
schützenswerte Informationen verarbeiten, speichern oder übertragen. (Ref: A.8.24)

## 2. Zugelassene Algorithmen

### 2.1 Symmetrische Verschlüsselung

| Algorithmus | Mindestschlüssellänge | Zulässige Modi | Anwendungsbeispiel |
|-------------|----------------------|----------------|-------------------|
| AES | 256 Bit | GCM, CBC (mit HMAC) | Datei- und Datenbankverschlüsselung, Backup |

### 2.2 Asymmetrische Verschlüsselung und digitale Signaturen

| Algorithmus | Mindestschlüssellänge | Anwendungsbeispiel |
|-------------|----------------------|-------------------|
| RSA | 4096 Bit | Zertifikate, E-Mail-Verschlüsselung |
| ECDSA | P-384 (secp384r1) | Code Signing, TLS-Zertifikate |
| Ed25519 | (feste Länge) | SSH-Schlüssel, Git-Signaturen |

### 2.3 Hash-Funktionen

| Algorithmus | Zulässig für | Hinweis |
|-------------|--------------|---------|
| SHA-256 | Allgemein | Mindeststandard |
| SHA-384, SHA-512 | Bevorzugt für Signaturen und hochkritische Anwendungen | — |
| SHA-3 | Zulässig | Kompatibilitätsprüfung erforderlich |

## 3. Verbotene Algorithmen

Folgende Algorithmen und Verfahren sind aufgrund nachgewiesener kryptographischer Schwächen verboten:

| Algorithmus / Verfahren | Grund |
|------------------------|-------|
| MD5 | Kollisionsangriffe bekannt |
| SHA-1 | Kollisionsangriffe nachgewiesen (SHAttered) |
| DES / 3DES | Unzureichende Schlüssellänge, SWEET32-Angriff |
| RC4 | Statistisch schwach, offiziell durch RFC 7465 verboten |
| RSA < 2048 Bit | Unzureichende Schlüssellänge |
| ECB-Modus (für Blockverschlüsselung) | Keine semantische Sicherheit |

Der Einsatz verbotener Algorithmen in Neuentwicklungen ist untersagt. Bestehende Systeme
mit verbotenen Algorithmen sind im Risikomanagement zu erfassen und im Rahmen des
nächsten Release-Zyklus zu migrieren, spätestens jedoch innerhalb von 12 Monaten.

## 4. TLS-Anforderungen

Alle verschlüsselten Netzwerkverbindungen (intern wie extern) müssen folgende Mindestanforderungen erfüllen:

- **Mindestversion**: TLS 1.2
- **Bevorzugte Version**: TLS 1.3
- **Verboten**: SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1
- **Cipher Suites**: Nur Forward-Secrecy-fähige Suites (ECDHE, DHE); RC4, NULL und EXPORT-Suites sind deaktiviert
- **HSTS**: Für alle öffentlich erreichbaren Webservices mit `max-age` min. 6 Monate
- **Zertifikatsprüfung**: Zertifikatsvalidierung darf in keiner Produktivumgebung deaktiviert werden

## 5. Zertifikatsmanagement

### 5.1 Anforderungen an Zertifikate

- Maximale Gültigkeitsdauer: 398 Tage (öffentliche Zertifikate), 2 Jahre (interne CA)
- Ausstellende CA: Anerkannte öffentliche CA (z. B. für externe Dienste) oder interne PKI nach dokumentiertem Betriebskonzept
- Self-signed Zertifikate sind nur in isolierten Entwicklungsumgebungen zulässig

### 5.2 Erneuerungsprozess

- Zertifikate werden spätestens 30 Tage vor Ablauf erneuert
- Die IT-Leitung führt ein Zertifikatsregister mit Ablaufdaten und Verantwortlichkeiten
- Automatisierte Erneuerung (z. B. ACME-Protokoll / Let's Encrypt) ist bevorzugt
- Abgelaufene Zertifikate in Produktion werden als Sicherheitsvorfall der Klasse P2 behandelt

## 6. Schlüsselverwaltung

- Private Schlüssel werden ausschließlich in dafür vorgesehenen Systemen gespeichert (HSM, Vault, OS-Schlüsselspeicher)
- Private Schlüssel werden niemals im Klartext in Konfigurationsdateien, Versionskontrollsystemen oder E-Mails abgelegt
- Schlüssel für kritische Systeme werden nach dem Vier-Augen-Prinzip erzeugt und gespeichert
- Der Verlust oder die mögliche Kompromittierung eines privaten Schlüssels ist unverzüglich dem ISB zu melden und löst eine Schlüsselrevokation aus

## 7. Anwendungsfälle: Symmetrisch vs. Asymmetrisch

| Anwendungsfall | Empfohlenes Verfahren |
|----------------|----------------------|
| Datei- und Datenbankverschlüsselung | AES-256-GCM |
| Backup-Verschlüsselung | AES-256-GCM mit separatem Key-Management |
| Transportverschlüsselung | TLS 1.3 (ECDHE + AES-256-GCM) |
| Digitale Signaturen (Dokumente, Code) | RSA-4096 oder ECDSA P-384 |
| SSH-Zugang zu Servern | Ed25519 (bevorzugt) oder ECDSA P-384 |
| E-Mail-Verschlüsselung | S/MIME mit RSA-4096 oder OpenPGP |

## 8. Verstöße

Der Einsatz verbotener Algorithmen oder die unsachgemäße Handhabung kryptographischer Schlüssel
— insbesondere das Ablegen privater Schlüssel in Versionskontrollsystemen oder der unkontrollierte
Verlust von Schlüsseln — hat arbeitsrechtliche Konsequenzen und ist dem ISB unverzüglich zu melden.
