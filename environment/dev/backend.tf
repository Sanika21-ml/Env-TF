terraform {
  backend "azurerm" {
    resource_group_name  = "Backend-git-1"
    storage_account_name = "storageaccountbackendgit1122"
    container_name = "backendgit102" 
    key = "terraform.tfstate"
  }
}
