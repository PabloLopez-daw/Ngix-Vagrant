# 🌐 Nginx + Vagrant --- Práctica Completa

Práctica de instalación y configuración de un servidor web **Nginx**
dentro de una máquina virtual gestionada con **Vagrant**.

------------------------------------------------------------------------

# 1. Instalat y configurar Nginx 

## 📁 1. Crear el archivo `Vagrantfile`

``` ruby
Vagrant.configure("2") do |config|

  # --- Sistema operativo ---
  config.vm.box = "debian/bullseye64"

  # --- Red privada ---
  config.vm.network "private_network", ip: "192.168.56.101"

  # --- Nombre de la máquina ---
  config.vm.hostname = "nginx-test"

  # --- Provisionamiento automático ---
  config.vm.provision "shell", path: "provision.sh"

end
```

------------------------------------------------------------------------

## ⚙️ 2. Crear el script `provision.sh`

Este script actualiza el sistema e instala Nginx y Git.

``` bash
echo "==> Actualizando repositorios"
apt update -y

echo "==> Instalando Nginx"
apt install nginx -y

echo "==> Instalando Git"
apt install git -y
```

------------------------------------------------------------------------

## 🚀 3. Levantar la máquina Vagrant

``` bash
vagrant up
vagrant ssh
```

------------------------------------------------------------------------

## 🔍 4. Comprobar el estado de Nginx

``` bash
systemctl status nginx
```

Debe mostrarse como **active (running)**.

------------------------------------------------------------------------

## 📂 5. Crear el directorio del sitio web

``` bash
sudo mkdir -p /var/www/pablo.test/html
cd /var/www/pablo.test/html
```

------------------------------------------------------------------------

## 🌐 6. Clonar el repositorio web

``` bash
git clone https://github.com/cloudacademy/static-website-example
```

------------------------------------------------------------------------

## 🔐 7. Ajustar permisos

``` bash
sudo chown -R www-data:www-data /var/www/pablo.test
sudo chmod -R 755 /var/www/pablo.test
```

------------------------------------------------------------------------

## 🖥️ 8. Probar Nginx con la IP

Abrir en el navegador:

    http://192.168.56.101

Debe aparecer **Welcome to Nginx!**

------------------------------------------------------------------------

## 🛠️ 9. Crear el bloque de servidor `pablo.test`

``` bash
sudo nano /etc/nginx/sites-available/pablo.test
```

Contenido:

``` nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/html/static-website-example;
    index index.html;

    server_name pablo.test;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

------------------------------------------------------------------------

## 🔗 10. Habilitar el sitio web y reiniciar Nginx

``` bash
sudo ln -s /etc/nginx/sites-available/pablo.test /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

------------------------------------------------------------------------

## 🧩 11. Configurar el archivo `hosts`

En el equipo host:

    192.168.56.101 pablo.test

------------------------------------------------------------------------

## 📡 12. Probar resolución

``` bash
ping pablo.test
```

------------------------------------------------------------------------

## 🌍 13. Usar DNS público nip.io

Editar:

``` bash
sudo nano /etc/nginx/sites-available/pablo.test
```

Añadir:

    server_name 192-168-56-101.pablo.test.nip.io;

Reiniciar:

``` bash
sudo systemctl restart nginx
```

Acceder desde el navegador:

    http://192-168-56-101.pablo.test.nip.io

# 2. Autentificacion del servidor

## 1.Comprobacion si el servidor va correctamente 
```bash
    curl -I http://192.168.56.101
    curl -I http://pablo.test
```

## 2. Creamos el fichero .htpasswd
```bash
     sudo touch /etc/nginx/.htpasswd
```

## 3. Creamos los usuarios con sus contraseñas con los siguientes comandos
```bash
    sudo sh -c "echo -n 'pablo:' >> /etc/nginx/.htpasswd"
    sudo sh -c "openssl passwd -apr1 'MiPass123' >> /etc/nginx/.htpasswd"
```

```bash
    sudo sh -c "echo -n 'apellido:' >> /etc/nginx/.htpasswd"
    sudo sh -c "openssl passwd -apr1 'MiPass123' >> /etc/nginx/.htpasswd"
``` 

## 4. Comprobamos con un cat al archivo de que se ha creado correctamente

```bash
    sudo cat /etc/nginx/.htpasswd
```

## 5. Editamos el server block pablo.test y le añadimos lo siguiente debajo de server_name

