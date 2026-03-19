#!/usr/bin/env bash
# Szenario A – BookStack Ersteinrichtung
#
# Ausführung: einmalig nach BookStack-Start, vor seed-bookstack.sh.
#
# Erstellt via BookStack REST API:
#   - Shelf:    ISMS-Kern (enthält ISMS-Handbuch, Richtlinien, Risiken & Audits)
#   - Shelf:    Awareness  (enthält Schulungsmaterialien)
#   - Bücher und Kapitel-Skelett nach ISO-27001-Struktur
#   - Skeleton-Seiten mit Abschnittsüberschriften als Startpunkt

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"

if [[ -f "${SCRIPT_DIR}/../.env" ]]; then
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/../.env"
fi

BOOKSTACK_URL="https://wiki.${DOMAIN}"

step "BookStack – Warte auf Service"
wait_for_http "${BOOKSTACK_URL}" "BookStack"

step "BookStack – Ersteinrichtung via REST API"

python3 - \
  "${BOOKSTACK_URL}" \
  "${BOOKSTACK_TOKEN_ID}" \
  "${BOOKSTACK_TOKEN_SECRET}" << 'PYEOF'
import sys
import json
import urllib.request
import urllib.error

base_url, token_id, token_secret = sys.argv[1:]

HEADERS = {
    "Authorization": f"Token {token_id}:{token_secret}",
    "Content-Type":  "application/json",
}

def api(method, path, data=None):
    body = json.dumps(data).encode() if data else None
    req  = urllib.request.Request(
        f"{base_url}/api{path}", data=body, headers=HEADERS, method=method
    )
    try:
        with urllib.request.urlopen(req) as r:
            return json.load(r)
    except urllib.error.HTTPError as e:
        msg = e.read().decode()[:120]
        print(f"  WARN  {method} {path}: {e} – {msg}")
        return {}

def exists(entity, name):
    """Prüft ob ein Objekt mit diesem Namen bereits vorhanden ist."""
    r = api("GET", f"/{entity}s?filter[name]={urllib.parse.quote(name)}")
    return r.get("total", 0) > 0

import urllib.parse

def create_shelf(name, description):
    if exists("shelf", name):
        print(f"  SKIP  Shelf '{name}'")
        return None
    r = api("POST", "/shelves", {"name": name, "description": description})
    sid = r.get("id")
    if sid:
        print(f"  OK    Shelf '{name}' (ID={sid})")
    else:
        print(f"  ERR   Shelf '{name}'")
    return sid

def create_book(name, description, shelf_id=None):
    if exists("book", name):
        print(f"  SKIP  Book '{name}'")
        return None
    data = {"name": name, "description": description}
    r    = api("POST", "/books", data)
    bid  = r.get("id")
    if bid:
        print(f"  OK    Book '{name}' (ID={bid})")
        if shelf_id:
            api("POST", f"/shelves/{shelf_id}/books/{bid}", {})
    else:
        print(f"  ERR   Book '{name}'")
    return bid

def create_chapter(book_id, name, description):
    if exists("chapter", name):
        print(f"  SKIP  Chapter '{name}'")
        return None
    r   = api("POST", "/chapters", {"book_id": book_id, "name": name, "description": description})
    cid = r.get("id")
    if cid:
        print(f"  OK    Chapter '{name}' (ID={cid})")
    else:
        print(f"  ERR   Chapter '{name}'")
    return cid

def create_page(book_id, chapter_id, name, markdown):
    if exists("page", name):
        print(f"  SKIP  Page '{name}'")
        return
    data = {"name": name, "markdown": markdown, "book_id": book_id}
    if chapter_id:
        data["chapter_id"] = chapter_id
    r = api("POST", "/pages", data)
    if r.get("id"):
        print(f"  OK    Page '{name}'")
    else:
        print(f"  ERR   Page '{name}'")

# ══════════════════════════════════════════════════════════════════════════════
# Shelves
# ══════════════════════════════════════════════════════════════════════════════

print("\n── Shelves")
shelf_kern    = create_shelf("ISMS-Kern",  "Handbücher, Richtlinien und Audit-Dokumentation")
shelf_aware   = create_shelf("Awareness",  "Schulungsmaterialien und Sicherheitshinweise")
shelf_betrieb = create_shelf("IT-Betrieb", "Technische Betriebsdokumentation und Verfahren")

