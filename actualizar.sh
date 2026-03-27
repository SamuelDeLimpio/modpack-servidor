#!/bin/bash
REPO_URL="https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
JAVA_URL="https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-linux_x64.tar.gz"

echo "--- Sincronizando Instancia Inteligente (Linux) ---"

# 1. Descargar Metadata
curl -s -O "$REPO_URL/mmc-pack.json"
curl -s -O "$REPO_URL/instance.cfg"

# 2. Lógica de RAM Inteligente
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
total_gb=$((total_kb / 1024 / 1024))

if [ "$total_gb" -le 5 ]; then
    asignar_ram=2560
    echo "Sistema de poca RAM ($total_gb GB). Asignando 2.5GB."
else
    asignar_ram=4096
    echo "Sistema de RAM suficiente ($total_gb GB). Asignando 4GB."
fi

# Modificar instance.cfg (sed)
sed -i "s/MinMem=.*/MinMem=$asignar_ram/" instance.cfg
sed -i "s/MaxMem=.*/MaxMem=$asignar_ram/" instance.cfg
sed -i "s/JvmArgs=.*/JvmArgs=-XX:+UseCompactObjectHeaders -XX:+UseZGC/" instance.cfg

# 3. Packwiz
java -jar packwiz-installer-bootstrap.jar -d minecraft "$REPO_URL/pack.toml"

# 4. Java 25
if [ ! -f "./runtime/bin/java" ]; then
    echo "Instalando Java Azul Zulu 25.0.2..."
    mkdir -p ./runtime
    curl -L "$JAVA_URL" -o java_temp.tar.gz
    tar -xzf java_temp.tar.gz -C ./runtime --strip-components=1
    rm java_temp.tar.gz
fi