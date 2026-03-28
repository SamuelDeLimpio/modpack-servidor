#!/bin/bash
INST_DIR="$(dirname "$(readlink -f "$0")")"

echo "--- Sincronizando Instancia (Linux) ---"

# 1. RAM e Instance.cfg
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
total_gb=$((total_kb / 1024 / 1024))
if [ "$total_gb" -le 5 ]; then asignar_ram=2560; else asignar_ram=4096; fi

sed -i "s/MinMem=.*/MinMem=$asignar_ram/" "$INST_DIR/instance.cfg"
sed -i "s/MaxMem=.*/MaxMem=$asignar_ram/" "$INST_DIR/instance.cfg"
sed -i "s/OverrideJava=.*/OverrideJava=true/" "$INST_DIR/instance.cfg"
sed -i "s/JavaPath=.*/JavaPath=runtime\/bin\/java/" "$INST_DIR/instance.cfg"
sed -i "s/ExternalJavaCheck=.*/ExternalJavaCheck=true/" "$INST_DIR/instance.cfg"
sed -i "s/IgnoreJavaCompatibility=.*/IgnoreJavaCompatibility=true/" "$INST_DIR/instance.cfg"

# 3. Packwiz (Ejecución desde la raíz)
cd "$INST_DIR"
"$INST_DIR/runtime/bin/java" -jar "$INST_DIR/packwiz-installer-bootstrap.jar" "$REPO_URL/pack.toml"