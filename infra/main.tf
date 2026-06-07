terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.130.0"
    }
  }

  backend "s3" {}
}

provider "yandex" {
  service_account_key_file = var.sa_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

# =============================================================================
# DATA SOURCES — Получаем существующие ресурсы динамически
# =============================================================================

# Получаем ID сервисного аккаунта по имени
data "yandex_iam_service_account" "terraform_sa" {
  name = var.sa_name
}

# =============================================================================
# СЕТЬ (VPC)
# =============================================================================

resource "yandex_vpc_network" "dip_network" {
  name = "dip-network"
}

resource "yandex_vpc_subnet" "subnet_a" {
  name           = "dip-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.dip_network.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "dip-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.dip_network.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet_d" {
  name           = "dip-subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.dip_network.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}

# =============================================================================
# KUBERNETES CLUSTER
# =============================================================================

resource "yandex_kubernetes_cluster" "dip_k8s" {
  name            = "dip-k8s-cluster"
  description     = "Diploma project Kubernetes cluster"
  network_id      = yandex_vpc_network.dip_network.id
  release_channel = var.k8s_release_channel

  
  service_account_id      = data.yandex_iam_service_account.terraform_sa.id
  node_service_account_id = data.yandex_iam_service_account.terraform_sa.id

  master {
    
    zonal {
      zone      = yandex_vpc_subnet.subnet_a.zone
      subnet_id = yandex_vpc_subnet.subnet_a.id
    }
    public_ip = true
  }
}

# =============================================================================
# NODE GROUP (Worker Nodes)
# =============================================================================

resource "yandex_kubernetes_node_group" "dip_k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.dip_k8s.id
  name       = "dip-k8s-node-group"
  version    = yandex_kubernetes_cluster.dip_k8s.master[0].version

  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = var.node_cores
      memory        = var.node_memory
      core_fraction = var.node_core_fraction
    }

    boot_disk {
      type = "network-hdd"
      size = var.node_disk_size
      
      
    }

    scheduling_policy {
      preemptible = true
    }

    network_interface {
      subnet_ids = [
        yandex_vpc_subnet.subnet_a.id,
        yandex_vpc_subnet.subnet_b.id,
        yandex_vpc_subnet.subnet_d.id,
      ]
      nat = true
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }

  allocation_policy {
    location { zone = "ru-central1-a" }
    location { zone = "ru-central1-b" }
    location { zone = "ru-central1-d" }
  }
}

# =============================================================================
# YANDEX CONTAINER REGISTRY (создаётся через Terraform, как требует задание)
# =============================================================================

resource "yandex_container_registry" "dip_registry" {
  name      = var.registry_name
  folder_id = var.folder_id
}