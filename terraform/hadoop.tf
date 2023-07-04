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
    username = "adminuser"
    password = "P@$$w0rd123!"
  }

  storage_account {
    storage_container_id = azurerm_storage_container.example.id
    storage_account_key  = azurerm_storage_account.example.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = "A6"
      username = "adminuser"
      password = "P@$$w0rd123!"
    }

    worker_node {
      vm_size               = "A6"
      username              = "adminuser"
      password              = "P@$$w0rd123!"
      target_instance_count = 2
    }

    zookeeper_node {
      vm_size  = "A6"
      username = "adminuser"
      password = "P@$$w0rd123!"
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
