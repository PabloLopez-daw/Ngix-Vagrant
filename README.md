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