# ══════════════════════════════════════════════════════════════════════════════
# Buch 1: ISMS-Handbuch
# ══════════════════════════════════════════════════════════════════════════════

print("\n── ISMS-Handbuch")
book_hb = create_book(
    "ISMS-Handbuch",
    "Zentrales Handbuch für das Informationssicherheits-Managementsystem nach ISO 27001:2022",
    shelf_kern,
)
if book_hb:
    ch = create_chapter(book_hb, "Grundlagen und Scope",
                        "Geltungsbereich, Schutzziele, Normreferenzen")
    create_page(book_hb, ch, "Geltungsbereich (Scope)", """\
# Geltungsbereich

## Physischer Scope
_Welche Standorte, Räumlichkeiten und Infrastruktur sind einbezogen?_

## Organisatorischer Scope
_Welche Organisationseinheiten, Abteilungen und Teams sind einbezogen?_

## Technischer Scope
_Welche IT-Systeme, Anwendungen und Dienste sind einbezogen?_

## Ausschlüsse
_Was ist explizit nicht Teil des ISMS und warum?_

## Lieferkette
_Welche Lieferanten und Dienstleister sind im Scope?_

**Freigabe:** [Name, Funktion, Datum]
""")
    create_page(book_hb, ch, "Schutzziele und Normreferenz", """\
# Schutzziele und Normreferenz

## Schutzziele (VIV)
| Schutzziel | Bedeutung |
|-----------|-----------|
| **Vertraulichkeit** | Informationen sind nur autorisierten Personen zugänglich. |
| **Integrität** | Informationen sind vollständig, korrekt und vor unberechtigter Änderung geschützt. |
| **Verfügbarkeit** | Systeme und Informationen sind bei Bedarf verfügbar. |

## Normreferenz
Das ISMS richtet sich nach **ISO/IEC 27001:2022** und berücksichtigt:
- ISO/IEC 27002:2022 (Controls-Leitfaden)
- NIS2-Richtlinie (EU) 2022/2555
- DSGVO / GDPR

## Zertifizierungsziel
_Angestrebtes Datum Erstaudit Stage 1:_ [Datum]
_Angestrebtes Datum Erstaudit Stage 2:_ [Datum]
""")

    ch = create_chapter(book_hb, "Rollen und Verantwortlichkeiten",
                        "RACI-Matrix, Organigramm ISMS, Kontakte")
    create_page(book_hb, ch, "RACI-Matrix ISMS", """\
# RACI-Matrix ISMS

| Aufgabe | GF | ISB | IT-Ltg. | Prozessverantw. | Alle MA |
|---------|----|----|---------|----------------|---------|
| ISMS-Strategie | **A** | R | I | I | I |
| Risikomanagement | A | **R** | C | C | I |
| Richtlinien verabschieden | **A** | R | C | C | I |
| Technische Controls | I | A | **R** | C | I |
| Sicherheitsvorfälle melden | I | **A** | R | I | **R** |
| Interne Audits | A | **R** | C | C | I |
| Awareness-Schulungen | I | **A** | C | I | R |

_Legende: R = Responsible, A = Accountable, C = Consulted, I = Informed_

## Kontakte
| Rolle | Name | E-Mail | Telefon |
|-------|------|--------|---------|
| ISB | | | |
| IT-Leitung | | | |
| Datenschutzbeauftragter | | | |
| Externer Auditor | | | |
""")

    ch = create_chapter(book_hb, "Risikomanagement",
                        "Bewertungsschema, Risikoregister-Übersicht, Behandlungsprozess")
    create_page(book_hb, ch, "Risikobeurteilungsmethodik", """\
# Risikobeurteilungsmethodik

## Bewertungsmatrix

| Wahrscheinlichkeit \\ Schadenshöhe | 1 – Gering | 2 – Mittel | 3 – Hoch | 4 – Kritisch |
|----------------------------------|-----------|-----------|---------|------------|
| **1 – Selten**                   | 1         | 2         | 3       | 4          |
| **2 – Möglich**                  | 2         | 4         | 6       | 8          |
| **3 – Wahrscheinlich**           | 3         | 6         | 9       | 12         |
| **4 – Fast sicher**              | 4         | 8         | 12      | 16         |

## Risikoakzeptanz
| Risikowert | Behandlung |
|-----------|-----------|
| 1–3 | Akzeptieren (dokumentieren) |
| 4–8 | Behandeln oder begründet akzeptieren |
| 9–16 | Behandeln – Eskalation an Geschäftsleitung |

## Risikoregister
Alle Risiken werden in OTOBO (Queues: `Risiken::Strategisch` / `::Operativ` / `::Technisch`) geführt.

## Überprüfungsintervall
- Vollständige Neubewertung: jährlich
- Anlassbezogen: nach signifikanten Vorfällen oder Systemänderungen
""")

    ch = create_chapter(book_hb, "Maßnahmen und Controls",
                        "Statement of Applicability, implementierte Controls")
    create_page(book_hb, ch, "Statement of Applicability (SoA)", """\
# Statement of Applicability (SoA)

Dieses Dokument belegt für alle 93 Controls des ISO 27001:2022 Annex A,
ob sie anwendbar sind und warum.

**Letztes Review:** [Datum]
**Freigabe:** [ISB, Datum]

## Legende
- ✅ Anwendbar und umgesetzt
- 🔄 Anwendbar, in Umsetzung
- ⏳ Anwendbar, geplant
- ❌ Nicht anwendbar (Begründung erforderlich)

## Controls (Auszug — vollständige Liste im Anhang)

| Control | Titel | Status | Begründung / Maßnahme |
|---------|-------|--------|----------------------|
| A.5.1 | IS-Leitlinien | ✅ | IS-Policy verabschiedet |
| A.5.9 | Asset-Inventar | 🔄 | DataGerry im Aufbau |
| A.5.15 | Zugangsteuerung | ✅ | Richtlinie und AD-Gruppen |
| A.8.13 | Backup | ✅ | Backup-Richtlinie, tägliche Sicherung |
| A.8.24 | Kryptographie | ✅ | Kryptographierichtlinie |
| … | … | … | … |

_Die vollständige SoA-Tabelle wird als separates Dokument gepflegt._
""")

    ch = create_chapter(book_hb, "Audit und Kontinuierliche Verbesserung",
                        "Auditprogramm, Managementbewertung, KVP")
    create_page(book_hb, ch, "Auditprogramm", """\
# Auditprogramm

## Internes Auditprogramm (aktuelles Jahr)

| Quartal | Auditbereich | Auditor | Status |
|---------|-------------|---------|--------|
| Q1 | Zugangsteuerung, Backup | | geplant |
| Q2 | Incident Management, Lieferanten | | geplant |
| Q3 | Risikomanagement, Awareness | | geplant |
| Q4 | Vollaudit (alle Bereiche) | | geplant |

## Zertifizierungsaudits

| Typ | Datum | Zertifizierungsstelle | Ergebnis |
|-----|-------|----------------------|---------|
| Stage 1 | | | |
| Stage 2 | | | |
| Überwachungsaudit 1 | | | |
| Rezertifizierungsaudit | | | |

## Auditberichte
_Auditberichte werden in diesem Kapitel abgelegt._
""")

