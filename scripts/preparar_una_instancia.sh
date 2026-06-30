#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Instalando dependencias base"
sudo apt update
sudo apt install -y git unzip curl wget jq libxml2-utils python3 python3-pip python3-venv

echo "[2/4] Preparando Python"
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "[3/4] Descargando datos oficiales"
./scripts/descargar_datos.sh

echo "[4/4] Preparación base completada"
echo "Para Wazuh ejecuta luego: ./scripts/instalar_wazuh_all_in_one.sh"
