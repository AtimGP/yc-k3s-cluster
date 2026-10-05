# yc-k3s-cluster

Развёртывание кластера Kubernetes (k3s) в Yandex Cloud с полной автоматизацией через Terraform и Ansible.

## Что это делает?

Проект создаёт с нуля:
- **Виртуальные машины** (control-plane + agents) в Yandex Cloud
- **Сеть и группы безопасности** для изоляции трафика
- **Настроенные серверы**: UFW, fail2ban, Docker
- **Работающий кластер k3s**, готовый к запуску приложений

Всё развёртывается легкой настройкой, и с использованием команд `terraform apply` и `ansible-playbook site.yml`.

## Стек

- **Terraform** - создание инфраструктуры в Yandex Cloud
- **Ansible** - настройка серверов и установка k3s
- **k3s** - дистрибутив Kubernetes
- **Docker, UFW, fail2ban** - контейнеризация и безопасность
- **Git** - контроль версий

## Как использовать

### Предварительные требования

1. Аккаунт в Yandex Cloud и сервисный аккаунт с ролью `editor`
2. Установленный Terraform
3. Установленный Ansible
4. SSH-ключ для доступа к VM

## Архитектура
```text
yc-vm3/
├── infra/
│   ├── terraform/
│   │   ├── main.tf          # Ресурсы Yandex Cloud
│   │   ├── variables.tf     # Переменные
│   │   ├── outputs.tf       # Вывод IP-адресов и генерация 
│   │   └── terraform.tfvars # Значения для продакшена
│   └── ansible/
│       ├── inventory/       # Внешние и внутренние IP, vars
│       ├── playbooks/       # Сценарии
│       └── roles/           # Роли (common, docker, k3s)
└── README.md
```

### Запуск

```bash
№1. Создать инфраструктуру
cd infra/terraform
terraform init
terraform apply

№2. Настроить серверы и развернуть k3s
cd ../ansible
ansible-playbook -i inventory/prod/hosts.yml playbooks/site.yml