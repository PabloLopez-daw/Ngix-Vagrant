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


