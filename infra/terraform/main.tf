terraform {
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token        = var.yc_token
  cloud_id     = var.yc_cloud_id
  folder_id    = var.yc_folder_id
  zone         = var.yc_zone
}

resource "yandex_vpc_network" "network" {
  name = "k3s-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "k3s-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.131.0.0/24"]
}

resource "yandex_compute_instance" "vm" {
  count = 3
  name = "vm-${count.index}"

  resources {
    cores = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(pathexpand(var.ssh_public_key_path))}"
  }
}

output "external_ip" {
  value = yandex_compute_instance.vm[*].network_interface[0].nat_ip_address
}

output "internal_ips" {
  value = yandex_compute_instance.vm[*].network_interface[0].ip_address
}