param(
    [Parameter(Mandatory = $true)]
    [string]$Respaldo,

    [string]$Contenedor = "postgres-dw",
    [string]$BaseDatos = "dw_restauracion",
    [string]$Usuario = "estudiante"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Respaldo -PathType Leaf)) {
    throw "No se encontró el archivo de respaldo."
}

$Respaldo = (Resolve-Path -LiteralPath $Respaldo).Path
$ArchivoChecksum = "$Respaldo.sha256"

if (-not (Test-Path -LiteralPath $ArchivoChecksum -PathType Leaf)) {
    throw "No se encontró el archivo de checksum."
}

$HashEsperado = (Get-Content -LiteralPath $ArchivoChecksum -Raw).Trim()
$HashActual = (Get-FileHash -LiteralPath $Respaldo -Algorithm SHA256).Hash

if ($HashActual -ne $HashEsperado) {
    throw "El checksum no coincide. Se canceló la restauración."
}

docker exec $Contenedor psql -U $Usuario -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$BaseDatos'"

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo consultar PostgreSQL."
}

if ($BaseDatos -notmatch '^[a-zA-Z_][a-zA-Z0-9_]*$') {
    throw "El nombre de la base de datos no es válido."
}

$Existe = docker exec $Contenedor psql -U $Usuario -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$BaseDatos'"

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo verificar la base de datos."
}

if ($Existe -eq "1") {
    throw "La base de datos de restauración ya existe. No se sobrescribirá."
}

docker exec $Contenedor createdb -U $Usuario $BaseDatos

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo crear la base de datos de restauración."
}

docker cp $Respaldo "${Contenedor}:/tmp/restauracion_dw.sql"

if ($LASTEXITCODE -ne 0) {
    throw "No se pudo copiar el respaldo al contenedor."
}

try {
    docker exec $Contenedor psql -X -v ON_ERROR_STOP=1 -U $Usuario -d $BaseDatos -f "/tmp/restauracion_dw.sql"

    if ($LASTEXITCODE -ne 0) {
        throw "La restauración falló."
    }

    Write-Host "Checksum verificado correctamente."
    Write-Host "Restauración completada en: $BaseDatos"
}
finally {
    docker exec $Contenedor rm -f "/tmp/restauracion_dw.sql"
}
