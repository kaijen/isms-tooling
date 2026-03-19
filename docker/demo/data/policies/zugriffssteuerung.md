# Zugriffssteuerungsrichtlinie

**Version**: 1.0
**Status**: Freigegeben
**Verantwortlich**: IT-Leitung
**Gültig ab**: 2024-01-01

---

## 1. Grundsatz

Zugriff auf Informationen und Systeme wird nach dem Prinzip der minimalen Berechtigung
(Least Privilege) und dem Need-to-Know-Prinzip gewährt.

## 2. Benutzerverwaltung

- Benutzerkonten werden durch die IT-Leitung auf Anfrage des Vorgesetzten erstellt.
- Berechtigungen werden rollenbasiert (RBAC) vergeben.
- Beim Austritt werden Zugänge am letzten Arbeitstag deaktiviert.
- Quarterly Access Review: Alle Berechtigungen werden vierteljährlich geprüft.

## 3. Passwortanforderungen

| Parameter | Anforderung |
|-----------|------------|
| Mindestlänge | 12 Zeichen |
| Komplexität | Groß-/Kleinbuchstaben, Ziffern, Sonderzeichen |
| Wiederverwendung | Letzte 10 Passwörter gesperrt |
| MFA | Pflicht für alle administrativen Zugänge |

## 4. Privilegierte Zugänge

- Administrator-Konten sind von Standardkonten getrennt.
- Privilegierte Sitzungen werden protokolliert.
- Shared Accounts sind verboten.