# ══════════════════════════════════════════════════════════════════════════════
# Buch 2: Richtlinien-Bibliothek
# ══════════════════════════════════════════════════════════════════════════════

print("\n── Richtlinien-Bibliothek")
book_rl = create_book(
    "Richtlinien-Bibliothek",
    "Alle freigegebenen ISMS-Richtlinien und Verfahrensanweisungen",
    shelf_kern,
)
if book_rl:
    richtlinien = [
        ("Informationssicherheitsleitlinie",
         "Übergeordnetes Rahmenwerk (IS-Policy) — Ref: Kap. 5.2"),
        ("Zugangssteuerungsrichtlinie",
         "Need-to-know, RBAC, Privileged Access — Ref: A.5.15, A.8.2-8.5"),
        ("Kryptographierichtlinie",
         "Zugelassene Algorithmen, TLS-Mindestversionen, Schlüsselverwaltung — Ref: A.8.24"),
        ("Backup- und Wiederherstellungsrichtlinie",
         "3-2-1-Regel, RPO/RTO, Restore-Tests — Ref: A.8.13"),
        ("Incident-Response-Verfahren",
         "Klassifikation, Eskalation, NIS2-Meldefristen — Ref: A.5.24-5.28"),
        ("Lieferanten- und Dienstleisterrichtlinie",
         "Klassifizierung, Vertragsklauseln, Review-Zyklen — Ref: A.5.19-5.22"),
        ("Mobile-Device- und Telearbeitsrichtlinie",
         "BYOD, MDM, VPN-Pflicht — Ref: A.8.1, A.6.7"),
        ("Clear-Desk- und Clear-Screen-Richtlinie",
         "Bildschirmsperre, Druckverwaltung — Ref: A.7.7-7.8"),
        ("Passwort- und Authentifizierungsrichtlinie",
         "Passwortregeln, MFA-Pflicht, Privileged Accounts — Ref: A.8.2, A.8.5"),
        ("Notfallhandbuch",
         "BCM-Grundstruktur, Wiederanlaufpläne, Notfallkontakte — Ref: A.5.29-5.30"),
        ("NIS2-Meldepflicht-Verfahren",
         "24h/72h/30-Tage-Fristen, Meldewege an BSI — Ref: NIS2 Art. 23"),
    ]
    for name, desc in richtlinien:
        create_page(book_rl, None, name, f"""\
# {name}

> **Status:** Entwurf | **Version:** 1.0 | **Verantwortlich:** ISB
> **Gültig ab:** [Datum] | **Nächste Überprüfung:** [Datum]

_{desc}_

---

_Dieses Dokument wird aus dem Forgejo-Repository `isms/isms-policies` über die CI/CD-Pipeline veröffentlicht.
Änderungen bitte als Pull Request einreichen (4-Augen-Prinzip)._
""")

