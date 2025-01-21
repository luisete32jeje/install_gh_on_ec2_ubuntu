k#!/bin/bash

# Verificar si el script se ejecuta como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

# Verificar si wget está instalado
if ! type wget >/dev/null 2>&1; then
    echo "Instalando wget..."
    sudo apt update
    sudo apt-get install wget -y
fi

# Crear directorio de claves si no existe
if [ ! -d "/etc/apt/keyrings" ]; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
fi

# Verificar si el repositorio ya está añadido
repo_file="/etc/apt/sources.list.d/github-cli.list"
repo_entry="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"
repo_added=false

if [ -f "$repo_file" ]; then
    if grep -q "$repo_entry" "$repo_file"; then
        repo_added=true
    fi
fi

if [ "$repo_added" = false ]; then
    # Descargar clave GPG
    out=$(mktemp)
    wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
    
    if [ -s "$out" ]; then
        cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
        sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    else
        echo "Error al descargar la clave GPG."
        exit 1
    fi
    
    # Agregar repositorio
    echo "$repo_entry" | sudo tee "$repo_file" > /dev/null
    sudo apt update
fi

# Verificar si GitHub CLI ya está instalado
if ! type gh >/dev/null 2>&1; then
    echo "Instalando GitHub CLI..."
    sudo apt install gh -y
else
    echo "GitHub CLI ya está instalado."
fi
