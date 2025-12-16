# 🛡️ Azure DevSecOps: Terraform & Secure Docker Pipeline

![Build Status](https://img.shields.io/github/actions/workflow/status/raslen-jendoubi/azure-ubuntu-devsecops/deploy.yml)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![Security](https://img.shields.io/badge/Security-Trivy-green)
![Cloud](https://img.shields.io/badge/Azure-App%20Service-blue)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED)

---

## 📖 Overview

This project demonstrates an **enterprise-grade DevSecOps pipeline** combining:

- **Infrastructure as Code (IaC)** using Terraform  
- **Secure CI/CD** using GitHub Actions  
- **Container Security** enforced by Trivy vulnerability scanning  

Every code push triggers a fully automated and secure workflow.

### 🔄 Automated Pipeline Flow

1. **Provision Infrastructure**  
   Terraform validates and applies Azure resources (Web App, ACR, Service Plan).

2. **Security Gate**  
   Trivy scans the Docker image and **blocks deployment** if HIGH or CRITICAL CVEs are found.

3. **Secure Deployment**  
   Only verified images are pushed to Azure Container Registry and deployed to Azure Web App.

---

## 🔑 Key Technologies

- **IaC:** Terraform (remote state in Azure Blob Storage)
- **Cloud:** Azure Web App for Containers, Azure Container Registry (ACR)
- **CI/CD:** GitHub Actions
- **Security:** Aqua Security Trivy
- **Containerization:** Docker (Nginx Alpine)

---

## ✅ Prerequisites

```text
OS: Ubuntu 24.04 LTS
Terraform: v1.9.0+
Docker: 28.0.0
Azure CLI: 2.61.0
```

---

## 📂 Project Structure

```text
.
├── .github/workflows
│   └── deploy.yml          # 🤖 DevSecOps CI/CD Pipeline
├── terraform
│   ├── main.tf             # 🏗️ Azure Infrastructure (IaC)
│   ├── variables.tf        # 🔧 Terraform variables
│   └── outputs.tf          # 📤 Outputs (URLs, IDs)
├── Dockerfile              # 🐳 Secure Nginx Container
├── index.html              # 🌐 Web Application
├── docs
│   └── images              # 📸 Evidence screenshots
│       ├── live-app.png
│       ├── trivy-failed.png
│       └── trivy-success.png
└── README.md
```

---

## 🏗️ Architecture Pipeline

```mermaid
graph TD
    A["Developer"] -->|Push Code| B["GitHub Repository"]
    B -->|Trigger| C{"GitHub Actions"}

    subgraph Phase1["Phase 1: Infrastructure Provisioning"]
        C -->|Terraform Init & Plan| D[Terraform State Check]
        D -->|Terraform Apply| E[Azure Resources Created / Updated]
    end

    subgraph Phase2["Phase 2: Secure CI/CD"]
        E -->|Build| F[Docker Image]
        F -->|Scan| G[Trivy Security Scanner]
        G -- Critical CVE --> H[❌ Pipeline Blocked]
        G -- Clean --> I[Push to Azure ACR]
        I -->|Deploy| J[Azure Web App]
    end

    style G fill:#f9f,stroke:#333,stroke-width:3px
    style H fill:#ff0000,stroke:#333,color:#fff
    style D fill:#7b61ff,stroke:#333,color:#fff
```

---

## ⚙️ Configuration Snippets

### 1️⃣ Terraform Infrastructure (`main.tf`)

```hcl
resource "azurerm_linux_web_app" "webapp" {
  name                = "ubuntu-webapp-raslen"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false
    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/my-app"
      docker_image_tag = "latest"
    }
  }
}
```

---

### 2️⃣ Secure CI/CD Pipeline (`deploy.yml`)

```yaml
jobs:
  provision-infrastructure:
    runs-on: ubuntu-latest
    steps:
      - name: Terraform Apply
        run: terraform apply -auto-approve

  build-secure-deploy:
    needs: provision-infrastructure
    runs-on: ubuntu-latest
    steps:
      - name: Build Docker Image
        run: docker build -t my-app .

      - name: 🛡️ Trivy Security Scan
        uses: aquasecurity/trivy-action@master
        with:
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

      - name: Push to ACR
        run: docker push my-app
```

---

## 🔐 DevSecOps in Action

### 🚨 Scenario: Vulnerability Detection

```text
Detected Package : libssl1.1
Severity         : HIGH
Action           : Pipeline failed
Result           : Deployment blocked – production remains secure
```

📸 **Blocked Build Evidence**  
![Trivy Blocked](docs/images/trivy-failed.png)

📸 **Successful Deployment**  
![Live App](docs/images/live-app.png)

---

<h3 align="center">
Created by <a href="https://github.com/raslen-jendoubi">Raslen Jendoubi</a> | DevSecOps Engineer
</h3>
