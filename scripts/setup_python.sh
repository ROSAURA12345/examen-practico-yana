#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git unzip curl wget jq libxml2-utils
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
python --version
pip freeze | tee versiones_python.txt
