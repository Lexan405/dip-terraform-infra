output "k8s_cluster_id" {
  value = yandex_kubernetes_cluster.dip_k8s.id
}

output "k8s_master_external_v4_address" {
  value = yandex_kubernetes_cluster.dip_k8s.master[0].external_v4_address
}

output "container_registry_id" {
  value = yandex_container_registry.dip_registry.id
}

output "container_registry_endpoint" {
  value = "cr.yandex"
}

output "k8s_actual_version" {
  description = "Actual Kubernetes version deployed"
  value       = yandex_kubernetes_cluster.dip_k8s.master[0].version
}

output "k8s_release_channel" {
  description = "Kubernetes release channel used"
  value       = yandex_kubernetes_cluster.dip_k8s.release_channel
}