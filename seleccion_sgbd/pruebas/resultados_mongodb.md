
# Resultados de rendimiento - MongoDB

## Entorno

- Motor: MongoDB 7
- Ejecución: Docker
- Base de datos: pruebas_sgbd
- Documentos sintéticos: 10000
- Herramienta: explain("executionStats")

## Resultados

| Consulta | Tiempo registrado | Documentos examinados |
|---|---:|---:|
| Agrupación de vuelos por origen | 89 ms | 10000 |
| Vuelos con retraso mayor a 30 minutos | 15 ms | 10000 |

## Observaciones

- La primera consulta agrupó los vuelos en 10 aeropuertos de origen.
- La segunda consulta encontró 4824 documentos con retrasos superiores a 30 minutos.
- Ambas consultas realizaron recorridos completos de la colección.
- No se presentaron errores durante la ejecución.

## Limitaciones

Los resultados corresponden a una ejecución inicial con datos sintéticos.

El tiempo de 89 ms corresponde al cursor de la consulta de agrupación, no necesariamente a toda la operación.

Las mediciones internas de MongoDB y PostgreSQL no son directamente equivalentes, por lo que no permiten determinar todavía cuál motor es más rápido.
