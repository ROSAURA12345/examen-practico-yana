#!/usr/bin/env bash
set -euo pipefail

ATTACKER_IP="${1:-203.0.113.60}"
COUNT="${2:-15}"

if [[ $EUID -ne 0 ]]; then
  echo "Ejecuta con sudo para escribir en /var/log/auth.log"
  exit 1
fi

echo "Simulando $COUNT intentos SSH fallidos desde $ATTACKER_IP"
for i in $(seq 1 "$COUNT"); do
  echo "$(date '+%b %d %H:%M:%S') $(hostname) sshd[9999]: Failed password for invalid user atacante from ${ATTACKER_IP} port 51434 ssh2" >> /var/log/auth.log
  echo "[$i/$COUNT] Failed password from ${ATTACKER_IP}"
  sleep 1
done

echo "Listo. Revisa: sudo grep -nE \"100001|Ataque de fuerza bruta|${ATTACKER_IP}\" /var/ossec/logs/alerts/alerts.log | tail -n 80"
