# data "yandex_compute_instance" "current" {
#     name = "test-netology"
# }

# output "instance_external_ip" {
#   value = "${data.yandex_compute_instance.current.network_interface.0.nat_ip_address}"
# }

