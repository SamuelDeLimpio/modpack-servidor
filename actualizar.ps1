# Configuración Final (JRE 25.0.2)
$RepoURL = "https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
$JavaURL = "https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-win_x64.zip"
$JarFile = "$PSScriptRoot\packwiz-installer-bootstrap.jar"
$RuntimeDir = "$PSScriptRoot\runtime"
$MinecraftDir = "$PSScriptRoot\minecraft"

Write-Host "--- Sincronizando Instancia (Windows) ---" -ForegroundColor Cyan

# 1. RAM e Instance.cfg
$TotalRamGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$AsignarRAM = if ($TotalRamGB -le 5) { 2560 } else { 4096 }

$CfgPath = "$PSScriptRoot\instance.cfg"
if (Test-Path $CfgPath) {
    $Cfg = Get-Content $CfgPath
    $Cfg = $Cfg -replace "MinMem=.*", "MinMem=$AsignarRAM"
    $Cfg = $Cfg -replace "MaxMem=.*", "MaxMem=$AsignarRAM"
    $Cfg = $Cfg -replace "OverrideJava=.*", "OverrideJava=true"
    $Cfg = $Cfg -replace "JavaPath=.*", "JavaPath=runtime/bin/java.exe"
    $Cfg = $Cfg -replace "ExternalJavaCheck=.*", "ExternalJavaCheck=true"
    $Cfg = $Cfg -replace "IgnoreJavaCompatibility=.*", "IgnoreJavaCompatibility=true"
    $Cfg | Set-Content $CfgPath
}

# 2. Verificar Java
if (-not (Test-Path "$RuntimeDir\bin\java.exe")) {
    Write-Host "Instalando JRE 25 portable..." -ForegroundColor Yellow
    if (Test-Path $RuntimeDir) { Remove-Item $RuntimeDir -Recurse -Force }
    New-Item -ItemType Directory -Path $RuntimeDir
    Invoke-WebRequest -Uri $JavaURL -OutFile "java_temp.zip"
    $TempExtract = "$PSScriptRoot\runtime_temp"
    Expand-Archive -Path "java_temp.zip" -DestinationPath "$TempExtract"
    $SubFolder = Get-ChildItem -Path $TempExtract -Directory | Select-Object -First 1
    Move-Item -Path "$($SubFolder.FullName)\*" -Destination $RuntimeDir
    Remove-Item "java_temp.zip", $TempExtract -Recurse
}

# 3. Packwiz (EL CAMBIO CLAVE)
if (-not (Test-Path $MinecraftDir)) { New-Item -ItemType Directory -Path $MinecraftDir }
Set-Location $MinecraftDir

# Ejecutamos Packwiz desde ADENTRO de minecraft, apuntando al JAR de afuera
# NO usamos el flag -d para evitar carpetas anidadas y errores de comando
& "$RuntimeDir\bin\java.exe" -jar "$JarFile" "$RepoURL/pack.toml"

Write-Host "--- Sincronización Completada Correctamente ---" -ForegroundColor Green