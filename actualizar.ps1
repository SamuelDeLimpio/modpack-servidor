# Configuración
$RepoURL = "https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
$JavaURL = "https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-win_x64.zip"

Write-Host "--- Sincronizando Instancia ---" -ForegroundColor Cyan

# 1. Descargar Metadata (Asegura que Cleanroom y Configs estén al día)
Invoke-WebRequest -Uri "$RepoURL/mmc-pack.json" -OutFile "mmc-pack.json"
Invoke-WebRequest -Uri "$RepoURL/instance.cfg" -OutFile "instance.cfg"

# 2. Lógica de RAM Inteligente
$TotalRamGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
if ($TotalRamGB -le 5) {
    $AsignarRAM = 2560 # 2.5GB para PCs de 4GB totales
    Write-Host "Detectado sistema de poca RAM ($TotalRamGB GB). Asignando 2.5GB." -ForegroundColor Yellow
} else {
    $AsignarRAM = 4096 # 4GB para PCs de 8GB o más
    Write-Host "Detectado sistema de RAM suficiente ($TotalRamGB GB). Asignando 4GB." -ForegroundColor Green
}

# Modificar instance.cfg con la RAM detectada y los flags de Cleanroom
$Cfg = Get-Content "instance.cfg"
$Cfg = $Cfg -replace "MinMem=.*", "MinMem=$AsignarRAM"
$Cfg = $Cfg -replace "MaxMem=.*", "MaxMem=$AsignarRAM"
$Cfg = $Cfg -replace "JvmArgs=.*", "JvmArgs=-XX:+UseCompactObjectHeaders -XX:+UseZGC"
$Cfg | Set-Content "instance.cfg"

# 3. Packwiz (Mods)
java -jar packwiz-installer-bootstrap.jar -d minecraft "$RepoURL/pack.toml"

# 4. Java 25 (Si no existe)
if (-not (Test-Path ".\runtime\bin\java.exe")) {
    Write-Host "Instalando Java Azul Zulu 25.0.2..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $JavaURL -OutFile "java_temp.zip"
    Expand-Archive -Path "java_temp.zip" -DestinationPath ".\runtime_temp"
    Move-Item -Path ".\runtime_temp\zulu*" -Destination ".\runtime"
    Remove-Item "java_temp.zip", ".\runtime_temp" -Recurse
}