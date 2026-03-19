#!/usr/bin/env bash
# Szenario A – Wekan: ISMS-Template-Boards anlegen
#
# Erstellt zwei Boards:
#   1. ISMS-Aufbau    – phasenbasierte Roadmap mit ~60 Aufgaben (ISO 27001-Einführung)
#   2. ISMS-Betrieb   – Kanban für wiederkehrende Betriebsaufgaben
#
# Spalten des Aufbau-Boards entsprechen ISO-27001-Phasen; jede Karte trägt
# eine Kurzbeschreibung mit Normreferenz.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../demo/lib.sh"
source "${SCRIPT_DIR}/../.env"

WEKAN_URL="https://board.${DOMAIN}"

step "Wekan – Warte auf Service"
wait_for_http "${WEKAN_URL}" "Wekan"

step "Wekan – Login"
wekan_login

step "Wekan – Template-Boards anlegen"

python3 - "${WEKAN_URL}" "${WEKAN_TOKEN}" "${WEKAN_USER_ID}" << 'PYEOF'
import sys
import json
import urllib.request
import urllib.error

base_url, token, user_id = sys.argv[1:]

HEADERS = {
    "Authorization": f"Bearer {token}",
    "Content-Type":  "application/json",
}

def api(method, path, data=None):
    body = json.dumps(data).encode() if data else None
    req  = urllib.request.Request(
        f"{base_url}{path}", data=body, headers=HEADERS, method=method
    )
    try:
        with urllib.request.urlopen(req) as r:
            return json.load(r)
    except urllib.error.HTTPError as e:
        print(f"  WARN  {method} {path}: {e} – {e.read().decode()[:120]}")
        return {}

def create_board(title, color):
    r = api("POST", "/api/boards", {"title": title, "permission": "private", "color": color})
    bid = r.get("_id", "")
    if bid:
        print(f"  OK    Board '{title}' ({bid})")
    else:
        print(f"  ERR   Board '{title}'")
    # Wekan legt automatisch eine Default-Liste an – löschen wir sie später nicht,
    # aber wir ignorieren sie bei den eigenen Listen.
    return bid

def create_list(board_id, title):
    r = api("POST", f"/api/boards/{board_id}/lists", {"title": title})
    return r.get("_id", "")

def create_card(board_id, list_id, title, description=""):
    api("POST", f"/api/boards/{board_id}/lists/{list_id}/cards", {
        "title":       title,
        "authorId":    user_id,
        "description": description,
    })

# ══════════════════════════════════════════════════════════════════════════════
# Board 1: ISMS-Aufbau — phasenbasierte Roadmap
# ══════════════════════════════════════════════════════════════════════════════

