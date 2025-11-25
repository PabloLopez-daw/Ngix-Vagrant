#!/bin/bash

echo "==> Actualizando repositorios"
apt update -y

echo "==> Instalando Nginx"
apt install nginx -y

echo "==> Instalando Git"
apt install git -y