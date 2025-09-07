output "vnet_id" {
  value = azurerm_virtual_network.VNET.id
}
output "subnet_id" {
  value = azurerm_subnet.snet.id
}
