#!/bin/bash
# create_autoseclab_structure.sh
# This script creates only the directories and empty files for the AutoSecLab project

# Create directories
mkdir -p autoseclab/{containers,scripts,ansible/templates,artifacts}

# Create empty files
touch autoseclab/README.md
touch autoseclab/main.tf

touch autoseclab/containers/kali.Dockerfile
touch autoseclab/containers/dvwa.Dockerfile

touch autoseclab/scripts/deploy.sh
touch autoseclab/scripts/create_network.sh

touch autoseclab/ansible/inventory.ini
touch autoseclab/ansible/provision.yml
touch autoseclab/ansible/attack_scenario.yml
touch autoseclab/ansible/generate_report.yml
touch autoseclab/ansible/templates/report.html.j2

# Comment file to indicate purpose of artifacts directory
echo "# terraform/ansible will write outputs here" > autoseclab/artifacts/README.txt

echo "✅ AutoSecLab directory structure created successfully!"
