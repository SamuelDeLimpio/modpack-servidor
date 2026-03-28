# Configuración
$RepoURL = "https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
$JavaURL = "https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-win_x64.zip"
$JarFile = "$PSScriptRoot\packwiz-installer-bootstrap.jar"

Write-Host "--- Sincronizando Instancia ---" -ForegroundColor Cyan

# 1. RAM Inteligente (Ya funcionando en tu log)
$TotalRamGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$AsignarRAM = if ($TotalRamGB -le 5) { 2560 } else { 4096 }

# 2. Actualizar instance.cfg (Auto-corrección de errores)
$Cfg = Get-Content "$PSScriptRoot\instance.cfg"
$Cfg = $Cfg -replace "MinMem=.*", "MinMem=$AsignarRAM"
$Cfg = $Cfg -replace "MaxMem=.*", "MaxMem=$AsignarRAM"
# Forzamos a saltar el chequeo de compatibilidad para evitar bloqueos
$Cfg = $Cfg -replace "ExternalJavaCheck=.*", "ExternalJavaCheck=true" 
$Cfg | Set-Content "$PSScriptRoot\instance.cfg"

# 3. Java 25 (Si falta, lo descarga)
if (-not (Test-Path "$PSScriptRoot\runtime\bin\java.exe")) {
    Write-Host "Instalando Java Azul Zulu 25..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $JavaURL -OutFile "java_temp.zip"
    Expand-Archive -Path "java_temp.zip" -DestinationPath "$PSScriptRoot\runtime_temp"
    Move-Item -Path "$PSScriptRoot\runtime_temp\zulu*" -Destination "$PSScriptRoot\runtime"
    Remove-Item "java_temp.zip", "$PSScriptRoot\runtime_temp" -Recurse
}

# 4. Packwiz (USANDO RUTA ABSOLUTA PARA EL JAR)
$JavaExe = "$PSScriptRoot\runtime\bin\java.exe"
& $JavaExe -jar "$JarFile" -d "$PSScriptRoot\minecraft" "$RepoURL/pack.toml"