data "yandex_compute_instance" "my_instance" {
    name = "test-netology"
}

output "instance_external_ip" {
  value = "${data.yandex_compute_instance.my_instance.network_interface.0.nat_ip_address}"
}