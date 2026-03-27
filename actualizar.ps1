# Configuración
$RepoURL = "https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
$JavaURL = "https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-win_x64.zip"

Write-Host "--- Actualizando Instancia (Windows) ---" -ForegroundColor Cyan

# 1. Sincronizar Metadata de Prism
Invoke-WebRequest -Uri "$RepoURL/mmc-pack.json" -OutFile "mmc-pack.json"
Invoke-WebRequest -Uri "$RepoURL/instance.cfg" -OutFile "instance.cfg"

# 2. Packwiz (Instala DENTRO de la carpeta minecraft)
java -jar packwiz-installer-bootstrap.jar -d minecraft "$RepoURL/pack.toml"

# 3. Gestión de Java Azul Zulu 25.0.2
if (-not (Test-Path ".\runtime\bin\java.exe")) {
    Write-Host "Java no detectado. Descargando Azul Zulu..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $JavaURL -OutFile "java_temp.zip"
    Expand-Archive -Path "java_temp.zip" -DestinationPath ".\runtime_temp"
    # Mover contenido y limpiar
    Move-Item -Path ".\runtime_temp\zulu*" -Destination ".\runtime"
    Remove-Item "java_temp.zip", ".\runtime_temp" -Recurse
}