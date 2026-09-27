terraform {
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "sa-key.json"
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

resource "yandex_vpc_security_group" "k3s_sg" {
  name       = "k3s-sg"
  network_id = yandex_vpc_network.network.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "K3s API"
    protocol       = "TCP"
    port           = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Flannel VXLAN"
    protocol       = "UDP"
    port           = 8472
    v4_cidr_blocks = ["10.131.0.0/24"]
  }

  ingress {
    description    = "Kubelet"
    protocol       = "TCP"
    port           = 10250
    v4_cidr_blocks = ["10.131.0.0/24"]
  }

  egress {
    description    = "Allow all outgoing"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
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
      size     = 30
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.k3s_sg.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }
}

output "external_ip" {
  value = yandex_compute_instance.vm[*].network_interface[0].nat_ip_address
}

output "internal_ips" {
  value = yandex_compute_instance.vm[*].network_interface[0].ip_address
}