#!/bin/bash
set -e

# Конфигурация версий
KUBECTL_VERSION="v1.10.0"
HELM_VERSION="v3.9.0"
K9S_VERSION="v0.25.18"

echo "=== Начинаем установку инструментов Kubernetes ==="

# Устанавливаем kubectl
echo "Устанавливаем kubectl ${KUBECTL_VERSION}..."
curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
echo "Установка kubectl ${KUBECTL_VERSION} завершена."

# Настраиваем автодополнение для kubectl
echo "Настраиваем автодополнение для kubectl..."
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'source /etc/bash_completion.d/kubectl' >> ~/.bashrc

# Устанавливаем Docker
echo "Устанавливаем Docker..."
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
echo "Установка Docker завершена."

# Устанавливаем Helm
echo "Устанавливаем Helm ${HELM_VERSION}..."
curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz
echo "Установка Helm завершена."

# Устанавливаем kubectx и kubens
echo "Устанавливаем kubectx и kubens..."
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
echo "Установка kubectx и kubens завершена."

# Устанавливаем k9s
echo "Устанавливаем k9s ${K9S_VERSION}..."
curl -LO "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz"
tar -zxvf k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/local/bin/
rm -f k9s_Linux_x86_64.tar.gz README.md LICENSE
echo "Установка k9s завершена."

# Устанавливаем kube-ps1
echo "Устанавливаем kube-ps1..."
git clone https://github.com/jonmosco/kube-ps1.git ~/.kube-ps1
echo 'source ~/.kube-ps1/kube-ps1.sh' >> ~/.bashrc
echo 'PS1='"'"'[\u@\h \W $(kube_ps1)]\$ '"'" >> ~/.bashrc
echo "Установка kube-ps1 завершена."

# Проверяем установку
echo "=== Проверка установленных компонентов ==="
kubectl version --client
docker --version
helm version
k9s version

echo "=== Установка инструментов Kubernetes успешно завершена ==="