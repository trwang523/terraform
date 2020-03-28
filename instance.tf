data "vsphere_datacenter" "dc" {
  name = var.datacenter_name
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool_name
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  count         = length(var.network_name)
  name          = var.network_name[count.index]
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

locals {
  interface_count = length(var.vm_netmask)
}

resource "vsphere_virtual_machine" "Windows" {
  count                = var.is_windows == true ? var.instances : 0
  name                 = var.vm_name[count.index]
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id

  num_cpus             = var.cpu_nums
  num_cores_per_socket = var.num_cores_per_socket
  memory               = var.memory
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  scsi_type            = data.vsphere_virtual_machine.template.scsi_type

  dynamic "network_interface" {
    for_each = var.network_name
    content {
      network_id   = data.vsphere_network.network[network_interface.key].id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template.disks
    iterator = template_disks
    content {
      label            = "disk${template_disks.key}"
      size             = data.vsphere_virtual_machine.template.disks[template_disks.key].size
      eagerly_scrub    = data.vsphere_virtual_machine.template.disks[template_disks.key].eagerly_scrub
      thin_provisioned = data.vsphere_virtual_machine.template.disks[template_disks.key].thin_provisioned
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      timeout = var.customize_timeout
      windows_options {
        computer_name         = var.vm_computername[count.index]
        workgroup             = var.vm_groupname
        admin_password        = var.vm_adminpassword
        time_zone             = var.vm_timezone
      }

      dynamic "network_interface" {
        for_each = var.network_name
        content {
          ipv4_address = var.vm_ipaddress[var.network_name[network_interface.key]][count.index]
          ipv4_netmask = "%{if local.interface_count == 1}${var.vm_netmask[0]}%{else}${var.vm_netmask[network_interface.key]}%{endif}"
        }
      }
      dns_server_list = var.vm_dnsserverlist
      ipv4_gateway    = var.vm_gateway

    }
  }
}

resource "vsphere_virtual_machine" "Linux" {
  count                = var.is_windows != true ? var.instances : 0
  name                 = var.vm_name[count.index]
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id

  num_cpus             = var.cpu_nums
  num_cores_per_socket = var.num_cores_per_socket
  memory               = var.memory
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  scsi_type            = data.vsphere_virtual_machine.template.scsi_type

  dynamic "network_interface" {
    for_each = var.network_name
    content {
      network_id   = data.vsphere_network.network[network_interface.key].id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template.disks
    iterator = template_disks
    content {
      label            = "disk${template_disks.key}"
      size             = data.vsphere_virtual_machine.template.disks[template_disks.key].size
      eagerly_scrub    = data.vsphere_virtual_machine.template.disks[template_disks.key].eagerly_scrub
      thin_provisioned = data.vsphere_virtual_machine.template.disks[template_disks.key].thin_provisioned
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      timeout = var.customize_timeout
      linux_options {
        host_name = var.vm_computername[count.index]
        domain = var.linux_domain
        time_zone = var.vm_timezone
      }

      dynamic "network_interface" {
        for_each = var.network_name
        content {
          ipv4_address = var.vm_ipaddress[var.network_name[network_interface.key]][count.index]
          ipv4_netmask = "%{if local.interface_count == 1}${var.vm_netmask[0]}%{else}${var.vm_netmask[network_interface.key]}%{endif}"
        }
      }
      dns_server_list = var.vm_dnsserverlist
      ipv4_gateway    = var.vm_gateway

    }
  }
}
