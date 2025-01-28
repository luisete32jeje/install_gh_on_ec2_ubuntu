#!/bin/bash

comprobar_sourceslist() {
    if grep -q "https://cli.github.com/packages stable main" /etc/apt/sources.list; then
        echo "El repositorio https://cli.github.com/packages stable main ya está en la lista de repositorios"
        return 0
    else
        echo "El repositorio https://cli.github.com/packages stable main todavía no forma parte de la lista de repositorios"
        return 1
    fi
}

comprobar_carpeta_sourceslist_d() {
    if grep -qr "https://cli.github.com/packages" /etc/apt/sources.list.d/; then
        echo "El repositorio https://cli.github.com/packages está en algún archivo de /etc/apt/sources.list.d/"
        return 1
    else
        echo "El repositorio https://cli.github.com/packages no está en ningún archivo de /etc/apt/sources.list.d/"
        return 0
    fi
}

comprobar_sourceslist
resultado_sourceslist=$?

comprobar_carpeta_sourceslist_d
resultado_sourceslist_d=$?

echo "Resultado de comprobar_sourceslist: $resultado_sourceslist"
echo "Resultado de comprobar_carpeta_sourceslist_d: $resultado_sourceslist_d"
