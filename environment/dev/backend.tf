terraform {
  backend "azurerm" {
    resource_group_name  = "Backend-git-1"
    storage_account_name = "storageaccountgit1122"
    container_name = "backendgit102" 
    key = "terraform.tfstate"
  }
}
