#!/bin/bash

comprobarprivilegios() {
    if [ "$(id -u)" -eq 0 ]; then
        return 1  # Es root
    else
        return 0  # No es root
    fi
}

comprobarprivilegios

if [ $? -eq 1 ]; then
    echo "Continúa la ejecución"
else
    echo "El script no se puede seguir ejecutando porque el usuario que lo ejecuta no tiene privilegios de root"
    exit 1
fi
