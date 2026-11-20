param(
    [string]$Contenedor = "postgres-dw",
    [string]$BaseDatos = "dw",
    [string]$Usuario = "estudiante"
)

$ErrorActionPreference = "Stop"

$Fecha = Get-Date -Format "yyyyMMdd_HHmmss"
$Directorio = Join-Path $PSScriptRoot "archivos"

New-Item -ItemType Directory -Force -Path $Directorio | Out-Null

$Respaldo = Join-Path $Directorio "dw_$Fecha.sql"
$Checksum = "$Respaldo.sha256"

docker exec $Contenedor pg_dump -U $Usuario -d $BaseDatos -f "/tmp/respaldo_dw.sql"

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo generar el respaldo."
}

docker cp "${Contenedor}:/tmp/respaldo_dw.sql" $Respaldo

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo copiar el respaldo."
}

docker exec $Contenedor rm -f "/tmp/respaldo_dw.sql"

$Hash = (Get-FileHash -Path $Respaldo -Algorithm SHA256).Hash
Set-Content -Path $Checksum -Value $Hash

Write-Host "Respaldo generado: $Respaldo"
Write-Host "Checksum SHA256: $Hash"
