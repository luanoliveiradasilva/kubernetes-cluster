# Configurar a Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
    skip_provider_registration = false
  features {}
}

resource "azurerm_resource_group" "myResourceGroup" {
  name     = "myTFResourceGroup"
  location = "westus2"
}

# Cluster aks
resource "azurerm_kubernetes_cluster" "example" {
  name                = "teste-aks"
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  dns_prefix          = "teste-k8s"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

 service_principal {
    client_id     = "1711c619-dc4c-4264-a01d-2aad93762d91"
    client_secret = "WFnqGCY_bHcYLxHliH3~TQVuSR21HH4x~q"
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}
  
# ACR
resource "azurerm_container_registry" "myAcrs" {
  name                     = "myAcrs"
  location                 = azurerm_resource_group.myResourceGroup.location
  resource_group_name      = azurerm_resource_group.myResourceGroup.name
  sku                      = "Basic"
  admin_enabled            = false
}

output "azurerm_container_registry_id" {
  value = azurerm_container_registry.myAcrs.id
}
