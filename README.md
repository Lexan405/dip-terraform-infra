# Terraform Infrastructure for Yandex Cloud

Инфраструктура дипломного проекта в Yandex Cloud.

## Структура

- `iam/` — сервисный аккаунт и S3 bucket для state
- `infra/` — VPC, Kubernetes, Container Registry

## Использование

### IAM (первый запуск)

```bash
cd iam
terraform init
terraform apply
