#!/bin/bash
REPO_URL="https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
JAVA_URL="https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-linux_x64.tar.gz"
INST_DIR="$(dirname "$(readlink -f "$0")")"

echo "--- Sincronizando Instancia (Linux) ---"

# 1. Ajustes de RAM y Cfg
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
total_gb=$((total_kb / 1024 / 1024))
if [ "$total_gb" -le 5 ]; then asignar_ram=2560; else asignar_ram=4096; fi

sed -i "s/MinMem=.*/MinMem=$asignar_ram/" "$INST_DIR/instance.cfg"
sed -i "s/MaxMem=.*/MaxMem=$asignar_ram/" "$INST_DIR/instance.cfg"
sed -i "s/OverrideJava=.*/OverrideJava=true/" "$INST_DIR/instance.cfg"
sed -i "s/JavaPath=.*/JavaPath=runtime\/bin\/java/" "$INST_DIR/instance.cfg"
sed -i "s/ExternalJavaCheck=.*/ExternalJavaCheck=true/" "$INST_DIR/instance.cfg"
sed -i "s/IgnoreJavaCompatibility=.*/IgnoreJavaCompatibility=true/" "$INST_DIR/instance.cfg"

# 2. Java 25
if [ ! -f "$INST_DIR/runtime/bin/java" ]; then
    echo "Descargando JRE 25..."
    mkdir -p "$INST_DIR/runtime"
    curl -L "$JAVA_URL" -o "$INST_DIR/java_temp.tar.gz"
    tar -xzf "$INST_DIR/java_temp.tar.gz" -C "$INST_DIR/runtime" --strip-components=1
    rm "$INST_DIR/java_temp.tar.gz"
fi

# 3. Packwiz (Desde la raíz de la instancia)
"$INST_DIR/runtime/bin/java" -jar "$INST_DIR/packwiz-installer-bootstrap.jar" -d minecraft "$REPO_URL/pack.toml"