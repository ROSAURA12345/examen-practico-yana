#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y curl tar unzip jq libxml2-utils
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
sudo systemctl status wazuh-manager --no-pager
sudo systemctl status wazuh-indexer --no-pager
sudo systemctl status wazuh-dashboard --no-pager
