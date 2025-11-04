# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Define Azure Resources
# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "CloudTopia-RG"
  location = "East US" # You can change this location if needed
}

# 2. Virtual Network and Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "CloudTopia-VNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "CloudTopia-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 3. Security Rule to allow web traffic on port 80 (via NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "CloudTopia-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_http" {
  name                        = "HTTP-80"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "80" # <-- This opens port 80
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# (NIC, Public IP, and VM setup omitted for brevity but required for a running system)
# NOTE: A full solution requires azurerm_public_ip, azurerm_network_interface, and azurerm_linux_virtual_machine. 
# Use the AI prompt from the previous step to generate the rest of the VM code.
