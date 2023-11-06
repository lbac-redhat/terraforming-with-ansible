output "machines" {
  value = { for machine in libvirt_domain.tf_vms : machine.name => machine }
}
