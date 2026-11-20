# Resultados de respaldo y restauración

## Entorno de pruebas

- Motor: PostgreSQL 16
- Contenedor: isw623-pruebas-postgres-pruebas-1
- Base original: pruebas_sgbd
- Base restaurada: dw_restauracion

## Respaldo

Se generó un respaldo SQL mediante pg_dump.

- Archivo: dw_20261111_183556.sql
- Tamaño aproximado: 454 KB
- Algoritmo de verificación: SHA-256
- Resultado: respaldo generado correctamente

## Restauración

Se verificó el checksum y se restauró el respaldo en una base de datos independiente.

La restauración terminó sin errores.

## Validación de registros

| Base de datos | Total de vuelos |
|---|---:|
| pruebas_sgbd | 10000 |
| dw_restauracion | 10000 |

## Conclusión

Las pruebas demostraron que fue posible generar un respaldo, verificar su integridad y restaurar los datos en una base independiente.

La validación confirmó que ambas bases contenían 10000 registros de vuelos.

Esta prueba corresponde al entorno de desarrollo. El procedimiento deberá repetirse con el Data Warehouse definitivo durante la integración.
