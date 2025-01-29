#!/bin/bash

# Función para comprobar si el usuario es root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Este script debe ejecutarse como root." >&2
        exit 1
    fi
}

# Función para verificar si el paquete gh está instalado y, si no, instalarlo
install_gh() {
    if dpkg -l | grep -q "^ii  gh "; then
        echo "El paquete 'gh' ya está instalado."
    else
        echo "Instalando GitHub CLI..."
        apt update
        apt install -y gh
    fi
}

# Función para verificar si el repositorio de GitHub CLI está en la lista de APT y, si no, añadirlo
add_github_repo() {
    local repo_file="/etc/apt/sources.list.d/github-cli.list"
    local repo_url="https://cli.github.com/packages"
    
    if [[ -f "$repo_file" ]] && grep -q "$repo_url" "$repo_file"; then
        echo "El repositorio de GitHub CLI ya está añadido en APT."
    else
        echo "Añadiendo el repositorio de GitHub CLI..."
        
        # Asegurar que wget está instalado
        if ! type -p wget >/dev/null; then
            echo "Instalando wget..."
            apt update
            apt install -y wget
        fi

        # Crear el directorio de keyrings si no existe
        mkdir -p -m 755 /etc/apt/keyrings

        # Descargar e instalar la clave GPG
        out=$(mktemp)
        wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
        cat "$out" | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
        chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

        # Añadir el repositorio
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] $repo_url stable main" | tee "$repo_file" > /dev/null

        # Actualizar APT
        apt update
    fi
}

# Llamar a las funciones en orden
check_root
add_github_repo
install_gh

echo "Proceso completado."
