# Packer Templates для Ubuntu 18.04

Репозиторий содержит шаблоны для автоматического создания виртуальных машин на базе Ubuntu 18.04 с помощью HashiCorp Packer. Предназначен для быстрого развертывания специализированных окружений.

## Доступные шаблоны

### ubuntu1804_kube

Образ Ubuntu 18.04 с инструментами для работы с Kubernetes:

- kubectl v1.10.0
- Docker
- Helm v3.9.0
- kubectx/kubens
- k9s
- kube-ps1

[Подробнее](ubuntu1804_kube/Readme.md)

### ubuntu1804_devopspack

Полный набор инструментов для изучения DevOps:

- Контейнеризация (Docker, Docker Compose)
- Оркестрация (Kubernetes, Minikube, Helm)
- IAC (Terraform, Ansible, Packer)
- CI/CD (GitLab Runner, GitHub CLI)
- Базы данных (PostgreSQL, MySQL, MongoDB, Redis)
- Мониторинг (Prometheus, Grafana)
- Облачные CLI (AWS, Azure, Google Cloud)
- Языки программирования (Python, Node.js, Java)

[Подробнее](ubuntu1804_devopspack/Readme.md)

## Требования

- HashiCorp Packer (>= 1.7)
- Oracle VirtualBox (>= 6.1)
- SSH-ключ для настройки доступа
- Доступ в интернет

## Использование

```bash
cd ubuntu1804_devopspack  # или ubuntu1804_kube
packer build ubuntu.pkr.hcl
```

После сборки в директории output будет создан OVA-файл для импорта в VirtualBox.

## Параметры по умолчанию

- Пользователь: ubuntu
- Доступ: только по SSH-ключу
- Ресурсы: настраиваются в файле ubuntu.pkr.hcl
