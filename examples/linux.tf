#uncomented variabile have default value set, you can change it or leave it as default.
#check the available timezone value from https://docs.microsoft.com/en-us/previous-versions/windows/embedded/ms912391(v=winembedded.11)?redirectedfrom=MSDN
module "centos76" {
  source             = "./modules/terraform"
  instances          = 1
  is_windows         = false
  datacenter_name    = "datacenter_name"
  datastore_name     = "datastore_name"
  resource_pool_name = "resource_pool_name"
  #  vm_folder          = null
  #  customize_timeout  = 30
  network_name    = ["VLAN 1", "VLAN 2"]
  template_name   = "vm_teplatename"
  vm_name         = ["vmname"]
  vm_computername = ["comptername"]
  #  cpu_nums = 4
  # num_cores_per_socket = 2
  # memory = 16384

  #for Linux
  # linux_domain = "localhost"

  #for windows
  # vm_groupname = null
  # vm_adminpassword = Firewall1

  vm_ipaddress = {
    "VLAN 1" : ["1.1.1.2"]
    "VLAN 2" : ["2.2.2.2"]
  }
  vm_netmask       = [24, 16]
  vm_gateway       = "1.1.1.1"
  vm_dnsserverlist = ["8.8.8.8"]
  # vm_timezone = 4
}
