# Ngix-Vagrant
Practica de Ngix de Vagrant

## 1 Creamos el VagrantFile y le añadimos lo siguiente 

```
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

## 2 Creamos el provision.sh y lo que hacemos es actualizar la maquina y instalar el git y Ngix

```
    echo "==> Actualizando repositorios"
    apt update -y

    echo "==> Instalando Nginx"
    apt install nginx -y

    echo "==> Instalando Git"
    apt install git -y
```

## 3 Hacemos un vagrant Up y levantamos la maquina y hacemos un vagrant ssh

## 4 Miramos el estado del Ngix

## 5 Creamos en la maquina un archivo en mi caso llamado Pablo.test y nos me temos en el 

```
    sudo mkdir -p /var/www/pablo.test/html
    cd /var/www/pablo.test/html
```
## 6 Clonamos el repositorio de github de cloudacademy
```
    git clone https://github.com/cloudacademy/static-website-example
```


## 7 Le damos los siguientes permisos a pablo.test
```
    sudo chown -R www-data:www-data /var/www/pablo.test
    sudo chmod -R 755 /var/www/pablo.test
```
## 8 Abrimos nuestra ip de la maquina en el ordenador local y se tendria que ver el Welcome to nginx!

## 9 Ahora creamos un bloque en el servidor llamado pablo.test y le ponemos el siguiente contenido
```
    sudo nano /etc/nginx/sites-available/pablo.test
```
```
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

## 10 Activamos y reiniciamos el sitio web

```
    sudo ln -s /etc/nginx/sites-available/pablo.test /etc/nginx/sites-enabled/
    sudo systemctl restart nginx
```


