#!/bin/bash
REPO_URL="https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
JAVA_URL="https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-linux_x64.tar.gz"
INST_DIR="$(dirname "$(readlink -f "$0")")"

echo "--- Sincronizando Instancia (Linux) ---"

# ... (Lógica de RAM y Cfg igual que antes)

# Packwiz: Entrar a la carpeta para evitar error de -d
mkdir -p "$INST_DIR/minecraft"
cd "$INST_DIR/minecraft"
"../runtime/bin/java" -jar "../packwiz-installer-bootstrap.jar" "$REPO_URL/pack.toml"