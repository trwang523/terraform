output "disks" {
  description = "disks of the template"
  value       = data.vsphere_virtual_machine.template.disks
}
