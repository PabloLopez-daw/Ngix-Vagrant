#!/bin/bash

echo "========================================"
echo "   >>> PROVISIONANDO MAQUINA VAGRANT <<<"
echo "========================================"

echo "[1/10] Actualizando repositorios..."
sudo apt update -y

echo "[2/10] Instalando Nginx..."
sudo apt install nginx -y

echo "[3/10] Instalando Git..."
sudo apt install git -y

echo "[4/10] Creando estructura de directorios..."
sudo mkdir -p /var/www/pablo.test/html

echo "[5/10] Clonando repositorio web..."
cd /var/www/pablo.test/html
if [ ! -d "static-website-example" ]; then
    sudo git clone https://github.com/cloudacademy/static-website-example
else
    echo "El repositorio ya estaba clonado."
fi

echo "[6/10] Ajustando permisos..."
sudo chown -R www-data:www-data /var/www/pablo.test
sudo chmod -R 755 /var/www/pablo.test

echo "[7/10] Creando archivo de configuración de Nginx (pablo.test + nip.io)..."
sudo tee /etc/nginx/sites-available/pablo.test > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/html/static-website-example;
    index index.html;

    # Dominios: local y público nip.io
    server_name pablo.test 192-168-56-101.pablo.test.nip.io;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

echo "[8/10] Activando sitio web..."
if [ ! -L /etc/nginx/sites-enabled/pablo.test ]; then
    sudo ln -s /etc/nginx/sites-available/pablo.test /etc/nginx/sites-enabled/
fi

echo "Deshabilitando sitio por defecto..."
sudo rm -f /etc/nginx/sites-enabled/default

echo "[9/10] Comprobando configuración..."
sudo nginx -t

echo "[10/10] Reiniciando Nginx..."
sudo systemctl restart nginx

echo "=========================================="
echo "       >>> PROVISION COMPLETADO <<<"
echo " Local:  http://pablo.test"
echo " nip.io: http://192-168-56-101.pablo.test.nip.io"
echo "=========================================="
