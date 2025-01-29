#!/bin/bash

# Verificar si el usuario tiene permisos de root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

# Verificar si wget está instalado
if ! type -p wget >/dev/null; then
    echo "Instalando wget..."
    apt update
    apt-get install wget -y
fi

# Crear el directorio de keyrings si no existe
if [[ ! -d /etc/apt/keyrings ]]; then
    mkdir -p -m 755 /etc/apt/keyrings
fi

# Descargar la clave GPG
out=$(mktemp)
wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg

# Copiar la clave GPG al directorio adecuado
if [[ -s "$out" ]]; then
    cat "$out" | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
else
    echo "Error al descargar la clave GPG." >&2
    exit 1
fi

# Agregar el repositorio de GitHub CLI
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Actualizar paquetes e instalar GitHub CLI
apt update
apt install gh -y

echo "GitHub CLI ha sido instalado correctamente."
