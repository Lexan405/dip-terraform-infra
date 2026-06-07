variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "sa_key_file" {
  description = "Path to the JSON key file of the service account"
  type        = string
}

variable "sa_name" {
  description = "Name of the service account to use for K8s cluster"
  type        = string
  default     = "terraform-sa"
}

variable "k8s_release_channel" {
  description = "Kubernetes release channel (STABLE, RAPID, REGULAR). Version is selected automatically."
  type        = string
  default     = "STABLE"
}

variable "node_count" {
  description = "Number of worker nodes per zone"
  type        = number
  default     = 1
}

variable "node_cores" {
  description = "Number of CPU cores per node"
  type        = number
  default     = 2
}

variable "node_memory" {
  description = "Memory (GB) per node"
  type        = number
  default     = 4
}

variable "node_core_fraction" {
  description = "CPU core fraction (5, 20, 50, 100)"
  type        = number
  default     = 20
}

variable "node_disk_size" {
  description = "Boot disk size (GB) per node"
  type        = number
  default     = 30
}

variable "registry_name" {
  description = "Name of the existing Container Registry"
  type        = string
  default     = "dip-registry"
}