```bash
    sudo nano /etc/nginx/sites-available/pablo.test
```

```bash
    location / {
        auth_basic "Área restringida";
        auth_basic_user_file /etc/nginx/.htpasswd;
        try_files $uri $uri/ =404;
    }
``` 

## 6. Reiniciamos el servidor y comprobramos que va correctamente y que te pide un usuario y contra seña
```bash
    sudo nginx -t
    sudo systemctl restart nginx
```

## 7. Compreobamos con el curl , si haces el curl sin usuario y contraseña te debe salir error 401
```bash
    curl -I http://192-168-56-101.pablo.test.nip.io
    curl -u pablo:MyPass123 -I http://192-168-56-101.pablo.test.nip.io
```
## 8. Revisamos los log con el tail
```bash
    sudo tail -n 50 /var/log/nginx/error.log
    sudo tail -n 50 /var/log/nginx/access.log
```

## 9. Para aplicar la restriccion de usurio y contraseña en el blocke pablo.test tenemos que cambiar lo siguiente
```bash
server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/static-website-example;
    index index.html;

    server_name 192-168-56-101.pablo.test.nip.io;

    location / {
        try_files $uri $uri/ =404;
    }

    location = /contact.html {
        auth_basic "Área privada - Contact";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
```


## 10. Reiniciamos el servidor y comprobramos que va correctamente y que te pide un usuario y contraseña en contact.html
```bash
    sudo nginx -t
    sudo systemctl restart nginx
```

## 11. Para aplicar la restriccion de IP en el blocke pablo.test tenemos que cambiar lo siguiente
```bash
    server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/static-website-example;
    index index.html;

    server_name 192-168-56-101.pablo.test.nip.io;

    location / {
        deny 192.168.56.101;
        allow 192.168.56.0/24;
        deny all;

        try_files $uri $uri/ =404;
    }
}
```

## 12. Ahora hago un curl desde la maquina principal y me tiene que dar el error 403
```bash
    curl -u pablo:"MiPass123" -I http://192-168-56-101.pablo.test.nip.io
```

## 13. Ahora para combinar la autentificacion de ip y de usuario tienes que poner lo siguiente , lo que queremos esq no te deje si uno de las 2 restricciones falle, primero lo haremos fallar, comprobamos con el curl

```bash
server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/static-website-example;
    index index.html;

    server_name 192-168-56-101.pablo.test.nip.io;

    location / {
        satisfy all;
        allow 192.168.56.101;
        allow 192.168.56.0/24;
        deny all

        auth_basic "Administrator's Area";
        auth_basic_user_file /etc/nginx/.htpasswd;

        try_files $uri $uri/ =404;
    }
}
```


## 14. Ahora hacemos que vaya bien , comprobamos con el curl
```bash
server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/static-website-example;
    index index.html;

    server_name 192-168-56-101.pablo.test.nip.io;

    location / {
        satisfy all;
        deny 192.168.56.101;
        allow 192.168.56.0/24;
        deny all

        auth_basic "Administrator's Area";
        auth_basic_user_file /etc/nginx/.htpasswd;

        try_files $uri $uri/ =404;
    }
}
```

# 3. Acceso seguro con SSL/TSL NGINX

## 1. Primero configuramos el cortafuegos UFW
```bash
    sudo apt install ufw
    sudo ufw allow ssh
    sudo ufw allow 'Nginx Full'
    sudo ufw delete allow 'HTTP'
    sudo ufw --force enable
```

## 2. Generar certificado SSL/TSL
```bash
    sudo openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 -keyout /etc/ssl/private/pablo.test.key \
    -out /etc/ssl/certs/pablo.test.crt
```

## 3. Configurar el sitio web para usar SSL/TSL
```bash
    sudo nano /etc/nginx/sites-available/pablo.test
```

Contenido:

```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/pablo.test/static-website-example;
    index index.html;

    server_name 192-168-56-101.pablo.test.nip.io;

    location / {
        try_files $uri $uri/ =404;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    root /var/www/pablo.test/static-website-example;
    index index.html;

    server_name 192-168-56-101.pablo.test.nip.io;

    ssl_certificate /etc/ssl/certs/pablo.test.crt;
    ssl_certificate_key /etc/ssl/private/pablo.test.key;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

## 4. Reiniciar Nginx
```bash
    sudo systemctl restart nginx
```