AUFBAU_LISTS = [

    ("Phase 1: Scope & Kontext", [
        ("Geltungsbereich (Scope) definieren",
         "Physische, organisatorische und technische Grenzen des ISMS festlegen. "
         "Standorte, Organisationseinheiten, Produkte/Dienstleistungen im Scope benennen. "
         "Ref: ISO 27001:2022 Kap. 4.3"),
        ("Organisationskontext analysieren",
         "Interne Faktoren (Kultur, Strukturen, Prozesse) und externe Faktoren "
         "(Markt, Regulierung, Technologie) ermitteln. "
         "Ref: Kap. 4.1"),
        ("Interessierte Parteien bestimmen",
         "Kunden, Behörden, Lieferanten, Eigentümer, Mitarbeitende – Anforderungen "
         "und Erwartungen jeder Partei dokumentieren. "
         "Ref: Kap. 4.2"),
        ("Regulatorische Anforderungen ermitteln",
         "NIS2-Pflichten prüfen (Art. 21 Sicherheitsmaßnahmen, Art. 23 Meldepflichten), "
         "DSGVO-Berührungspunkte identifizieren, branchenspezifische Vorgaben erfassen."),
        ("Lieferkette im Scope festlegen",
         "Kritische Lieferanten und Dienstleister bestimmen, Tiefe der Lieferkette "
         "abgrenzen. Ref: A.5.19-5.21"),
        ("Scope-Dokument erstellen und freigeben",
         "Formales Scope-Statement verfassen, durch Management genehmigen lassen "
         "und in BookStack veröffentlichen."),
    ]),

    ("Phase 2: Führung & Planung", [
        ("Management-Commitment dokumentieren",
         "Erklärung der Unternehmensführung zur Unterstützung des ISMS einholen "
         "(Unterschrift IS-Leitlinie). Ref: Kap. 5.1"),
        ("ISB benennen",
         "Informationssicherheitsbeauftragten formal ernennen, Aufgaben, Befugnisse "
         "und Berichtslinie schriftlich festlegen. Ref: Kap. 5.3"),
        ("ISMS-Rollen und Verantwortlichkeiten definieren",
         "RACI-Matrix für ISMS-Kernfunktionen (Risikoeigner, Prozessverantwortliche, "
         "Systemverantwortliche) erstellen. Ref: Kap. 5.3"),
        ("ISMS-Projektteam zusammenstellen",
         "Kernteam aus IT, HR, Recht, Fachabteilungen. Steuerungskomitee einrichten "
         "für Eskalation und Grundsatzentscheidungen."),
        ("Projektplan mit Meilensteinen erstellen",
         "Phasen, Termine, Abhängigkeiten und Verantwortliche festlegen. "
         "Zieldatum für Zertifizierungsaudit definieren."),
        ("Budget und Ressourcenplan freigeben",
         "Personal, Werkzeuge, externe Berater, Zertifizierungskosten schätzen "
         "und Budget durch Management genehmigen lassen. Ref: Kap. 7.1"),
        ("ISMS-Kommunikationsplan erstellen",
         "Wer kommuniziert was, wann, an wen (intern/extern). "
         "Eskalationswege und Meldepflichten einschließen. Ref: Kap. 7.4"),
    ]),

    ("Phase 3: Bestandsaufnahme", [
        ("Asset-Inventar aufbauen (DataGerry)",
         "Informationsassets, IT-Systeme, Prozesse, Räumlichkeiten in DataGerry erfassen. "
         "Verantwortliche und Schutzbedarf je Asset dokumentieren. Ref: A.5.9"),
        ("Informationsassets klassifizieren",
         "VIV-Schema anwenden (Vertraulichkeit / Integrität / Verfügbarkeit), "
         "Klassifizierungsstufen definieren (öffentlich / intern / vertraulich / geheim). "
         "Ref: A.5.12-5.13"),
        ("Gap-Analyse gegen ISO 27001:2022 Annex A",
         "Alle 93 Controls des Annex A prüfen: vorhanden / teilweise / fehlend. "
         "Grundlage für das Statement of Applicability und Prioritätensetzung."),
        ("Bestehende Sicherheitsmaßnahmen inventarisieren",
         "Technische (Firewall, AV, Backups) und organisatorische Maßnahmen "
         "(Richtlinien, Schulungen) erfassen und Reifegrad bewerten."),
        ("Lieferanten- und Partnerübersicht erstellen",
         "Alle Lieferanten, Cloud-Anbieter, Outsourcing-Partner mit Kritikalität, "
         "Vertragsart und Sicherheitsanforderungen dokumentieren. Ref: A.5.19"),
        ("Netzwerkarchitektur und Systemlandschaft dokumentieren",
         "Netzwerkdiagramm, Segmentierung, externe Verbindungen, DMZ, "
         "Remote-Access-Lösungen dokumentieren. Ref: A.8.20-8.22"),
        ("Kritische Prozesse und Abhängigkeiten identifizieren",
         "Business-Impact-Analyse (BIA): welche Prozesse bei Ausfall kritisch sind, "
         "RTO/RPO je Prozess festlegen. Ref: A.5.29-5.30"),
        ("Datenflüsse und Verarbeitungsverzeichnis erstellen",
         "Personenbezogene Daten und deren Flüsse dokumentieren (DSGVO Art. 30). "
         "Schnittstellen zu Drittsystemen erfassen."),
    ]),

    ("Phase 4: Risikomanagement", [
        ("Risikobeurteilungsmethodik festlegen",
         "Bewertungsmatrix (Wahrscheinlichkeit × Schadenshöhe, je 1–4), "
         "Risikowert-Berechnung, Schwellenwerte für Risikoakzeptanz dokumentieren. "
         "Ref: Kap. 6.1.2"),
        ("Risikoakzeptanzkriterien definieren",
         "Welche Risikowerte akzeptiert das Management ohne Behandlung? "
         "Formale Genehmigung des Akzeptanzniveaus einholen. Ref: Kap. 6.1.2c"),
        ("Erstmalige Risikoidentifikation durchführen",
         "Bedrohungen und Schwachstellen je Asset/Prozess systematisch identifizieren "
         "(Workshops, Checklisten, Threat-Intelligence). Ref: Kap. 6.1.2"),
        ("Risikobewertung durchführen",
         "Eintrittswahrscheinlichkeit und Schadenshöhe je Risiko bewerten, "
         "Risikowert berechnen, Risiken priorisieren. Ref: Kap. 6.1.2"),
        ("Risikoregister in OTOBO aufbauen",
         "Alle identifizierten Risiken als Tickets anlegen "
         "(Queues: Risiken::Strategisch / ::Operativ / ::Technisch), "
         "Dynamic Fields befüllen."),
        ("Risikobehandlungsoptionen festlegen",
         "Je Risiko: behandeln (Maßnahme) / akzeptieren / übertragen (Versicherung) / "
         "vermeiden. Risikobehandlungsplan (RTP) erstellen. Ref: Kap. 6.1.3"),
        ("Statement of Applicability (SoA) erstellen",
         "Alle 93 Annex-A-Controls: anwendbar / nicht anwendbar, "
         "Begründung, Umsetzungsstatus. Pflichtdokument für Zertifizierung. "
         "Ref: Kap. 6.1.3d"),
        ("Restrisiken durch Management genehmigen lassen",
         "Alle akzeptierten Risiken und Restrisiken nach Behandlung formell "
         "durch autorisierte Führungskräfte genehmigen lassen. Ref: Kap. 6.1.3e"),
    ]),

    ("Phase 5: Richtlinien & Dokumentation", [
        ("Informationssicherheitsleitlinie (IS-Policy)",
         "Übergeordnetes Rahmenwerk: Ziele, Grundsätze, Rollen, Geltungsbereich. "
         "Durch Geschäftsleitung unterzeichnen, allen Mitarbeitenden bekannt machen. "
         "Ref: Kap. 5.2"),
        ("Zugangssteuerungsrichtlinie",
         "Need-to-know-Prinzip, Rollen- und rechtebasierter Zugriff, "
         "Privileged Access Management, Passwortregeln. Ref: A.5.15, A.8.2-8.5"),
        ("Kryptographierichtlinie",
         "Vorgaben zu Verschlüsselungsalgorithmen, Schlüssellängen, Zertifikatsverwaltung, "
         "TLS-Mindestversionen. Ref: A.8.24"),
        ("Backup- und Wiederherstellungsrichtlinie",
         "Backup-Häufigkeit, Aufbewahrungsdauer, Offsite-Kopien, Verschlüsselung, "
         "Wiederherstellungstests (mindestens jährlich). Ref: A.8.13"),
        ("Incident-Response-Verfahren",
         "Erkennung, Meldung, Klassifikation, Reaktion, Dokumentation, Lessons-Learned. "
         "NIS2-Meldepflichten integrieren (24h / 72h / 1 Monat). Ref: A.5.24-5.28"),
        ("Lieferantenrichtlinie",
         "Sicherheitsanforderungen an Lieferanten, Vertragsklauseln, "
         "Überprüfungsintervalle, Offboarding-Prozess. Ref: A.5.19-5.22"),
        ("Mobile-Device- und BYOD-Richtlinie",
         "MDM-Anforderungen, erlaubte Geräte, Remote-Wipe, Datentrennung, "
         "private vs. geschäftliche Nutzung. Ref: A.8.1"),
        ("Clear-Desk- / Clear-Screen-Policy",
         "Bildschirmsperren, Sperren bei Abwesenheit, Umgang mit Ausdrucken, "
         "Shredder-Pflicht für sensible Dokumente. Ref: A.7.7-7.8"),
        ("Notfallhandbuch (BCM-Grundstruktur)",
         "Notfallkontakte, Eskalationskette, Wiederanlaufpläne für kritische Prozesse, "
         "Kommunikation im Krisenfall. Ref: A.5.29-5.30"),
        ("Dokumentenlenkungsverfahren",
         "Versionierung, Freigabeprozess (4-Augen via Forgejo PR), Überprüfungsintervalle, "
         "Verteilung und Zugang zu Richtlinien. Ref: Kap. 7.5"),
    ]),

    ("Phase 6: Technische Controls", [
        ("MFA für alle privilegierten Konten aktivieren",
         "Admin-Zugänge zu Servern, Cloud-Diensten, ISMS-Tools mit "
         "zweitem Faktor sichern. Ref: A.8.5"),
        ("Patch-Management-Prozess einrichten",
         "Inventar patching-relevanter Systeme, Patch-Zyklus (kritisch ≤72h, "
         "hoch ≤30 Tage), Testumgebung, Dokumentation. Ref: A.8.8"),
        ("Backup-Lösung einrichten und Wiederherstellungstest dokumentieren",
         "3-2-1-Regel umsetzen, Verschlüsselung prüfen, ersten Restore-Test "
         "durchführen und protokollieren. Ref: A.8.13"),
        ("Logging und SIEM konfigurieren",
         "Zentrales Log-Management: Authentifizierungen, Admin-Aktionen, "
         "Zugriffe auf kritische Daten, Aufbewahrung ≥12 Monate. Ref: A.8.15-8.16"),
        ("Vulnerability-Scanning einrichten",
         "Regelmäßige Schwachstellen-Scans der exponierten Systeme, "
         "Ergebnisse in OTOBO-Tickets überführen. Ref: A.8.8"),
        ("Netzwerksegmentierung und Firewall-Regeln prüfen",
         "Produktions- von Entwicklungsumgebungen trennen, "
         "Least-Privilege für Netzwerkzugriffe umsetzen. Ref: A.8.20-8.22"),
        ("E-Mail-Sicherheit konfigurieren",
         "SPF, DKIM, DMARC einrichten; Anti-Phishing-Filter aktivieren; "
         "Link-Scanning prüfen. Ref: A.8.23"),
        ("Removable-Media-Kontrolle umsetzen",
         "USB-Richtlinie durchsetzen (MDM/GPO), Verschlüsselungspflicht für "
         "mobile Datenträger. Ref: A.8.10"),
    ]),

    ("Phase 7: Awareness & Schulung", [
        ("Schulungsbedarfsanalyse und Schulungsplan erstellen",
         "Zielgruppen (alle MA, IT, Führungskräfte, ISB) und Schulungsinhalte "
         "je Gruppe festlegen. Ref: Kap. 7.2, A.6.3"),
        ("Schulungsmaterialien entwickeln (BookStack)",
         "E-Learning-Einheiten oder Präsenzunterlagen zu Phishing, Passwörtern, "
         "Social Engineering, Meldewegen in BookStack erstellen."),
        ("Pflicht-Awareness-Schulung durchführen",
         "Alle Mitarbeitenden schulen, Teilnahme mit Liste dokumentieren "
         "(Nachweis für Audit). Ref: A.6.3"),
        ("Phishing-Simulation planen und auswerten",
         "Simulierten Phishing-Angriff durchführen, Klickrate messen, "
         "Schwachstellen identifizieren, Nachschulung für Betroffene."),
        ("ISB und IT-Admins vertieft schulen",
         "Technische Schulungen: Incident Response, Forensik-Grundlagen, "
         "ISO-27001-Normkenntnisse für interne Auditoren."),
        ("Onboarding-Prozess um ISMS-Baustein erweitern",
         "Neue Mitarbeitende erhalten am ersten Arbeitstag ISMS-Einweisung "
         "und unterzeichnen Vertraulichkeitserklärung. Ref: A.6.2"),
    ]),

    ("Phase 8: Audit & Zertifizierung", [
        ("Internes Auditprogramm erstellen",
         "Auditplan für das Jahr: Scope, Kriterien, Häufigkeit, Auditoren je Bereich. "
         "Unabhängigkeit der internen Auditoren sicherstellen. Ref: Kap. 9.2"),
        ("Interne Auditoren qualifizieren",
         "Schulung zu ISO 19011 (Auditierung von Managementsystemen), "
         "erste Audits unter Anleitung durchführen."),
        ("Internes Audit: Dokumentenprüfung",
         "Vollständigkeit und Aktualität aller Pflichtdokumente prüfen "
         "(Scope, SoA, Risikoregister, RTP, Richtlinien, Aufzeichnungen)."),
        ("Internes Audit: Prozessaudit",
         "Interviews, Begehungen, Stichproben: Werden die Richtlinien gelebt? "
         "Findings in OTOBO (Queue: Aufgaben::Audit) erfassen."),
        ("Auditbericht erstellen und Korrekturmaßnahmen ableiten",
         "Findings klassifizieren (Major / Minor NC / Beobachtung), "
         "Korrekturmaßnahmen mit Verantwortlichen und Terminen festlegen. Ref: Kap. 10.1"),
        ("Managementbewertung durchführen",
         "Eingangsgrößen: Auditberichte, Risiken, KPIs, Vorfälle, Verbesserungsvorschläge. "
         "Protokoll mit Entscheidungen und Maßnahmen. Ref: Kap. 9.3"),
        ("Zertifizierungsstelle auswählen und beauftragen",
         "Akkreditierte Zertifizierungsstelle (DAkkS) anfragen, Angebote vergleichen, "
         "Stage-1- und Stage-2-Audit terminieren."),
        ("Stage-1-Audit (Dokumentenprüfung) absolvieren",
         "Zertifizierungsauditor prüft Dokumentation auf Vollständigkeit. "
         "Festgestellte Lücken vor Stage 2 schließen."),
        ("Stage-2-Audit (Hauptaudit) absolvieren",
         "Vor-Ort-Audit: Interviews, Prozessbegehungen, technische Stichproben. "
         "Nonconformities innerhalb vereinbarter Frist abarbeiten."),
        ("Zertifikat erhalten und kommunizieren",
         "ISO-27001-Zertifikat archivieren, intern und extern kommunizieren, "
         "Überwachungsaudits (jährlich) und Rezertifizierung (3 Jahre) einplanen."),
    ]),
]

