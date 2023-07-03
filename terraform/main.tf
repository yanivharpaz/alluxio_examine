terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-all01"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-all01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "sub-a"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "sub-b"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "sub-c"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "example" {
  count               = 2
  name                = "publicIP${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "vmnic${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
  
}


resource "azurerm_public_ip" "example_windows" {
  name                = "publicIP_windows"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic_windows" {
  name                = "vmnic_windows"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example_windows.id
  }
}


resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                 = 1
  name                  = "vm_windows${count.index}"
  computer_name         = "vm-win${count.index}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1ls"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd123!"
  network_interface_ids = [azurerm_network_interface.nic_windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  # provisioner "local-exec" {
  #   command = <<EOH
  #     hostname
  #     # Set-ExecutionPolicy Bypass -Scope Process -Force;
  #     # iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
  #     # choco install git -y;
  #     # choco install vscode -y;
  #   EOH
  #   interpreter = ["pwsh", "-Command"]
  # }
}


resource "azurerm_linux_virtual_machine" "vm" {
  count                 = 2
  name                  = "vm-all-1${count.index}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1ls"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd123!"
  disable_password_authentication = false
  network_interface_ids  = [azurerm_network_interface.nic[count.index].id]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  custom_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io openjdk-8-jdk gcc git python3-pip
              EOF
              )
}
