
#Опсиание backend находится в файле backend.tf
#Данный файл содержит ключи сервиснго акаунта и добавлен в .gitignore(не удалось записать в переменные окружения)

/*
terraform {
    backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "dotsenkois-netology"
    region     = "ru-central1-c"
    key        = "main-conf/test.tfstate"
    access_key = 
    secret_key = 

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
*/


provider "yandex" {
  zone = "ru-central1-c"
  #Ключи сохранены в переменых среды:
  #YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

locals {
  web_instance_type_map = {
    stage = "standard-v1"
    prod  = "standard-v2"
  }
  web_instance_count_map = {
    stage = 1
    prod  = 2
  }
  web_instance_name_map = {
    stage = "test-netology-stage"
    prod  = "test-netology-prod"
  }
  instances = {
    "standard-v1" = "fd8f30hur3255mjfi3hq"
    "standard-v2" = "fd8f30hur3255mjfi3hq"
  }

}


resource "yandex_compute_instance" "count" {

  name        = format("count-%03d", count.index + 1)
  platform_id = local.web_instance_type_map[terraform.workspace]
  hostname    = format("count-%03d", count.index + 1)
  description = "test vm for netology"
  count       = local.web_instance_count_map[terraform.workspace]


  resources {
    cores         = "2"
    memory        = "1"
    core_fraction = "20"
  }
  boot_disk {
    initialize_params {
      image_id = "fd8f30hur3255mjfi3hq"
      type     = "network-hdd"
      size     = "5"
    }
  }
  network_interface {
    subnet_id = "b0cgoir8ev0gjdgfn8ko"
    nat       = "true"
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
  scheduling_policy {
    preemptible = "true"
  }
}


resource "yandex_compute_instance" "foreach" {
  for_each    = local.instances
  platform_id = each.key

  resources {
    cores         = "2"
    memory        = "1"
    core_fraction = "20"
  }

  boot_disk {
    initialize_params {
      image_id = each.value
      type     = "network-hdd"
      size     = "5"
    }
  }
  network_interface {
    subnet_id = "b0cgoir8ev0gjdgfn8ko"
    nat       = "true"
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  scheduling_policy {
    preemptible = "true"
  }

}
