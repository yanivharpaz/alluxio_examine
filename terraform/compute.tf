resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                 = 2
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
