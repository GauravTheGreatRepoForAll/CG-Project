variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "allowed_tcp_ports" {
  description = "TCP ports to allow inbound from Internet"
  type        = list(number)
  default     = [22, 80]
}
variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}
