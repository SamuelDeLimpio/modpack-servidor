# Configuración
$RepoURL = "https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
$JavaZipURL = "https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-win_x64.zip" # Debes poner el link directo al .zip de Azul Zulu

# 1. Sincronizar Modloader (Cleanroom)
Write-Host "Comprobando actualizaciones de Cleanroom..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "$RepoURL/mmc-pack.json" -OutFile "mmc-pack.json"

# 2. Ejecutar Packwiz Installer
Write-Host "Actualizando mods..." -ForegroundColor Green
java -jar packwiz-installer-bootstrap.jar "$RepoURL/pack.toml"

# 3. Gestión de Java Azul Zulu
$JavaPath = ".\runtime\bin\java.exe"
if (-not (Test-Path $JavaPath)) {
    Write-Host "Java no detectado. Descargando Azul Zulu..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path ".\runtime"
    Invoke-WebRequest -Uri $JavaZipURL -OutFile "java_temp.zip"
    Expand-Archive -Path "java_temp.zip" -DestinationPath ".\runtime" -Force
    Remove-Item "java_temp.zip"
    
    # Forzar a Prism a usar este Java en instance.cfg
    (Get-Content instance.cfg) -replace 'JavaPath=.*', "JavaPath=runtime/bin/java.exe" | Set-Content instance.cfg
}