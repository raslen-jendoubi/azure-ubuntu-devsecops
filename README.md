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
```
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
```
 FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN useradd -m appuser
USER appuser
EXPOSE 5000
CMD ["python", "app.py"]
```
name: Ubuntu DevSecOps Pipeline

on:
  push:
    branches: [ "main" ]

env:
  IMAGE_NAME: flask-app
  ACR_NAME: ubuntuacrraslen 

jobs:
  build-secure-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Login to Azure ACR
        uses: docker/login-action@v2
        with:
          registry: ${{ secrets.ACR_LOGIN_SERVER }}
          username: ${{ secrets.ACR_USERNAME }}
          password: ${{ secrets.ACR_PASSWORD }}

      - name: Build Docker Image
        run: docker build -t ${{ secrets.ACR_LOGIN_SERVER }}/${{ env.IMAGE_NAME }}:${{ github.sha }} -t ${{ secrets.ACR_LOGIN_SERVER }}/${{ env.IMAGE_NAME }}:latest ./app

      - name: 🛡️ Trivy Security Scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: '${{ secrets.ACR_LOGIN_SERVER }}/${{ env.IMAGE_NAME }}:${{ github.sha }}'
          format: 'table'
          exit-code: '1' # Fails if critical bugs found
          ignore-unfixed: true
          severity: 'CRITICAL,HIGH'

      - name: Push to ACR
        run: docker push --all-tags ${{ secrets.ACR_LOGIN_SERVER }}/${{ env.IMAGE_NAME }}
        
