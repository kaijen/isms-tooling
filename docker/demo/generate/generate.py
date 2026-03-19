#!/usr/bin/env python3
"""
ISMS Demo-Datengenerator via OpenRouter

Erzeugt realistische, organisationsspezifische ISMS-Dokumente:
Leitlinie, Richtlinien, Risiken, Auditberichte, Incidents

Verwendung:
  python generate.py --help
  python generate.py risks --count 8
  python generate.py all --org-file org.json
"""

import json
import os
import sys
from datetime import date, timedelta
from pathlib import Path

import click
from jinja2 import Environment, FileSystemLoader
from openai import OpenAI
from pydantic import BaseModel
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn

console = Console()
PROMPTS_DIR = Path(__file__).parent / "prompts"
OUTPUT_DIR  = Path(__file__).parent / "output"

# ---------------------------------------------------------------------------
# OpenRouter Client
# ---------------------------------------------------------------------------

def get_client() -> OpenAI:
    api_key = os.environ.get("OPENROUTER_API_KEY")
    if not api_key:
        console.print("[red]Fehler:[/red] OPENROUTER_API_KEY nicht gesetzt.")
        sys.exit(1)
    return OpenAI(
        base_url="https://openrouter.ai/api/v1",
        api_key=api_key,
        default_headers={
            "HTTP-Referer": "https://github.com/kaijen/isms-tooling",
            "X-Title": "ISMS Demo Generator",
        },
    )


def generate(client: OpenAI, model: str, prompt: str, json_mode: bool = False) -> str:
    kwargs = dict(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
    )
    if json_mode:
        kwargs["response_format"] = {"type": "json_object"}
        kwargs["temperature"] = 0.4

    response = client.chat.completions.create(**kwargs)
    return response.choices[0].message.content.strip()


# ---------------------------------------------------------------------------
# Kontext-Rendering
# ---------------------------------------------------------------------------

class OrgContext(BaseModel):
    org_name: str   = "Musterwerk GmbH"
    industry: str   = "Maschinenbau"
    size: str       = "250"
    nis2_scope: str = "Wichtige Einrichtung (Kategorie Fertigungssektor)"
    location: str   = "Deutschland"
    notes: str      = "Exportorientiert, starke IT-OT-Verflechtung, ISO 27001 Zertifizierung angestrebt"


def render_prompt(template_name: str, ctx: OrgContext, **kwargs) -> str:
    env = Environment(loader=FileSystemLoader(PROMPTS_DIR))
    context_tmpl = env.get_template("context.j2")
    context_str  = context_tmpl.render(**ctx.model_dump())

    tmpl = env.get_template(template_name)
    return tmpl.render(context=context_str, **kwargs)


def save(content: str, filename: str) -> Path:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    path = OUTPUT_DIR / filename
    path.write_text(content, encoding="utf-8")
    return path


# ---------------------------------------------------------------------------
# Generatoren
# ---------------------------------------------------------------------------

def gen_leitlinie(client, model, ctx):
    prompt = render_prompt("leitlinie.j2", ctx)
    with Progress(SpinnerColumn(), TextColumn("[cyan]Generiere Leitlinie...")) as p:
        p.add_task("")
        content = generate(client, model, prompt)
    path = save(content, "leitlinie.md")
    console.print(f"[green]✓[/green] Leitlinie → {path}")
    return path


def gen_policies(client, model, ctx, policies: list[str]):
    paths = []
    for policy_name in policies:
        prompt = render_prompt("policy.j2", ctx, policy_name=policy_name)
        with Progress(SpinnerColumn(), TextColumn(f"[cyan]Generiere Richtlinie: {policy_name}...")) as p:
            p.add_task("")
            content = generate(client, model, prompt)
        filename = policy_name.lower().replace(" ", "-").replace("/", "-") + ".md"
        path = save(content, f"policies/{filename}")
        console.print(f"[green]✓[/green] Richtlinie → {path}")
        paths.append(path)
    return paths


def gen_risks(client, model, ctx, count: int):
    prompt = render_prompt("risks.j2", ctx, count=count)
    with Progress(SpinnerColumn(), TextColumn(f"[cyan]Generiere {count} Risiken...")) as p:
        p.add_task("")
        raw = generate(client, model, prompt, json_mode=True)

    # JSON parsen und validieren
    try:
        risks = json.loads(raw)
        if isinstance(risks, dict):
            # Manche Modelle wrappen in {"risks": [...]}
            risks = next(iter(risks.values()))
    except json.JSONDecodeError as e:
        console.print(f"[red]JSON-Fehler:[/red] {e}\nRohausgabe:\n{raw[:500]}")
        sys.exit(1)

    path = save(json.dumps(risks, ensure_ascii=False, indent=2), "risks.json")
    console.print(f"[green]✓[/green] {len(risks)} Risiken → {path}")
    return path


def gen_audit_report(client, model, ctx, scope: str, auditor: str):
    today = date.today()
    prompt = render_prompt(
        "audit_report.j2", ctx,
        audit_scope=scope,
        audit_date=today.isoformat(),
        auditor=auditor,
    )
    with Progress(SpinnerColumn(), TextColumn(f"[cyan]Generiere Auditbericht: {scope}...")) as p:
        p.add_task("")
        content = generate(client, model, prompt)

    filename = f"audit-{scope.lower().replace(' ', '-')}-{today.year}.md"
    path = save(content, f"audits/{filename}")
    console.print(f"[green]✓[/green] Auditbericht → {path}")
    return path


