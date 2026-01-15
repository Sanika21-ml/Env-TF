module "resource-group" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//resource-group"
    rg = var.rg
    location = var.location
  
}

module "storage-account" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//storage-account"
    rg = var.rg
    location = var.location
    storage = var.storage

    depends_on = [ module.resource-group ]
  
}

module "vnet" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//vnet"
    rg = var.rg
    location = var.location
    vnetname = var.vnetname
    address_space = var.address_space
    subnetname = var.subnetname
    address_prefixes = var.address_prefixes

    depends_on = [ module.resource-group ]
  
}

module "vm" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//vm"
    rg = var.rg
    location = var.location
    vmname = var.vmname
    vm_size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    subnet_id = module.vnet.subnet_id

    depends_on = [ module.vnet ]
  
}

module "app-service" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//app-service"
    rg = var.rg
    location = var.location
    plan = var.plan 

    depends_on = [ module.resource-group ]
  
}

module "function-app" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//function-app"
    appname = var.appname
    rg = var.rg
    location = var.location
    planapp = var.planapp
    primary_key = module.storage-account.primary_key

    depends_on = [ module.storage-account ]
  
}

module "private-endpoint" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//private-endpoint"
    rg = var.rg
    location = var.location
    admin_username = var.admin_username
    admin_password = var.admin_password
    vnet_id = module.vnet.vnet_id
    subnet_id = module.vnet.subnet_id
    storage_id = module.storage-account.storage_id

    depends_on = [ module.vm , module.vnet , module.storage-account ]
  
}

module "key-vault" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//key-vault"
    rg = var.rg
    location = var.location

}

module "dns" {
    source = "git::https://github.com/Sanika21-ml/Modules-TF.git//dns"
    rg = var.rg
    dns_zone = module.private-endpoint.dns_zone
    nic = module.vm.nic 

    depends_on = [ module.resource-group , module.vnet , module.vm ]
  
}
