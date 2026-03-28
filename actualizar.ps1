# Configuración Final (Solución de Ruta GitHub)
$RepoURL = "https://raw.githubusercontent.com/SamuelDeLimpio/modpack-servidor/main"
$JavaURL = "https://cdn.azul.com/zulu/bin/zulu25.32.21-ca-jre25.0.2-win_x64.zip"
$JarFile = "$PSScriptRoot\packwiz-installer-bootstrap.jar"
$RuntimeDir = "$PSScriptRoot\runtime"

Write-Host "--- Sincronizando Instancia (Windows) ---" -ForegroundColor Cyan

# 1. Ajustes de RAM e Instance.cfg
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

# 2. Verificar y Descargar Java
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

# 3. Packwiz (Ejecución desde la raíz de la instancia)
# Como en GitHub tus mods ya están en 'minecraft/mods', Packwiz
# automáticamente los pondrá en la carpeta 'minecraft' de Prism.
Set-Location $PSScriptRoot
& "$RuntimeDir\bin\java.exe" -jar "$JarFile" "$RepoURL/pack.toml"

Write-Host "--- Sincronización Exitosa ---" -ForegroundColor Green