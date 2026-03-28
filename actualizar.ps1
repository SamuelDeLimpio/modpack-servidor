# Configuración Final (Solución de Ruta GitHub)
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

# 3. Packwiz (Ejecución desde la raíz de la instancia)
# Como en GitHub tus mods ya están en 'minecraft/mods', Packwiz
# automáticamente los pondrá en la carpeta 'minecraft' de Prism.
Set-Location $PSScriptRoot
& "$RuntimeDir\bin\java.exe" -jar "$JarFile" "$RepoURL/pack.toml"

Write-Host "--- Sincronización Exitosa ---" -ForegroundColor Green