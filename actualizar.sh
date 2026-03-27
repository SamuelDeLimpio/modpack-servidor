#!/bin/bash

# Configuración
REPO_URL="https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
# Nota: Aquí deberías poner el link del .tar.gz de Azul Zulu para Linux x64
JAVA_URL="https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-linux_x64.tar.gz"

echo "Cambiando a directorio de la instancia..."
cd "$INST_DIR"

# 1. Actualizar Modloader (Cleanroom)
echo "Comprobando actualizaciones de Cleanroom..."
curl -s -O "$REPO_URL/mmc-pack.json"

# 2. Ejecutar Packwiz
echo "Actualizando mods..."
java -jar packwiz-installer-bootstrap.jar "$REPO_URL/pack.toml"

# 3. Gestión de Java (Linux)
if [ ! -f "./runtime/bin/java" ]; then
    echo "Java no detectado. Descargando Azul Zulu para Linux..."
    mkdir -p ./runtime
    curl -L "$JAVA_URL" -o java_temp.tar.gz
    tar -xzf java_temp.tar.gz -C ./runtime --strip-components=1
    rm java_temp.tar.gz
    
    # Ajustar instance.cfg para Linux
    sed -i 's|JavaPath=.*|JavaPath=runtime/bin/java|' instance.cfg
fi