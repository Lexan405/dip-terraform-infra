output "sa_access_key" {
  value     = yandex_iam_service_account_static_access_key.terraform_sa_key.access_key
  sensitive = true
}

output "sa_secret_key" {
  value     = yandex_iam_service_account_static_access_key.terraform_sa_key.secret_key
  sensitive = true
}

output "bucket_name" {
  value = yandex_storage_bucket.tf_state.bucket
}