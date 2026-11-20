# ISW623_Proyecto_BDAvanzadas

## Descripción

Proyecto Final del curso ISW-623 Base de Datos Avanzadas de la Universidad Técnica Nacional, Sede San Carlos.

El proyecto desarrolla una plataforma de datos para una aerolínea regional, integrando diferentes fuentes de información, procesamiento de datos, análisis y visualización para apoyar decisiones operativas.

## Tecnologías utilizadas

- PostgreSQL 16
- MongoDB 7
- Apache Kafka 3.8.0
- Metabase 0.50.26
- Docker y Docker Compose
- Python

La plataforma completa también contempla Apache NiFi, MinIO y Apache Airflow.

## Estructura actual

### seleccion_sgbd/

Contiene las pruebas de rendimiento de PostgreSQL, MongoDB y Kafka, sus resultados y la matriz ponderada de selección.

El archivo `seleccion_sgbd/pruebas/docker-compose.portable.yml` permite preparar un entorno independiente para realizar pruebas.

### seguridad/

Contiene la clasificación de datos, la política de retención, los roles y permisos, las pruebas de enmascarado de pasajeros y los procedimientos de respaldo y restauración.

### dashboard/

Contiene:

- `datos_dashboard.sql`: creación de datos sintéticos para las visualizaciones.
- `hoja_decisiones.md`: hallazgos, recomendaciones y limitaciones.
- `exportacion/`: configuración JSON del dashboard y sus cinco preguntas.
- `restaurar_metabase.py`: script para reconstruir las preguntas y el dashboard mediante la API de Metabase.
- `docker-compose.metabase-final-test.yml`: configuración utilizada para probar la restauración desde cero.

## Dashboard de operaciones

El dashboard incluye cinco visualizaciones:

1. Retrasos acumulados por ruta.
2. Retrasos acumulados por hora.
3. Ocupación promedio por ruta.
4. Retraso promedio según el clima.
5. Cantidad de vuelos por ruta.

Dispone de dos filtros: Ruta y Fecha.

Las visualizaciones fueron desarrolladas utilizando 1000 vuelos sintéticos almacenados en PostgreSQL.

## Restauración de Metabase

El procedimiento de restauración se probó con Metabase 0.50.26.

Requisitos:

- Una instalación de Metabase configurada.
- Una conexión PostgreSQL con el nombre `Aerolínea Regional`.
- La tabla `dashboard_pruebas.vuelos` disponible.
- Los seis archivos JSON de `dashboard/exportacion/`.

Desde la raíz del repositorio:

```powershell
python .\dashboard\restaurar_metabase.py --url http://localhost:3003
```

El script solicita las credenciales del Metabase de destino y detecta los identificadores de la base de datos, tabla y campos.

La prueba de restauración desde cero permitió reconstruir los cinco gráficos y ambos filtros.

El script está restringido a instalaciones locales y protege el puerto 3001, utilizado durante el desarrollo para el dashboard original.

El puerto 3003 es un ejemplo de prueba; para otro entorno local debe utilizarse el puerto correspondiente.

## Seguridad

Se implementaron y probaron:

- Roles y permisos con mínimo privilegio en PostgreSQL.
- Restricción de modificaciones para usuarios de consulta.
- Enmascarado de nombres y pasaportes en MongoDB.
- Restricciones de acceso a información personal.
- Respaldo y restauración de PostgreSQL con comprobación mediante checksum.

También se documentaron la clasificación de datos, las consideraciones de la Ley N.º 8968 de Costa Rica y la política de retención.


## Estado del proyecto

### Componentes desarrollados por Lary

- Selección de SGBD mediante matriz ponderada y pruebas de rendimiento.
- Seguridad en PostgreSQL y MongoDB, incluyendo roles, permisos y enmascarado.
- Respaldo y restauración de PostgreSQL con verificación SHA-256.
- Clasificación de datos, Ley N.º 8968 y política de retención.
- Dashboard de Metabase con cinco gráficos, dos filtros y hoja de decisiones.
- Data Warehouse dimensional con cuatro dimensiones y una tabla de hechos.
- Identificador único de operación y hora de salida de vuelos.
- Carga de prueba idempotente con 1000 vuelos sintéticos.
- Consultas OLAP mediante ROLLUP y CUBE.
- Vista materializada con totales validados.
- Contrato de datos para la integración posterior.

### Componentes pendientes de Kristel

- Generador de datos sintéticos y cuatro fuentes de información.
- Ingesta mediante NiFi hacia MinIO.
- Procesamiento de calidad con al menos seis reglas.
- Generación de datos curated en Parquet y registros rejected.
- ETL definitivo desde curated hacia el Data Warehouse.
- DAG de Airflow con cuatro tareas.
- Docker Compose integrado e instrucciones de ejecución desde cero.

### Pendientes de integración conjunta

- Validar el Data Warehouse con los datos definitivos.
- Adaptar el dashboard a las fuentes integradas.
- Comprobar la ejecución completa desde cero.
- Consolidar el informe técnico y preparar la demostración.

Los componentes de Lary se probaron de forma independiente con datos sintéticos. Estas pruebas no sustituyen la validación completa de la plataforma integrada.


## Documentación final

La entrega final incorporará las instrucciones completas para levantar el entorno integrado, las evidencias de ejecución, el informe técnico, la hoja de decisiones y los materiales de demostración.

## Data Warehouse y OLAP

Se implementó un esquema estrella en PostgreSQL dentro del esquema `dw`.

Componentes:
- `dim_fecha`: dimensión temporal.
- `dim_ruta`: origen y destino.
- `dim_aeronave`: aeronave y capacidad.
- `dim_clima`: condiciones meteorológicas.
- `fact_vuelos`: tabla de hechos con las medidas operativas.

Archivos:
- `data_warehouse/sql/01_esquema_estrella.sql`: creación de tablas e índices.
- `data_warehouse/sql/02_carga_pruebas.sql`: carga de datos sintéticos.
- `data_warehouse/sql/03_cubo_olap.sql`: consultas ROLLUP, CUBE y vista materializada.
- `data_warehouse/sql/04_ajuste_operaciones.sql`: migración del esquema anterior para incorporar identificador operativo y hora de salida.
- `data_warehouse/CONTRATO_DATOS.md`: especificación para la integración del ETL.

Validaciones realizadas:
- 1000 vuelos cargados correctamente.
- Carga de prueba idempotente.
- Cuadre de 56835 pasajeros y 25985 minutos de retraso.
- ROLLUP y CUBE ejecutados.
- Vista materializada creada y validada.

La carga desde curated y la integración con Airflow siguen pendientes.
