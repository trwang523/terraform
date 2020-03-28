variable "instances" {
  type    = number
  default = 1
}
variable "datacenter_name" {}
variable "datastore_name" {}
variable "resource_pool_name" {}
variable "network_name" {
  type    = list
  default = ["Primary_Subnet"]
}
variable "template_name" {}
variable "vm_name" {
  type = list
}
variable "cpu_nums" {
  type    = number
  default = 4
}

variable "num_cores_per_socket" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 16384
}
variable "customize_timeout" {
  type    = number
  default = 30
}
variable "linux_domain"{
  type = string
  default = "localhost"
}
variable vm_computername {
  type    = list
}
variable vm_groupname {
  default = null
}
variable vm_adminpassword {
  type    = string
  default = "Firewall1"
}
variable "vm_ipaddress" {
  type = map
}
variable "vm_netmask" {
  type    = list
  default = [24]
}
variable "vm_dnsserverlist" {
  type    = list
  default = ["192.168.254.2"]
}
variable "vm_gateway" {}
variable "vm_timezone" {
  type    = number
  default = 4
}
variable "is_windows" {
  type    = bool
  default = true
}
