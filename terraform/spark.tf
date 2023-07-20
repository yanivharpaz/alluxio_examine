resource "azurerm_hdinsight_spark_cluster" "clstr-spark01" {
  name                = "spark-cluster01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_version     = "4.0"
  tier                = "Standard"

  component_version {
    spark = "2.4"
  }

  gateway {
    username = var.hdinsight_user_name
    password = var.hdinsight_user_password
  }

  storage_account {
    storage_container_id = azurerm_storage_container.stg-container-spark.id
    storage_account_key  = azurerm_storage_account.stg-hadoop.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = "A6"
      username = var.hdinsight_user_name
      password = var.hdinsight_user_password
    }

    worker_node {
      vm_size               = "Standard_D3_V2"
      username              = var.hdinsight_user_name
      password              = var.hdinsight_user_password
      target_instance_count = 1
    }

    zookeeper_node {
      vm_size  = "Standard_D3_V2"
      username = var.hdinsight_user_name
      password = var.hdinsight_user_password
    }
  }
}

resource "azurerm_storage_container" "stg-container-spark" {
  name                  = "stgcontainerspark230704"
  storage_account_name  = azurerm_storage_account.stg-hadoop.name
  container_access_type = "private"
}