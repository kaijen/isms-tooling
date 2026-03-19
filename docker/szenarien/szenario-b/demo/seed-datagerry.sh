#!/usr/bin/env bash
# Szenario B – DataGerry: Minimales Schema (Informationsasset, Dienstleister)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Wiederverwendung des vollständigen Szenario-A-Skripts — identische API
exec bash "${SCRIPT_DIR}/../../szenario-a/demo/seed-datagerry.sh" "$@"
