output "external_ip" {
  value = yandex_compute_instance.vm[*].network_interface[0].nat_ip_address
}

output "internal_ips" {
  value = yandex_compute_instance.vm[*].network_interface[0].ip_address
}

resource "local_file" "ansible_hosts" {
  filename = "${path.module}/../ansible/inventory/prod/hosts.yml"

  content = <<-EOF
all:
  children:
    k3s_cluster:
      children:
        k3s_control_plane:
          hosts:
            vm-0:
              ansible_host: ${yandex_compute_instance.vm[0].network_interface[0].nat_ip_address}
              internal_ip: ${yandex_compute_instance.vm[0].network_interface[0].ip_address}
        k3s_workers:
          hosts:
%{ for i, vm in slice(yandex_compute_instance.vm, 1, length(yandex_compute_instance.vm)) ~}
            vm-${i + 1}:
              ansible_host: ${vm.network_interface[0].nat_ip_address}
              internal_ip: ${vm.network_interface[0].ip_address}
%{ endfor ~}
  EOF
}