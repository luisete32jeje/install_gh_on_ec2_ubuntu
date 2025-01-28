#!/bin/bash

comprobar_instalacion_gh() {
    if dpkg -l | grep -q "^ii.*gh"; then
        return 1  # El paquete está instalado
    else
        return 0  # El paquete no está instalado
    fi
}

comprobar_instalacion_gh

if [ $? -eq 1 ]; then
    echo "El programa gh ya está instalado"
else
    echo "El programa gh no está instalado"
fi