# ══════════════════════════════════════════════════════════════════════════════
# Buch 3: Risikoregister-Dokumentation
# ══════════════════════════════════════════════════════════════════════════════

print("\n── Risiken und Audits")
book_risk = create_book(
    "Risiken und Audits",
    "Auditberichte, Risikoübersichten und Behandlungspläne",
    shelf_kern,
)
if book_risk:
    create_chapter(book_risk, "Auditberichte", "Interne und externe Auditberichte")
    create_chapter(book_risk, "Risikoübersichten", "Exportierte Risikoregister-Snapshots aus OTOBO")
    create_chapter(book_risk, "Korrekturmaßnahmen", "Offene und abgeschlossene Findings")
    create_chapter(book_risk, "Managementbewertungen", "Protokolle der jährlichen Managementbewertungen")

# ══════════════════════════════════════════════════════════════════════════════
# Buch 4: Awareness & Schulung
# ══════════════════════════════════════════════════════════════════════════════

print("\n── Awareness & Schulung")
book_aw = create_book(
    "Awareness & Schulung",
    "Schulungsmaterialien, Sicherheitshinweise und Awareness-Inhalte für Mitarbeitende",
    shelf_aware,
)
if book_aw:
    ch = create_chapter(book_aw, "Grundlagenschulung",
                        "Pflichtinhalte für alle Mitarbeitenden")
    create_page(book_aw, ch, "Phishing erkennen und melden", """\
# Phishing erkennen und melden

## Was ist Phishing?
Phishing-E-Mails täuschen vertrauenswürdige Absender vor, um Zugangsdaten,
Bankverbindungen oder andere sensible Informationen zu stehlen.

## Typische Erkennungsmerkmale
- Unerwartete Aufforderung zur Passworteingabe oder Dateneingabe
- Absenderadresse weicht von bekannter Domain ab (z. B. `support@amaz0n.de`)
- Dringlichkeit und Drohungen („Ihr Konto wird gesperrt")
- Links führen auf fremde Domains (Mauszeiger drüberhalten!)
- Anhänge mit ungewöhnlichen Dateitypen (.exe, .iso, verschlüsselte ZIP)

## Was tun bei Verdacht?
1. **Nicht klicken** — weder auf Links noch auf Anhänge
2. **Sofort melden** an: security@[domain] oder Ticket in OTOBO (Queue: Incidents)
3. E-Mail als Spam markieren und löschen
4. Falls bereits geklickt: IT-Abteilung sofort anrufen

## Meldepflicht
Jeder Mitarbeitende ist verpflichtet, Phishing-Versuche zu melden —
auch wenn der Angriff nicht erfolgreich war. Frühwarnung schützt alle.
""")
    create_page(book_aw, ch, "Passwörter und MFA", """\
# Passwörter und Mehrfaktor-Authentifizierung

## Sichere Passwörter
- **Mindestlänge**: 12 Zeichen (16 für privilegierte Konten)
- Keine Wörter aus dem Wörterbuch, keine persönlichen Daten
- Empfehlung: Passphrase aus 4–5 zufälligen Wörtern (z. B. `Kaffee-Turm-Wolke-Regen`)
- Passwort-Manager nutzen (empfohlen: [Tool])

## Was verboten ist
- Passwörter teilen oder aufschreiben (Post-it, Excel)
- Dasselbe Passwort für mehrere Systeme
- Passwörter per E-Mail oder Chat übermitteln

## Mehrfaktor-Authentifizierung (MFA)
MFA ist **Pflicht** für:
- Alle Remote-Zugänge (VPN, Remote Desktop)
- Cloud-Dienste (Microsoft 365, Google Workspace)
- ISMS-Tools (Forgejo, OTOBO Admin)

Bei Verlust des zweiten Faktors: sofort IT melden.
""")
    create_page(book_aw, ch, "Social Engineering erkennen", """\
# Social Engineering erkennen

## Was ist Social Engineering?
Angreifer manipulieren Menschen, anstatt technische Schwachstellen auszunutzen.
Ziel: Zugangsdaten, interne Informationen oder unautorisierten Zugang erschleichen.

## Häufige Angriffsmuster

### Vishing (Telefonbetrug)
Jemand gibt sich als IT-Support, Bank oder Behörde aus und fordert Zugangsdaten.
**Regel:** Zugangsdaten werden niemals telefonisch abgefragt — auch nicht vom IT-Support.

### Pretexting
Ein Szenario wird erfunden (z. B. „dringender Audit"), um Informationen zu erhalten.

### Tailgating / Piggybacking
Unbefugte Personen folgen Mitarbeitenden durch Sicherheitstüren.
**Regel:** Niemanden ohne Ausweis in gesicherte Bereiche lassen — auch bei freundlichem Auftreten.

## Im Zweifel: ablehnen und melden
Es ist keine Unhöflichkeit, Identitäten zu prüfen. Verdächtige Kontaktaufnahmen
an den ISB melden: security@[domain]
""")

    ch = create_chapter(book_aw, "Spezialthemen", "Vertiefungsthemen für bestimmte Zielgruppen")
    create_page(book_aw, ch, "Sichere Heimarbeit", """\
# Sichere Heimarbeit

## Grundregeln für das Home Office

### Physische Sicherheit
- Bildschirm nicht einsehbar für Familienmitglieder oder Besucher
- Arbeitsunterlagen einschließen, wenn nicht in Benutzung
- Gespräche mit vertraulichen Inhalten in ruhiger, abgeschlossener Umgebung

### Netzwerk
- Nur VPN für Zugriff auf Unternehmensressourcen nutzen
- Heimrouter regelmäßig updaten, Standard-Passwort ändern
- Öffentliches WLAN nur mit aktivem VPN

### Geräte
- Firmenlaptop nicht für private Nutzung — kein gemeinsamer Einsatz mit Familie
- Bildschirmsperre bei jeder Abwesenheit (Windows: Win+L)
- Keine Daten auf private Cloud-Dienste (Dropbox, privates Google Drive)

## Bei technischen Problemen
IT-Helpdesk kontaktieren — nie selbst Sicherheits-Software deaktivieren.
""")

# ══════════════════════════════════════════════════════════════════════════════
# Buch 5: IT-Betriebsdokumentation
# ══════════════════════════════════════════════════════════════════════════════

print("\n── IT-Betrieb")
book_it = create_book(
    "IT-Betriebsdokumentation",
    "Systemdokumentation, Betriebsverfahren und technische Anleitungen",
    shelf_betrieb,
)
if book_it:
    create_chapter(book_it, "Systemarchitektur", "Netzwerkdiagramme, Systemübersichten")
    create_chapter(book_it, "Backup und Recovery", "Backup-Konfiguration, Restore-Protokolle")
    create_chapter(book_it, "Patch Management", "Patch-Zyklen, Ausnahmen, Protokolle")
    create_chapter(book_it, "Incident-Protokolle", "Technische Analysen und Post-Mortem-Berichte")

print("\n\033[32mBookStack Ersteinrichtung abgeschlossen.\033[0m")
PYEOF

success "BookStack Ersteinrichtung abgeschlossen."
