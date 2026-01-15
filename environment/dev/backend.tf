terraform {
  backend "azurerm" {
    resource_group_name  = "Backend-git"
    storage_account_name = "storageaccountbackendgit"
    container_name = "backendgit" 
    key = "terraform.tfstate"
  }
}
