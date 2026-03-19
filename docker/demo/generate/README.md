# ISMS Demo-Datengenerator

Erzeugt realistische, organisationsspezifische ISMS-Dokumente via
[OpenRouter](https://openrouter.ai) (OpenAI-kompatible API, Zugang zu Claude,
GPT-4, Mistral u.a.).

## Warum KI-generierte Daten?

Statische Beispieldaten sind generisch und überzeugen in Demos nicht.
Der Generator erzeugt auf Branche, Größe und NIS2-Scope zugeschnittene Inhalte —
ein Maschinenbauer bekommt andere Risiken als ein Krankenhaus oder eine Behörde.

## Voraussetzungen

```bash
pip install -r requirements.txt
export OPENROUTER_API_KEY=sk-or-...
```

API-Key unter https://openrouter.ai/keys erstellen (kostenfreies Guthaben vorhanden).

## Organisationskontext

```bash
cp org.json.example org.json
$EDITOR org.json   # Branche, Größe, NIS2-Scope anpassen
```

## Verwendung

```bash
# Alle Inhalte auf einmal
python generate.py all

# Einzelne Dokumenttypen
python generate.py leitlinie
python generate.py policies
python generate.py risks --count 10
python generate.py audit --scope "Backup und Notfallvorsorge"
python generate.py incident --type "Ransomware-Angriff" --severity Kritisch

# Anderes Modell (günstiger/schneller)
python generate.py --model mistralai/mistral-7b-instruct risks --count 5

# Vollständige Modell-Liste: https://openrouter.ai/models
```

## Empfohlene Modelle

| Modell | Qualität | Kosten | Eignung |
|--------|----------|--------|---------|
| `anthropic/claude-3.5-haiku` | Sehr gut | Gering | Standard-Empfehlung |
| `anthropic/claude-3.5-sonnet` | Exzellent | Mittel | Lange Dokumente, Audit-Reports |
| `mistralai/mistral-7b-instruct` | Gut | Sehr gering | Risiken, strukturierte Daten |
| `google/gemini-flash-1.5` | Gut | Sehr gering | Schnelle Iteration |

## Ausgabe

Alle generierten Dateien landen unter `output/`:

```
output/
├── leitlinie.md
├── policies/
│   ├── zugriffssteuerung.md
│   ├── backup-und-wiederherstellung.md
│   └── ...
├── risks.json
├── audits/
│   └── audit-zugriffssteuerung-2025.md
└── incidents/
    ├── incident-phishing-angriff.md
    └── incident-ransomware.md
```

## Integration mit Seed-Skripten

Nach der Generierung Ausgaben als Seed-Daten übernehmen:

```bash
python generate.py all

# Risiken und Policies als Seed-Daten
cp output/risks.json ../data/risks.json
cp output/policies/*.md ../data/policies/

# Dann normalen Seed-Workflow ausführen
cd ../szenarien/szenario-a
./demo/seed-all.sh
```

Auditberichte und Incidents können direkt in Forgejo eingecheckt oder
manuell in OTOBO/BookStack importiert werden.
