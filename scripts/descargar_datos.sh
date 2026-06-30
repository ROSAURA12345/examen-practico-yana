#!/usr/bin/env bash
set -euo pipefail

mkdir -p lab1 lab2 lab3

base="https://raw.githubusercontent.com/abelthf/examen_final_seguridad_informatica/main"

download() {
  local url="$1"
  local out="$2"
  echo "Descargando $out"
  if command -v curl >/dev/null 2>&1; then
    curl -L --fail -o "$out" "$url"
  else
    wget -O "$out" "$url"
  fi
}

download "$base/lab1/auth.log" "lab1/auth.log"
download "$base/lab1/access.log" "lab1/access.log"
download "$base/lab3/network_traffic.csv" "lab3/network_traffic.csv"

# Se conserva un simulador local corregido en lab2/simular_bruteforce.sh.
chmod +x lab2/simular_bruteforce.sh || true

echo "[OK] Datos base descargados."
ls -lh lab1/auth.log lab1/access.log lab3/network_traffic.csv
