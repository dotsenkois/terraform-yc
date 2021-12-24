
provider "yandex" {
  #token     = "${var.YC_TOKEN}"
  #cloud_id  = "${var.YC_CLOUD_ID}"
  #folder_id = "${var.YC_FOLDER_ID}"
  zone      = "ru-central1-c"
}

resource "yandex_compute_instance" "vm-test-netology" {
  name = "test-netology"

  platform_id = "standard-v2"
  hostname = "helloworld_01"
  description = "test vm for netology"


  resources {
    cores  = "2"
    memory = "1"
    core_fraction = "20"
  }
  boot_disk {
    initialize_params {
      image_id = "main"
      type = "network-hdd"
      size = "5"
    }
  }
  network_interface {
    subnet_id = "b0cgoir8ev0gjdgfn8ko"
    nat       = "true"
  }
  metadata = {
  
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}