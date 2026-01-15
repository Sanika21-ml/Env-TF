module "resourcegroup" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/resource-group "
    rg = var.rg
    location = var.location
  
}

module "Storage-account" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/storage-account"
    rg = var.rg
    location = var.location
    storage = var.storage

    depends_on = [ module.resourcegroup ]
  
}

module "vnet" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/vnet"
    rg = var.rg
    location = var.location
    vnetname = var.vnetname
    address_space = var.address_space
    subnetname = var.subnetname
    address_prefixes = var.address_prefixes

    depends_on = [ module.resourcegroup ]
  
}

module "virtualmachine" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/vm"
    rg = var.rg
    location = var.location
    vmname = var.vmname
    vm_size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    subnet_id = module.vnet.subnet_id

    depends_on = [ module.vnet ]
  
}

module "appservice" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/app-service"
    rg = var.rg
    location = var.location
    plan = var.plan 

    depends_on = [ module.resourcegroup ]
  
}

module "functionapp" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/function%20app"
    appname = var.appname
    rg = var.rg
    location = var.location
    planapp = var.planapp
    primary_key = module.Storage-account.primary_key

    depends_on = [ module.Storage-account ]
  
}

module "private-endpoint" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/private-endpoint"
    rg = var.rg
    location = var.location
    admin_username = var.admin_username
    admin_password = var.admin_password
    vnet_id = module.vnet.vnet_id
    subnet_id = module.vnet.subnet_id
    storage_id = module.Storage-account.storage_id

    depends_on = [ module.virtualmachine , module.vnet , module.Storage-account ]
  
}

module "key-vault" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/key-vault"
    rg = var.rg
    location = var.location

}

module "dns" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF/tree/main/dns"
    rg = var.rg
    dns_zone = module.private-endpoint.dns_zone
    nic = module.virtualmachine.nic 

    depends_on = [ module.resourcegroup , module.vnet , module.virtualmachine ]
  
}