# ══════════════════════════════════════════════════════════════════════════════
# Board 2: ISMS-Betrieb — Kanban für wiederkehrende Aufgaben
# ══════════════════════════════════════════════════════════════════════════════

BETRIEB_LISTS = [

    ("Kontinuierlich", [
        ("Neue Risiken in OTOBO melden und bewerten",
         "Jede identifizierte Bedrohung sofort als Ticket erfassen "
         "(Queue je Risikoebene), Erstbewertung innerhalb von 5 Arbeitstagen."),
        ("Sicherheitsvorfälle bearbeiten und dokumentieren",
         "Incidents nach Verfahren klassifizieren, behandeln, schließen. "
         "NIS2-Meldepflichten beachten (24h / 72h / 1 Monat)."),
        ("Richtlinien bei Änderungen aktualisieren",
         "Jede relevante Organisations- oder Systemänderung prüfen: "
         "betroffene Richtlinien identifizieren, PR in Forgejo erstellen."),
        ("Zugriffsrechte bei Personaländerungen anpassen",
         "Onboarding / Offboarding / Rollenwechsel: Rechte zeitnah anpassen, "
         "privilegierte Zugänge sofort deaktivieren. Ref: A.5.18"),
    ]),

    ("Monatlich", [
        ("Risikoregister reviewen",
         "Offene Risiken auf Statusänderungen prüfen, neue Risiken aufnehmen, "
         "abgeschlossene Maßnahmen bestätigen."),
        ("Offene Incidents und Maßnahmen nachverfolgen",
         "OTOBO-Tickets in Queues Incidents und Aufgaben:: prüfen, "
         "überfällige Tickets eskalieren."),
        ("Patch-Status kritischer Systeme prüfen",
         "Ungepatche kritische Schwachstellen identifizieren, "
         "sofortige Maßnahmen einleiten."),
        ("Backup-Protokolle auswerten",
         "Backup-Logs auf Fehler prüfen, stichprobenartige Wiederherstellungstests "
         "dokumentieren."),
    ]),

    ("Quartalsweise", [
        ("Vulnerability-Scan durchführen und auswerten",
         "Scan der exponierten Systeme, neue Findings in OTOBO erfassen, "
         "Prioritäten setzen."),
        ("Zugriffsberechtigungen prüfen (Access Review)",
         "Rezertifizierung aller Berechtigungen durch Dateneigner – "
         "unnötige Rechte entfernen. Ref: A.5.18"),
        ("KPI-Report erstellen",
         "Kennzahlen: offene Risiken je Ebene, Incidents nach Typ, "
         "Patch-Coverage, Schulungsquote – an Management berichten."),
        ("Mini-Audit (Stichproben)",
         "2-3 Kontrollen aus Annex A stichprobenartig prüfen, "
         "Findings dokumentieren und nachverfolgen."),
    ]),

    ("Jährlich", [
        ("Vollständige Risikobeurteilung wiederholen",
         "Alle Risiken neu bewerten, neue Bedrohungslagen berücksichtigen, "
         "SoA aktualisieren. Ref: Kap. 6.1.2"),
        ("Alle Richtlinien reviewen und freigeben",
         "Jede Richtlinie auf Aktualität prüfen, PR in Forgejo, "
         "Freigabe durch Verantwortlichen. Ref: Kap. 7.5"),
        ("Awareness-Pflichtschulung wiederholen",
         "Jährliche Pflichtschulung für alle Mitarbeitenden, "
         "neue Bedrohungsthemen aufnehmen, Teilnahme dokumentieren. Ref: A.6.3"),
        ("Internes Vollaudit durchführen",
         "Gesamtes ISMS gegen ISO 27001 auditieren, "
         "Auditbericht und Korrekturmaßnahmen. Ref: Kap. 9.2"),
        ("Managementbewertung durchführen",
         "Alle Eingangsgrößen zusammenstellen, Sitzung protokollieren, "
         "Verbesserungsmaßnahmen beauftragen. Ref: Kap. 9.3"),
        ("Notfallübung / BCM-Test durchführen",
         "Wiederherstellungsszenarien testen (Datenverlust, Ausfall kritischer Systeme), "
         "Ergebnisse dokumentieren, Plan aktualisieren. Ref: A.5.29-5.30"),
        ("Überwachungsaudit (Zertifizierungsstelle) vorbereiten",
         "Unterlagen zusammenstellen, interne Vorbereitung, "
         "Findings des Vorjahres nachweislich geschlossen."),
    ]),
]

# ══════════════════════════════════════════════════════════════════════════════
# Board anlegen (generisch)
# ══════════════════════════════════════════════════════════════════════════════

def build_board(title, color, lists_data):
    bid = create_board(title, color)
    if not bid:
        return
    for list_title, cards in lists_data:
        lid = create_list(bid, list_title)
        if not lid:
            print(f"  ERR   Liste '{list_title}'")
            continue
        print(f"  OK    Liste '{list_title}' ({len(cards)} Karten)")
        for card_title, description in cards:
            create_card(bid, lid, card_title, description)

print("\n── Board 1: ISMS-Aufbau")
build_board("ISMS-Aufbau", "belize", AUFBAU_LISTS)

print("\n── Board 2: ISMS-Betrieb")
build_board("ISMS-Betrieb", "emerald", BETRIEB_LISTS)

print("\nFertig.")
PYEOF

success "Wekan ISMS-Template vollständig angelegt."
