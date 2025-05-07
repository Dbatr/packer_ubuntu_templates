#!/bin/bash

set -e

# Функция логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Обновление репозиториев
log "Обновление списка пакетов..."
apt-get update

# Установка базовых утилит
log "Установка базовых утилит..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    wget \
    unzip \
    git \
    vim \
    nano \
    htop \
    net-tools \
    tcpdump \
    nmap \
    netcat \
    traceroute \
    dnsutils \
    jq \
    tree \
    rsync \
    tmux \
    screen

# Установка Docker
log "Установка Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker

# Установка Docker Compose
log "Установка Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/v2.20.3/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Установка Kubernetes инструментов
log "Установка kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

log "Установка Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

log "Установка Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Установка Terraform
log "Установка Terraform..."
TERRAFORM_VERSION="1.8.0"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
mv terraform /usr/local/bin/
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Установка Ansible
log "Установка Ansible..."
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

# Установка Packer
log "Установка Packer..."
PACKER_VERSION="1.10.0"
wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"
unzip "packer_${PACKER_VERSION}_linux_amd64.zip"
mv packer /usr/local/bin/
rm "packer_${PACKER_VERSION}_linux_amd64.zip"

# Установка языков программирования и инструментов разработки
log "Установка Python и pip..."
apt-get install -y python3 python3-pip python3-venv

# Установка Node.js и npm
log "Установка Node.js и npm..."
curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

# Установка Java 17
log "Установка Java 17..."
apt-get install -y software-properties-common
add-apt-repository ppa:openjdk-r/ppa -y
apt-get update
apt-get install -y openjdk-17-jdk
java -version
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' > /etc/profile.d/java.sh

# Установка облачных CLI
log "Установка AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

log "Установка Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Установка Google Cloud SDK
log "Установка Google Cloud SDK..."
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update && apt-get install -y google-cloud-sdk

# Установка инструментов CI/CD
log "Установка GitLab Runner..."
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | bash
apt-get install -y gitlab-runner

# Установка GitHub CLI
log "Установка GitHub CLI..."
GH_VERSION="2.40.1"
wget "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz"
tar -xzf "gh_${GH_VERSION}_linux_amd64.tar.gz"
cp "gh_${GH_VERSION}_linux_amd64/bin/gh" /usr/local/bin/
rm -rf "gh_${GH_VERSION}_linux_amd64" "gh_${GH_VERSION}_linux_amd64.tar.gz"

# Установка баз данных
log "Установка PostgreSQL..."
apt-get install -y postgresql postgresql-contrib

log "Установка MySQL..."
apt-get install -y mysql-server

# Установка MongoDB
log "Установка MongoDB..."
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
apt-get update
apt-get install -y mongodb-org
systemctl enable mongod
systemctl start mongod

log "Установка Redis..."
apt-get install -y redis-server
systemctl enable redis-server
systemctl start redis-server


# Установка инструментов мониторинга
log "Установка Prometheus Node Exporter..."
useradd -rs /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.5.0.linux-amd64.tar.gz
cp node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.5.0.linux-amd64*

cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# Установка Grafana
log "Установка Grafana..."
apt-get install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install -y grafana
systemctl enable grafana-server
systemctl start grafana-server


# Загрузка примеров конфигураций и учебных материалов
log "Создание директории с примерами..."
mkdir -p /opt/devops-examples
cd /opt/devops-examples

# Terraform примеры
mkdir -p terraform-examples
cat > terraform-examples/main.tf << EOF
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "example-instance"
  }
}
EOF

# Docker Compose примеры
mkdir -p docker-examples
cat > docker-examples/docker-compose.yml << EOF
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
  db:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: example
      POSTGRES_USER: example
      POSTGRES_DB: exampledb
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  db-data:
EOF

mkdir -p docker-examples/html
echo "<html><body><h1>DevOps Example</h1></body></html>" > docker-examples/html/index.html

# Kubernetes примеры
mkdir -p kubernetes-examples
cat > kubernetes-examples/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
EOF

cat > kubernetes-examples/service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
EOF

# Ansible примеры
mkdir -p ansible-examples
cat > ansible-examples/inventory.ini << EOF
[webservers]
web1 ansible_host=192.168.1.10
web2 ansible_host=192.168.1.11

[dbservers]
db1 ansible_host=192.168.1.20

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/user/.ssh/id_rsa
EOF

cat > ansible-examples/playbook.yml << EOF
---
- name: Install and configure web server
  hosts: webservers
  become: true
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        
    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes
EOF

# Создание README с описанием установленных инструментов
cat > /opt/devops-examples/README.md << EOF
# DevOps Tools Environment

Данное окружение содержит следующие инструменты:

## Контейнеризация
- Docker & Docker Compose

## Оркестрация
- Kubernetes (kubectl)
- Minikube
- Helm

## Infrastructure as Code
- Terraform
- Ansible
- Packer

## CI/CD
- GitLab Runner
- GitHub CLI

## Базы данных
- PostgreSQL
- MySQL
- MongoDB
- Redis

## Мониторинг и логирование
- Prometheus Node Exporter
- Grafana

## Облачные платформы
- AWS CLI
- Azure CLI
- Google Cloud CLI

## Языки программирования
- Python
- Node.js
- Java 17

## Примеры
В данной директории (/opt/devops-examples) содержатся примеры конфигураций для:
- Terraform
- Docker Compose
- Kubernetes
- Ansible

## Документация
Рекомендуемые ресурсы для изучения:
- Docker: https://docs.docker.com/
- Kubernetes: https://kubernetes.io/docs/
- Terraform: https://learn.hashicorp.com/terraform
- Ansible: https://docs.ansible.com/
EOF

# Настройка прав доступа
chmod -R 755 /opt/devops-examples

log "Установка всех DevOps инструментов завершена!"
log "Примеры конфигураций и учебные материалы доступны в директории: /opt/devops-examples"