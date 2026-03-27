#!/bin/bash
REPO_URL="https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
JAVA_URL="https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-linux_x64.tar.gz"

echo "--- Actualizando Instancia (Linux) ---"

# 1. Sincronizar Metadata
curl -s -O "$REPO_URL/mmc-pack.json"
curl -s -O "$REPO_URL/instance.cfg"

# 2. Packwiz (Instala DENTRO de minecraft)
java -jar packwiz-installer-bootstrap.jar -d minecraft "$REPO_URL/pack.toml"

# 3. Java Portable
if [ ! -f "./runtime/bin/java" ]; then
    echo "Descargando Azul Zulu para Linux..."
    mkdir -p ./runtime
    curl -L "$JAVA_URL" -o java_temp.tar.gz
    tar -xzf java_temp.tar.gz -C ./runtime --strip-components=1
    rm java_temp.tar.gz
fi