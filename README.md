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

Se han desarrollado los módulos de selección de SGBD, seguridad y dashboard utilizando datos sintéticos de prueba.

La plataforma integrada todavía está en desarrollo. Quedan pendientes las fuentes definitivas, la ingesta, la calidad de datos, el Data Warehouse dimensional, la orquestación con Airflow y el cubo OLAP.

La validación de reproducibilidad realizada hasta ahora corresponde al dashboard y a sus componentes de prueba. No constituye todavía una prueba de ejecución completa de la plataforma.

## Documentación final

La entrega final incorporará las instrucciones completas para levantar el entorno integrado, las evidencias de ejecución, el informe técnico, la hoja de decisiones y los materiales de demostración.