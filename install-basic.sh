#!/bin/bash
set -e

echo "=== Linea Besu (Basic Profile) Kurulumu Başlıyor ==="

# Gerekli paketler
echo "[1/6] Paketler yükleniyor..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq > /dev/null
sudo apt-get install -y -qq curl wget git > /dev/null

# Docker kurulumu
echo "[2/6] Docker kurulumu kontrol ediliyor..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh > /dev/null
    rm get-docker.sh
fi

# Docker Compose v2 kontrol
if ! docker compose version &> /dev/null; then
    echo "[!] Docker Compose v2 bulunamadı, lütfen manuel kurun."
    exit 1
fi

# Eski docker container & volume temizliği
echo "[3/6] Docker artıklarını temizliyor..."
sudo docker compose -f /mnt/linea/linea-node/docker-compose.yaml down --remove-orphans 2>/dev/null || true
sudo docker system prune -af --volumes -y

# /mnt/linea dizini hazırlanıyor
echo "[4/6] Dizini temizliyor ve oluşturuyor..."
sudo rm -rf /mnt/linea
sudo mkdir -p /mnt/linea/linea-node
sudo chown $USER:$USER /mnt/linea
