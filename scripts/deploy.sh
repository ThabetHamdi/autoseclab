#!/usr/bin/env bash
set -euo pipefail
WORKDIR="$(cd "$(dirname "$0")" && pwd)/.."
cd "$WORKDIR"

echo "🛡️ AutoSecLab Deployment"
echo "========================"

# ensure artifacts dir
mkdir -p artifacts

# Create network
echo "[+] Creating network..."
bash scripts/create_network.sh || true

# Build images
echo "[+] Building Kali image..."
podman build -t kali-lab -f containers/kali.Dockerfile .

echo "[+] Pulling DVWA image..."
podman pull vulnerables/web-dvwa:latest || true
# If custom build desired uncomment next line
# podman build -t dvwa-lab -f containers/dvwa.Dockerfile .

# Run containers (idempotent: remove if exists)
echo "[+] Setting up containers..."
if podman ps -a --format '{{.Names}}' | grep -q '^dvwa$'; then
    echo "[+] Removing existing dvwa container..."
    podman rm -f dvwa || true
fi
if podman ps -a --format '{{.Names}}' | grep -q '^kali$'; then
    echo "[+] Removing existing kali container..."
    podman rm -f kali || true
fi

echo "[+] Starting DVWA container..."
podman run -d --name dvwa --network cybernet -p 8080:80 vulnerables/web-dvwa:latest

echo "[+] Starting Kali container with network capabilities..."
podman run -itd --name kali --network cybernet --cap-add=NET_RAW --cap-add=NET_ADMIN kali-lab

echo ""
echo "✅ Deployment finished!"
echo ""
echo "DVWA is available at: http://localhost:8080"
echo "Default credentials: admin/password"
echo ""
echo "To run attacks, execute the Ansible playbooks:"
echo "  cd ansible"
echo "  ansible-playbook -i inventory.ini provision.yml"
echo "  ansible-playbook -i inventory.ini attack_scenario.yml"
echo "  ansible-playbook -i inventory.ini generate_report.yml"
echo ""
