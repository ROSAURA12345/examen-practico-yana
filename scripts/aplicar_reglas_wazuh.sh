#!/usr/bin/env bash
set -euo pipefail

sudo apt install -y libxml2-utils >/dev/null 2>&1 || true
xmllint --noout lab2/local_rules_ssh.xml && echo "local_rules_ssh.xml OK"
xmllint --noout lab2/local_rules_exfil.xml && echo "local_rules_exfil.xml OK"

sudo cp lab2/local_rules_ssh.xml /var/ossec/etc/rules/
sudo cp lab2/local_rules_exfil.xml /var/ossec/etc/rules/

# Asegura lectura de auth.log si no existe en ossec.conf
if ! sudo grep -q "/var/log/auth.log" /var/ossec/etc/ossec.conf; then
  sudo cp /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.bak
  sudo sed -i '/<\/ossec_config>/i\
  <localfile>\
    <log_format>syslog</log_format>\
    <location>/var/log/auth.log</location>\
  </localfile>' /var/ossec/etc/ossec.conf
fi

sudo systemctl restart wazuh-manager
sudo systemctl status wazuh-manager --no-pager
