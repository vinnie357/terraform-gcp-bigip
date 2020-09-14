#!/bin/bash
# install tools for container standup
echo "cwd: $(pwd)"
echo "---getting tools---"
sudo apt-get update
sudo apt-get install -y jq less
. .devcontainer/scripts/gcloud.sh
. .devcontainer/scripts/terraform.sh
echo "---tools done---"