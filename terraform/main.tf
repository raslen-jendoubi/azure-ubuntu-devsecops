terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG-Terraform-State"
    storage_account_name = "tfstateraslen2025"   
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "RG-DevSecOps-Pro"
  location = "East US"
}

# 2. Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "ubuntuacrraslen"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 3. App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "Linux-AppPlan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# 4. Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "ubuntu-webapp-raslen" 
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false
    application_stack {
      docker_image_name   = "flask-app:latest"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
  }
}
