# 🛡️ AutoSecLab — Automated Cyber Range using Terraform + Podman + Ansible 

> ⚠️ **Work in progress** — AutoSecLab is not yet 100% complete.
> Key components (ELK integration, Snort/Zeek, reporting polish) are in progress and will be added soon.
> See the **Roadmap** section below for details.

**AutoSecLab** is a lightweight, fully containerized cybersecurity lab designed for automation, testing, and education. It deploys a realistic attack-and-defense environment using **Terraform**, **Podman**, and **Ansible** — all running locally on your Ubuntu or RHEL-based VM (no external hosting required).

> **Author:** Thabet Hamdi (GitHub: **ThabetHamdi**) — Final Year Engineering Student — Information Systems & Network Security

---

## 🚀 Project Summary

AutoSecLab automates the deployment of a small cyber range composed of multiple containers that simulate attacker(s), victim(s), and monitoring systems. The environment is reproducible, portable, and designed for demos, teaching, and portfolio presentations.

Key highlights:

* Infrastructure as Code with **Terraform** to orchestrate Podman deployments.
* Containerized tools with **Podman** (rootless where possible).
* Automation and attack orchestration using **Ansible** (local mode — no SSH required).
* Modular: easily add SIEM (ELK/Splunk), IDS (Snort/Zeek), or additional targets (Metasploitable).

---

## 🧩 Architecture

```
+--------------------------------------------------------------+
|                       AutoSecLab Network (cybernet)          |
|                                                              |
|  +-----------+       +------------+       +-------------+    |
|  |  Kali     | ----> |   DVWA     | ----> |   ELK/Snort |    |
|  | Attacker  |       | Vulnerable |       | Monitoring  |    |
|  +-----------+       +------------+       +-------------+    |
|                                                              |
|  All containers managed via Podman & Terraform.               |
|  Attack & reporting automated using Ansible.                  |
+--------------------------------------------------------------+
```

---

## 🧱 Components

* **Kali (Attacker)** — `kali-lab` container with pentesting tools (nmap, sqlmap, hydra, etc.)
* **DVWA (Victim)** — `vulnerables/web-dvwa` container (web app vulnerable for training)
* **ELK / Splunk (SIEM)** — optional containers for log aggregation and dashboards
* **Snort / Zeek (IDS/NSM)** — optional containers for network detection
* **Terraform** — top-level automation to call local scripts and manage lifecycle
* **Ansible** — local-run playbooks to orchestrate attacks and collect artifacts

---

## 🧰 What’s in this repo

```
autoseclab/
├── README.md                # This file
├── main.tf                  # Terraform definition
├── containers/
│   ├── kali.Dockerfile
│   └── dvwa.Dockerfile
├── scripts/
│   ├── deploy.sh            # Builds images & runs containers
│   └── create_network.sh
├── ansible/
│   ├── inventory.ini
│   ├── provision.yml
│   ├── attack_scenario.yml
│   ├── generate_report.yml
│   └── templates/report.html.j2
└── artifacts/               # Generated reports & scan outputs (ignored)
```

---

## ⚡ Quick Start (Ubuntu VM)

### Prerequisites

Install required packages on your Ubuntu VM:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y podman git wget unzip python3-pip ansible
```

Install Terraform (example):

```bash
TVER=1.9.8
wget https://releases.hashicorp.com/terraform/${TVER}/terraform_${TVER}_linux_amd64.zip
unzip terraform_${TVER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -v
```

### Deploy the lab

1. Clone or copy this repo to the VM and change to the project dir.

2. Make scripts executable:

```bash
chmod +x scripts/*.sh
```

3. Initialize & apply Terraform (this will call `scripts/deploy.sh`):

```bash
terraform init
terraform apply -auto-approve
```

This will create the Podman network `cybernet`, build the Kali image, pull the DVWA image, and run the containers.

### Provision and run Ansible playbooks

From the `ansible/` folder run:

```bash
ansible-playbook -i inventory.ini provision.yml
ansible-playbook -i inventory.ini attack_scenario.yml
ansible-playbook -i inventory.ini generate_report.yml
```

* Artifacts (nmap XML, sqlmap output, HTML report) will be saved in `artifacts/`.
* If you need Nmap raw socket scans, ensure Kali is started with capabilities (`--cap-add=NET_RAW --cap-add=NET_ADMIN`) — the deploy script can be adjusted accordingly.

---



---


---



## Roadmap / TODO

**Status:** In development (WIP)

Planned items:
- [ ] ELK Stack integration (Filebeat & Kibana dashboards)
- [ ] Snort/Zeek NSM integration and rule tuning
- [ ] Add Splunk container (optional)
- [ ] Improve Kali image (add metasploit or use prebuilt)
- [ ] A small Flask UI for start/stop & report viewing
- [ ] CI workflow to auto-run baseline scans

## 🔧 Extending the Lab

Ideas to make this project stand out for recruiters:

* Add **ELK Stack** container with Filebeat forwarding DVWA/IDS logs to Kibana (visualize attacks).
* Add **Splunk** as an alternative SIEM to demonstrate enterprise tooling.
* Integrate **Zeek** for network flow and protocol analysis and forward its logs to ELK/Splunk.
* Add a small **Flask dashboard** to start/stop the lab and show the generated report.
* Add a **CI/CD pipeline** that rebuilds the lab and runs baseline scans on push (GitHub Actions).

---

## 🧾 License

This project is released under the **MIT License**. See `LICENSE` file.

---

## 📚 References & Resources

* Kali Linux Docker images: [https://www.kali.org/docs/containers/](https://www.kali.org/docs/containers/)
* DVWA project: [https://dvwa.co.uk/](https://dvwa.co.uk/)
* Podman documentation: [https://podman.io/](https://podman.io/)
* Terraform: [https://terraform.io/](https://terraform.io/)
* Ansible: [https://ansible.com/](https://ansible.com/)

---

## 📞 Contact

Thabet Hamdi — Final Year Student (Information Systems & Network Security)

* GitHub: [https://github.com/ThabetHamdi](https://github.com/ThabetHamdi)