def gen_incident(client, model, ctx, incident_type: str, severity: str):
    prompt = render_prompt("incident.j2", ctx,
                           incident_type=incident_type, severity=severity)
    with Progress(SpinnerColumn(), TextColumn(f"[cyan]Generiere Incident: {incident_type}...")) as p:
        p.add_task("")
        content = generate(client, model, prompt)

    filename = f"incident-{incident_type.lower().replace(' ', '-')}.md"
    path = save(content, f"incidents/{filename}")
    console.print(f"[green]✓[/green] Incident Report → {path}")
    return path


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

DEFAULT_MODEL   = "anthropic/claude-haiku-4-5"
DEFAULT_ORG     = str(Path(__file__).parent / "org.json")
DEFAULT_POLICIES = [
    "Zugriffssteuerung",
    "Passwort- und Authentifizierungsrichtlinie",
    "Backup und Wiederherstellung",
    "Mobile Endgeräte und Fernzugriff",
    "Incident Response",
]

def load_org(org_file: str) -> OrgContext:
    p = Path(org_file)
    if p.exists():
        return OrgContext(**json.loads(p.read_text()))
    console.print(f"[yellow]Hinweis:[/yellow] {org_file} nicht gefunden, verwende Standardwerte.")
    return OrgContext()


@click.group()
@click.option("--model", default=DEFAULT_MODEL, show_default=True,
              help="OpenRouter Modell-ID")
@click.option("--org-file", default=DEFAULT_ORG, show_default=True,
              help="JSON-Datei mit Organisationskontext")
@click.pass_context
def cli(ctx, model, org_file):
    """ISMS Demo-Datengenerator via OpenRouter."""
    ctx.ensure_object(dict)
    ctx.obj["model"]  = model
    ctx.obj["client"] = get_client()
    ctx.obj["org"]    = load_org(org_file)


@cli.command()
@click.pass_context
def leitlinie(ctx):
    """ISMS-Leitlinie generieren."""
    gen_leitlinie(ctx.obj["client"], ctx.obj["model"], ctx.obj["org"])


@cli.command()
@click.option("--names", multiple=True, default=DEFAULT_POLICIES,
              help="Richtliniennamen (mehrfach verwendbar)")
@click.pass_context
def policies(ctx, names):
    """Richtlinien generieren."""
    gen_policies(ctx.obj["client"], ctx.obj["model"], ctx.obj["org"], list(names))


@cli.command()
@click.option("--count", default=8, show_default=True, help="Anzahl Risiken")
@click.pass_context
def risks(ctx, count):
    """Risikoregister generieren."""
    gen_risks(ctx.obj["client"], ctx.obj["model"], ctx.obj["org"], count)


@cli.command()
@click.option("--scope",   default="Zugriffssteuerung und Identitätsmanagement",
              show_default=True)
@click.option("--auditor", default="Max Mustermann, ISB", show_default=True)
@click.pass_context
def audit(ctx, scope, auditor):
    """Internen Auditbericht generieren."""
    gen_audit_report(ctx.obj["client"], ctx.obj["model"], ctx.obj["org"], scope, auditor)


@cli.command()
@click.option("--type",     "incident_type", default="Ransomware-Angriff",
              show_default=True)
@click.option("--severity", default="Hoch",
              type=click.Choice(["Niedrig", "Mittel", "Hoch", "Kritisch"]),
              show_default=True)
@click.pass_context
def incident(ctx, incident_type, severity):
    """Incident Report generieren."""
    gen_incident(ctx.obj["client"], ctx.obj["model"], ctx.obj["org"],
                 incident_type, severity)


@cli.command()
@click.option("--risk-count", default=8, show_default=True)
@click.pass_context
def all(ctx, risk_count):
    """Alle Inhalte generieren (Leitlinie, Richtlinien, Risiken, Audit, Incidents)."""
    client = ctx.obj["client"]
    model  = ctx.obj["model"]
    org    = ctx.obj["org"]

    console.rule("[bold]ISMS Demo-Datengenerator[/bold]")
    console.print(f"Modell:       {model}")
    console.print(f"Organisation: {org.org_name} ({org.industry})")
    console.print(f"Ausgabe:      {OUTPUT_DIR}\n")

    gen_leitlinie(client, model, org)
    gen_policies(client, model, org, DEFAULT_POLICIES)
    gen_risks(client, model, org, risk_count)
    gen_audit_report(client, model, org,
                     "Zugriffssteuerung und Identitätsmanagement", "ISB")
    gen_audit_report(client, model, org,
                     "Backup und Notfallvorsorge", "Externer Auditor")
    gen_incident(client, model, org, "Phishing-Angriff mit Datenverlust", "Hoch")
    gen_incident(client, model, org, "Ransomware-Verschlüsselung", "Kritisch")

    console.rule("[bold green]Fertig[/bold green]")
    console.print(f"\nAlle Dateien unter: [cyan]{OUTPUT_DIR}[/cyan]")
    console.print("Nächster Schritt: Ausgaben als Seed-Daten verwenden:\n")
    console.print("  cp output/risks.json ../data/risks.json")
    console.print("  cp output/policies/* ../data/policies/")


if __name__ == "__main__":
    cli()
