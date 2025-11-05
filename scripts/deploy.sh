#!/usr/bin/env bash
set -euo pipefail
WORKDIR="$(cd "$(dirname "$0")" && pwd)/.."
cd "$WORKDIR"


# ensure artifacts dir
mkdir -p artifacts


# Create network
bash scripts/create_network.sh || true


# Build images
echo "[+] Building Kali image"
podman build -t kali-lab -f containers/kali.Dockerfile .


echo "[+] Building DVWA image"
podman pull vulnerables/web-dvwa:latest || true
# If custom build desired uncomment next line
# podman build -t dvwa-lab -f containers/dvwa.Dockerfile .


# Run containers (idempotent: remove if exists)
if podman ps -a --format '{{.Names}}' | grep -q '^dvwa$'; then
podman rm -f dvwa || true
fi
if podman ps -a --format '{{.Names}}' | grep -q '^kali$'; then
podman rm -f kali || true
fi


podman run -d --name dvwa --network cybernet -p 8080:80 vulnerables/web-dvwa:latest
podman run -itd --name kali --network cybernet kali-lab


echo "[+] Deployment finished. DVWA -> http://localhost:8080"
