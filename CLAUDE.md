# ISMS-Tooling Projekt

## Zweck

Konzept zur Umsetzung eines ISMS mit Open-Source-Werkzeugen und einfachen Mitteln.
Zielgruppe: NIS2-betroffene Organisationen (Neueinstieg oder Modernisierung) und deren Supplier.
Normbezug: ISO 27001. Ziel: pragmatische Zertifizierungsreife.

## Veröffentlichung

Jekyll auf GitHub Pages. Markdown als primäres Format.
`baseurl: /isms-tooling` — bei Änderung des Repo-Namens in `_config.yml` anpassen.

## Struktur

| Datei | Inhalt |
|-------|--------|
| `index.md` | Einstiegsseite |
| `konzept.md` | Leitprinzipien, Anforderungen, Zertifizierungsreife — **fertig** |
| `szenarien.md` | Konkrete Werkzeugkombinationen — **noch nicht begonnen** |

## Leitprinzipien (Thesen)

1. Git für Versionskontrolle und Freigaben (PR = Vier-Augen-Prinzip)
2. Static Site Generator für Dokumentenveröffentlichung (CI/CD als Freigabe-Trigger)
3. Git-Clones als dezentrales Notfall-Backup
4. Tickets für Aufgabenplanung (Templates, Wiederkehrende Aufgaben)
5. Risikomanagement als endlicher Automat im Ticket-System (Attribute, Statusübergänge, Reporting durch Filterung)
6. Risiko- und Behandlungs-Tickets logisch verknüpft, werkzeugmäßig unabhängig
7. KI-Unterstützung senkt Disziplinaufwand ohne Verantwortung zu delegieren

## Szenarien (geplant, noch nicht ausgearbeitet)

| Szenario | Ausgangslage |
|----------|-------------|
| A | Greenfield, NIS2-betroffen |
| B | Supplier, KMU, begrenzte Ressourcen |
| C | Modernisierung von Legacy-Strukturen (Word, SharePoint) |

Alle Szenarien mit Blick auf pragmatische Zertifizierungsreife.
Werkzeugbewertung erfolgt nach Abschluss der Theorie.

## Offene Entscheidungen

- Welche konkreten Tools je Szenario (Gitea vs. GitLab, Plane vs. andere Ticket-Systeme etc.)
- Szenarien ausformulieren
