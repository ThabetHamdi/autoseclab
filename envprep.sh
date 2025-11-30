#!/bin/bash
# envprep.sh
# Environment preparation script for AutoSecLab
# This script installs required dependencies and prepares the environment

set -euo pipefail

echo "🛡️ AutoSecLab Environment Preparation"
echo "======================================"

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "❌ Cannot detect OS. Please install dependencies manually."
    exit 1
fi

echo "[+] Detected OS: $OS"

# Install dependencies based on OS
case $OS in
    ubuntu|debian)
        echo "[+] Installing dependencies for Debian/Ubuntu..."
        sudo apt-get update
        sudo apt-get install -y podman git wget unzip python3-pip ansible
        ;;
    fedora|rhel|centos)
        echo "[+] Installing dependencies for RHEL/Fedora/CentOS..."
        sudo dnf install -y podman git wget unzip python3-pip ansible
        ;;
    *)
        echo "⚠️  Unknown OS: $OS. Please install podman, git, ansible manually."
        ;;
esac

# Install Terraform if not present
if ! command -v terraform &> /dev/null; then
    echo "[+] Installing Terraform..."
    TVER=${TERRAFORM_VERSION:-1.9.8}
    wget -q "https://releases.hashicorp.com/terraform/${TVER}/terraform_${TVER}_linux_amd64.zip" -O /tmp/terraform.zip
    unzip -o /tmp/terraform.zip -d /tmp/
    sudo mv /tmp/terraform /usr/local/bin/
    rm /tmp/terraform.zip
    echo "[+] Terraform $(terraform -v | head -1) installed"
else
    echo "[+] Terraform already installed: $(terraform -v | head -1)"
fi

# Make scripts executable
echo "[+] Setting script permissions..."
chmod +x scripts/*.sh 2>/dev/null || true

# Create artifacts directory
mkdir -p artifacts

echo ""
echo "✅ Environment preparation complete!"
echo ""
echo "Next steps:"
echo "  1. terraform init"
echo "  2. terraform apply -auto-approve"
echo "  3. cd ansible && ansible-playbook -i inventory.ini provision.yml"
echo ""
