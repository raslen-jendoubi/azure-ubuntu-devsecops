# 🛡️ Azure DevSecOps Pipeline: Secure Flask Deployment

![Build Status](https://img.shields.io/github/actions/workflow/status/raslen-jendoubi/azure-ubuntu-devsecops/deploy.yml)
![Security](https://img.shields.io/badge/Security-Trivy-green)
![Cloud](https://img.shields.io/badge/Azure-App%20Service-blue)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED)

## 📖 Overview
This project demonstrates a complete **DevSecOps** workflow. It deploys a Python Flask application to Azure, but with a strict security gate. 

Unlike traditional pipelines that deploy blindly, this workflow uses **Trivy** to scan for vulnerabilities (CVEs) before the image is ever allowed to reach the cloud registry. If a critical vulnerability is found, the pipeline blocks the deployment immediately.

**Key Technologies:**
* **Cloud:** Azure Web App for Containers & Azure Container Registry (ACR).
* **CI:** GitHub Actions (Automated Build & Scan).
* **CD:** Azure Continuous Deployment (Webhook-based).
* **Security:** Aquasecurity Trivy (Container Scanning).
* **Container:** Docker (Multi-stage build).

---
### Prerequisites
The project was built and tested on the following environment:
* **OS:** Ubuntu 24.04.3 LTS
* **Docker:** Version 28.0.0
* **Azure CLI:** Version 2.61.0
* **Python:** Version 3.12.3

## 📂 Project Structure
```text
.
├── app
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
└── docs
    └── images
