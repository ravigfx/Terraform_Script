terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}
provider "azurerm" {
  features {}
}
terraform {
  backend "azurerm" {
    resource_group_name = "azrg"
    storage_account_name = "azrgstrg"
    container_name = "test"
    key = "terraform.*"
    access_key = "vqEXQ7F8NIpOAPez+S7y3Znkkc61A3R92ZoswLzV0be8Qdo+oNgMyDVeK2Jn9AJavJeHWnJviSlV+AStNzrj1A=="

  }
}
resource "azurerm_resource_group" "azlabelrg401" {
    name = "azrgus3011"
    location = "East US"
    tags = {
      "name" = "azure resourcegroup-eastus"
    }

}
resource "azurerm_virtual_network" "azlabelvnet401" {
    name = "azvnetus3011"
    resource_group_name = azurerm_resource_group.azlabelrg401.name
    location = azurerm_resource_group.azlabelrg401.location
    address_space = [ "10.60.0.0/16" ]
}
resource "azurerm_subnet" "azlabelwebsubnet401" {
    name = "websubnet"
    resource_group_name = azurerm_resource_group.azlabelrg401.name
    virtual_network_name = azurerm_virtual_network.azlabelvnet401.name
    address_prefixes = [ "10.60.1.0/24" ]

}
resource "azurerm_network_security_group" "azweblabelnsg501" {
  name = "webnsg501"
  resource_group_name = azurerm_resource_group.azlabelrg401.name
  location = azurerm_resource_group.azlabelrg401.location
}

resource "azurerm_network_security_rule" "azweblabelnsr501" {
    name = "webnsr501"
resource_group_name =azurerm_resource_group.azlabelrg401.name
    priority                   = "100"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    network_security_group_name = azurerm_network_security_group.azweblabelnsg501.name
}
resource "azurerm_public_ip" "azlabelapppublicip501" {
    count = var.vm_count
    name = "vvvv"
    resource_group_name = azurerm_resource_group.azlabelrg401.name
    location = azurerm_resource_group.azlabelrg401.location
    allocation_method = "Static"
}
resource "azurerm_network_interface" "azlabelappnic501" {
    count = var.vm_count
    name = "${var.vm_name_pfx}-${count.index}-nic1"
    resource_group_name = azurerm_resource_group.azlabelrg401.name
    location = azurerm_resource_group.azlabelrg401.location
    # network_security_group_name = azurerm_network_security_group.azlabelvnet401.name
    ip_configuration {
      name = "appnicconfig"
      subnet_id = azurerm_subnet.azlabelwebsubnet401.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.azlabelapppublicip501[count.index].id
    }
}
resource "azurerm_linux_virtual_machine" "azlabelappserver501" {
    count = var.vm_count
    name = "${var.vm_name_pfx}-${count.index}-app"
    resource_group_name = azurerm_resource_group.azlabelrg401.name
    location = azurerm_resource_group.azlabelrg401.location
    size = "Standard_F2"
    admin_username = "adminuser"
    admin_password = "password3898!"
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.azlabelappnic501[count.index].id, ]

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"

    }

    source_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
    }

}
resource "null_resource" "azurerm_null_dev1" {
  count = var.vm_count

  triggers = {
    id = azurerm_linux_virtual_machine.azlabelappserver501[count.index].id
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y mysql-server",
      "sudo mysql -e 'CREATE DATABASE example;'",
      "sudo mysql -e 'CREATE USER 'example'@'%' IDENTIFIED BY 'password';'",
      "sudo mysql -e 'GRANT ALL PRIVILEGES ON example.* TO 'example'@'%';'",
      "sudo service mysql restart"
    ]
    connection {
      type = "ssh"
      user = "adminuser"
      password = "password3898!"
      host = azurerm_linux_virtual_machine.azlabelappserver501[count.index].public_ip_address
      timeout = "2m"
    }

  }

}