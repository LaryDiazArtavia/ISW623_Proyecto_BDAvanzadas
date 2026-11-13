
# Resultados de rendimiento - PostgreSQL

## Entorno

- Motor: PostgreSQL 16
- Ejecución: Docker
- Base de datos: pruebas_sgbd
- Registros sintéticos: 10000
- Herramienta: EXPLAIN (ANALYZE, BUFFERS)

## Resultados

| Consulta | Tiempo de planificación | Tiempo de ejecución |
|---|---:|---:|
| Agrupación de vuelos por origen | 2.439 ms | 10.721 ms |
| Vuelos con retraso mayor a 30 minutos | 0.420 ms | 2.320 ms |

## Observaciones

- La primera consulta agrupó los registros en 10 aeropuertos de origen.
- La segunda consulta encontró 4824 vuelos con retrasos superiores a 30 minutos.
- Las consultas utilizaron lectura secuencial de la tabla.
- No se presentaron errores durante la ejecución.

## Limitaciones

Los resultados corresponden a una ejecución inicial con datos sintéticos. Se necesitarán mediciones repetidas y condiciones comparables para obtener conclusiones más representativas.
