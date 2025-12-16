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

## 🏗️ Architecture
The pipeline follows a "Secure Supply Chain" model:

```mermaid
graph TD
    A["Developer (Ubuntu VM)"] -->|Push Code| B("GitHub Repository")
    B -->|Trigger| C{"GitHub Actions"}
    C -->|1. Build| D[Docker Image]
    D -->|2. Scan| E[Trivy Security Scanner]
    E -- Critical CVE Found --> F[❌ BLOCK Pipeline]
    E -- Safe --> G["Push to Azure Registry (ACR)"]
    G -->|Webhook Trigger| H[Azure Web App]
    H -->|Pull 'latest' Image| I[Live Production Site]
    style E fill:#f9f,stroke:#333,stroke-width:4px
    style F fill:#ff0000,stroke:#333,color:white
