resource "azurerm_network_security_group" "NSG" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# One rule per allowed TCP port
resource "azurerm_network_security_rule" "allow_tcp" {
  for_each = { for port in var.allowed_tcp_ports : tostring(port) => port }  # convert to map with string keys

  name                        = "allow-tcp-${each.value}"
  priority                    = 2000 + each.value
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = tostring(each.value)
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.NSG.name
}
output "id" {
  value = azurerm_network_security_group.NSG.id
}
