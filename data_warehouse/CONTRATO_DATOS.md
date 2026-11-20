
# Contrato de datos — Data Warehouse

## Objetivo

Definir la estructura que deberá utilizar el proceso ETL para cargar los datos de la aerolínea regional desde la zona curated hacia PostgreSQL.

## Esquema de destino

Base de datos: PostgreSQL.

Esquema: `dw`.

Tablas:

- `dw.dim_fecha`
- `dw.dim_ruta`
- `dw.dim_aeronave`
- `dw.dim_clima`
- `dw.fact_vuelos`

## Granularidad

La tabla `dw.fact_vuelos` almacena una fila por operación de vuelo.

- `vuelo_key`: clave sustituta generada por PostgreSQL.
- `id_operacion`: identificador único y obligatorio de cada operación.
- `codigo_vuelo`: código comercial del vuelo; puede repetirse en distintas fechas.
- `hora_salida`: hora de salida de la operación, utilizada para analizar retrasos por horario.

La unicidad de los registros se controla mediante `id_operacion`, no mediante `codigo_vuelo`.

## Campos requeridos desde curated

| Campo | Tipo esperado | Destino |
|---|---|---|
| id_operacion | Texto único y obligatorio | fact_vuelos.id_operacion |
| codigo_vuelo | Texto; admite repeticiones | fact_vuelos.codigo_vuelo |
| hora_salida | TIME | fact_vuelos.hora_salida |
| fecha | DATE | dim_fecha |
| codigo_ruta | Texto | dim_ruta.codigo_ruta |
| origen | Texto | dim_ruta.origen |
| destino | Texto | dim_ruta.destino |
| codigo_aeronave | Texto | dim_aeronave.codigo_aeronave |
| tipo_aeronave | Texto | dim_aeronave.tipo_aeronave |
| capacidad | Entero positivo | dim_aeronave y fact_vuelos |
| clima | Texto | dim_clima.condicion |
| pasajeros | Entero no negativo | fact_vuelos |
| retraso_minutos | Entero no negativo | fact_vuelos |

Los campos deben cumplir las restricciones del esquema SQL.

## Reglas de integración

1. Cargar primero las dimensiones.
2. Buscar las claves sustitutas correspondientes a cada registro.
3. Cargar después la tabla `dw.fact_vuelos`.
4. Evitar duplicados mediante la clave única `id_operacion`. El código comercial `codigo_vuelo` puede repetirse.
5. Validar el total de vuelos y las medidas contra curated.
6. Refrescar `dw.mv_resumen_vuelos` después de completar y validar la carga.

## Idempotencia

La carga de prueba utiliza `ON CONFLICT (id_operacion) DO NOTHING`.

Para la integración definitiva, el ETL deberá definir si los registros existentes se mantienen o actualizan cuando cambien sus medidas. En ambos casos, ejecutar repetidamente la carga no debe producir duplicados.

## Medidas

- `cantidad_vuelos`: siempre vale 1 por operación.
- `pasajeros`: cantidad de pasajeros transportados.
- `capacidad`: asientos disponibles.
- `retraso_minutos`: retraso de la operación.

Las medidas anteriores pueden sumarse por las dimensiones disponibles.

El retraso promedio se calcula como:

`SUM(retraso_minutos) / SUM(cantidad_vuelos)`

La ocupación se calcula como:

`100 * SUM(pasajeros) / SUM(capacidad)`

No se deben sumar promedios ni porcentajes directamente.

## Archivos SQL

- `sql/01_esquema_estrella.sql`: definición de dimensiones y hechos.
- `sql/02_carga_pruebas.sql`: carga sintética independiente utilizada para validación.
- `sql/03_cubo_olap.sql`: consultas ROLLUP, CUBE y vista materializada.
- `sql/04_ajuste_operaciones.sql`: migración del esquema anterior para incorporar el identificador operativo y la hora de salida.

El archivo de carga de pruebas no sustituye al ETL definitivo desde curated.

## Validaciones realizadas

- Cinco tablas creadas correctamente.
- Cuatro dimensiones cargadas.
- 1000 vuelos cargados en la tabla de hechos.
- Segunda ejecución sin inserciones duplicadas.
- Cuadre de 1000 vuelos, 56835 pasajeros y 25985 minutos de retraso.
- Consultas ROLLUP y CUBE ejecutadas correctamente.
- Vista materializada creada y refrescada.
- Totales de la vista materializada coincidentes con la tabla de hechos.

## Pendientes de integración

- Implementar la carga desde Parquet curated.
- Validar la idempotencia con los datos definitivos.
- Integrar el DAG de Airflow.
- Ejecutar la validación completa con las fuentes del grupo.
- Conectar o adaptar el dashboard a los datos definitivos.
- Verificar que los identificadores de operaciones, rutas y aeronaves de las fuentes definitivas coincidan con el contrato de datos.


## Instrucciones para integrar con las fuentes definitivas

Los identificadores utilizados en `02_carga_pruebas.sql`, como
`VUELO-1`, `VL-1` y `TIPO-90`, son sintéticos y corresponden
únicamente al entorno de pruebas de Lary.

Para la integración definitiva:

1. Utilizar `01_esquema_estrella.sql` para crear el esquema DW.
2. Generar `id_operacion` de manera única y estable para cada operación de vuelo.
3. Mantener `codigo_vuelo` como código comercial, permitiendo repeticiones.
4. Conservar la fecha y la hora de salida de cada vuelo.
5. Utilizar identificadores reales del conjunto sintético del grupo para rutas y aeronaves.
6. Cargar dimensiones antes de cargar hechos.
7. Verificar claves foráneas y restricciones de capacidad.
8. Validar los totales contra curated.
9. Refrescar la vista materializada después de validar la carga.

No ejecutar `02_carga_pruebas.sql` durante la integración definitiva.
Este archivo depende de `dashboard_pruebas.vuelos` y se utiliza
únicamente para pruebas independientes.

`04_ajuste_operaciones.sql` es una migración histórica para bases
que utilizaron el diseño anterior; no se necesita en instalaciones
nuevas que ejecuten el esquema actualizado.
