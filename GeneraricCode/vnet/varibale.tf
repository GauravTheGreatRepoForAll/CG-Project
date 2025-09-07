variable "name" { type = string }
variable "address_space" {
  description = "List of address spaces for the VNet"
  type        = list(string)
}
variable "subnet_name" { type = string }
variable "address_prefixes" {
  description = "List of address prefixes for the Subnet"
  type        = list(string)
}
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}
