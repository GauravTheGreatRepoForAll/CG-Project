# Public IP
resource "azurerm_public_ip" "PIP" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# NIC
resource "azurerm_network_interface" "NIC" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PIP.id
  }

  tags = var.tags
}

# Associate NSG to NIC
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.NIC.id
  network_security_group_id = var.nsg_id
}

# Linux VM
resource "azurerm_linux_virtual_machine" "VM" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false 
  network_interface_ids = [azurerm_network_interface.NIC.id]


  # Ubuntu LTS latest
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  computer_name = var.name

  tags = var.tags

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type     = "ssh"
      host     = azurerm_public_ip.PIP.ip_address
      user     = var.admin_username
      password = var.admin_password
    }
  }
}

output "public_ip" {
  value = azurerm_public_ip.PIP.ip_address
}

output "nic_id" {
  value = azurerm_network_interface.NIC.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.VM.id
}
