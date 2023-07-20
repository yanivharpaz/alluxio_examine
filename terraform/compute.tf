resource "azurerm_windows_virtual_machine" "vm_windows" {
  count = var.vm_windows_count
  name  = "vm_win-xio-${count.index}"
  # explicit computer name (overrides default)
  computer_name         = "vm-win-xio-${count.index}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D4s_v3"
  admin_username        = var.hdinsight_user_name
  admin_password        = var.hdinsight_user_password
  network_interface_ids = [azurerm_network_interface.nic_windows[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-entn"
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
  count                           = var.vm_linux_count
  name                            = "vm-lin-xio-${count.index}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D4s_v3"
  admin_username                  = var.linux_user_name
  admin_password                  = var.linux_user_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_linux[count.index].id]

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
              sudo apt install -y apt-transport-https conntrack git mc ncdu zsh htop gcc net-tools jq
              sudo apt install -y docker.io openjdk-8-jdk python3-pip
              sudo apt install -y ca-certificates curl gnupg-agent software-properties-common
              sudo usermod -aG docker adminuser
              sudo service docker restart

              EOF
  )
}
