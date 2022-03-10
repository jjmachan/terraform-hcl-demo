terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

################################################################################
# Input variable definitions
################################################################################

variable "deployment-name" {
  type = string
}

variable "resource-group" {
  type = string
}

variable "azure-container-registry" {
  type = string
}

variable "bento_image" {
  type = string
}

variable "bento_tag" {
  type = string
}


################################################################################
# Resource definitions
################################################################################

data "azurerm_resource_group" "rg" {
  name = var.resource-group
}

resource "random_id" "storage_account" {
  byte_length = 8
}

resource "azurerm_storage_account" "storage" {
  name                     = "storage${lower(random_id.storage_account.hex)}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_application_insights" "application_insights" {
  name                = "${var.deployment-name}-application-insights"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "other"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.deployment-name}-premiumPlan"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Premium"
    size = "P1V2"
  }
}

resource "azurerm_app_service_plan" "plan1" {
  name                = "${var.deployment-name}-Premium-ConsumptionPlan"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  kind                = "Elastic"
  reserved            = true

  sku {
    tier = "ElasticPremium"
    size = "EP1"
  }
}

data "azurerm_container_registry" "registry" {
  name                = var.azure-container-registry
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_function_app" "funcApp" {
  name                       = "${var.deployment-name}-${lower(random_id.storage_account.hex)}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~3"

  app_settings = {
    FUNCTION_APP_EDIT_MODE              = "readOnly"
    https_only                          = true
    FUNCTIONS_EXTENSION_VERSION         = "~3"
    DOCKER_REGISTRY_SERVER_URL          = "${data.azurerm_container_registry.registry.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME     = "${data.azurerm_container_registry.registry.admin_username}"
    DOCKER_REGISTRY_SERVER_PASSWORD     = "${data.azurerm_container_registry.registry.admin_password}"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    APPINSIGHTS_INSTRUMENTATIONKEY      = azurerm_application_insights.application_insights.instrumentation_key
  }

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|${data.azurerm_container_registry.registry.login_server}/${var.bento_image}:${var.bento_tag}"
  }

  depends_on = [azurerm_storage_account.storage]
}
################################################################################
# Output value definitions
################################################################################
