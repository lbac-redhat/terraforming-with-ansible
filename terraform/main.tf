terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.4"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

locals {
  machines = {

    "machine1" = {
      "vCPUs"  = 2,
      "memory" = 1024
    },

    "machine2" = {
      "vCPUs"  = 1,
      "memory" = 512
    }

  }
}

resource "libvirt_volume" "tf_volumes" {
  for_each = local.machines

  name             = each.key
  base_volume_name = "rhel9.2-base.qcow2"
}

resource "libvirt_domain" "tf_vms" {
  for_each = local.machines

  name = each.key
  cpu {
    mode = "host-passthrough"
  }
  description = "Created by Terraform"
  vcpu        = each.value.vCPUs
  memory      = each.value.memory
  disk {
    volume_id = libvirt_volume.tf_volumes[each.key].id
  }
  network_interface {
    network_name = "default"
    hostname     = each.key
    wait_for_lease = true
  }
}
