resource "azurerm_hdinsight_hadoop_cluster" "example" {
  name                = "hdicluster23070401"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_version     = "4.0"
  tier                = "Standard"

  component_version {
    hadoop = "3.1"
  }

  gateway {
    # enabled  = true
    username = var.hdinsight_user_name
    password = var.hdinsight_user_password
  }

  storage_account {
    storage_container_id = azurerm_storage_container.example.id
    storage_account_key  = azurerm_storage_account.example.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = "A6"
      username = var.hdinsight_user_name
      password = var.hdinsight_user_password
    }

    worker_node {
      # vm_size               = "A6"
      vm_size               = "Standard_D3_V2"
      username              = var.hdinsight_user_name
      password              = var.hdinsight_user_password
      target_instance_count = 1
    }

    zookeeper_node {
      # vm_size  = "A6"
      vm_size  = "Standard_D3_V2"
      username = var.hdinsight_user_name
      password = var.hdinsight_user_password
    }
  }
}

resource "azurerm_storage_account" "example" {
  name                     = "stghadoop230704"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "examplecontainer"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}
