
# Matriz de selección de SGBD

## 1. Objetivo

Evaluar las tecnologías de almacenamiento y procesamiento de datos utilizadas en el proyecto de aeropuerto y aerolínea regional, considerando las necesidades del negocio y las mediciones realizadas.

## 2. Tecnologías utilizadas

- PostgreSQL: almacenamiento relacional de vuelos, aeronaves, rutas y tripulación, además del Data Warehouse.
- MongoDB: almacenamiento de reservas y pasajeros mediante documentos anidados.
- Kafka: transmisión de eventos de vuelos en tiempo real.

Kafka funciona como plataforma de eventos y no sustituye directamente a PostgreSQL o MongoDB.

## 3. Criterios de evaluación

| Criterio | Peso |
|---|---:|
| Rendimiento | 30% |
| Facilidad de integración | 25% |
| Escalabilidad | 20% |
| Seguridad | 15% |
| Facilidad de administración | 10% |
| **Total** | **100%** |

La evaluación utilizará una escala de 1 a 5, donde 1 representa un cumplimiento bajo y 5 un cumplimiento alto.

La puntuación ponderada se calculará multiplicando cada calificación por el peso correspondiente.

## 4. Mediciones realizadas

Las pruebas se ejecutaron en contenedores Docker utilizando datos sintéticos.

### PostgreSQL 16

Se insertaron 10000 registros de vuelos.

| Consulta | Tiempo |
|---|---:|
| Agrupación por origen | 10.721 ms |
| Filtro de retrasos mayores a 30 minutos | 2.320 ms |

### MongoDB 7

Se insertaron 10000 documentos sintéticos.

| Consulta | Tiempo registrado |
|---|---:|
| Agrupación por origen | 89 ms |
| Filtro de retrasos mayores a 30 minutos | 15 ms |

El tiempo de agrupación corresponde al cursor y no necesariamente a toda la operación.

### Apache Kafka 3.8.0

Se publicaron 10000 eventos sintéticos.

| Medida | Resultado |
|---|---:|
| Tiempo total | 3.318 segundos |
| Rendimiento | 3013.56 eventos por segundo |


## 5. Matriz ponderada

La evaluación utiliza una escala de 1 a 5:

- 1: Cumplimiento muy bajo.
- 2: Cumplimiento bajo.
- 3: Cumplimiento aceptable.
- 4: Cumplimiento bueno.
- 5: Cumplimiento muy bueno.

Las calificaciones consideran la utilidad de cada tecnología para la función asignada dentro del proyecto.

| Criterio | Peso | PostgreSQL | MongoDB | Kafka |
|---|---:|---:|---:|---:|
| Rendimiento | 30% | 4 | 4 | 4 |
| Facilidad de integración | 25% | 5 | 4 | 4 |
| Escalabilidad | 20% | 3 | 4 | 5 |
| Seguridad | 15% | 4 | 4 | 3 |
| Facilidad de administración | 10% | 4 | 4 | 3 |
| **Resultado ponderado** | **100%** | **4.05** | **4.00** | **3.95** |

### 5.1. Justificación de las calificaciones

**PostgreSQL**

Se utiliza para almacenar datos relacionales y construir el Data Warehouse. En las pruebas se ejecutaron correctamente dos consultas sobre 10000 registros, con tiempos de 10.721 ms y 2.320 ms.

Su estructura relacional facilita la definición de relaciones, restricciones y consultas SQL.

**MongoDB**

Se utiliza para almacenar reservas y pasajeros en documentos anidados. Durante las pruebas procesó 10000 documentos y ejecutó correctamente las consultas de agrupación y filtrado.

Su modelo de documentos resulta adecuado para representar reservas con información relacionada.

**Kafka**

Se utiliza para transmitir eventos de despegues, aterrizajes y retrasos. La prueba registró 10000 eventos en 3.318 segundos, con un rendimiento de 3013.56 eventos por segundo.

Su funcionamiento permite separar la generación de eventos de su consumo posterior.

### 5.2. Alcance de la evaluación

Las calificaciones son una valoración técnica inicial y no representan resultados medidos para todos los criterios.

El rendimiento cuenta con pruebas propias. La escalabilidad, seguridad, integración y administración se valoraron de forma preliminar según las características y funciones previstas de cada tecnología.

Los resultados ponderados no significan que PostgreSQL pueda sustituir a MongoDB o Kafka, ya que cada tecnología cumple una función diferente.

Las calificaciones podrán ajustarse cuando se completen las pruebas de integración y seguridad del proyecto.

## 6. Interpretación inicial

PostgreSQL permitió ejecutar consultas relacionales y de agrupación sobre los datos sintéticos.

MongoDB permitió realizar consultas sobre documentos, utilizando una colección independiente de pruebas.

Kafka permitió publicar y confirmar eventos de vuelos en tiempo real.

Cada tecnología cumple una función diferente dentro de la plataforma de datos.

## 7. Limitaciones

- Las mediciones corresponden a una ejecución inicial.
- No se realizaron pruebas de escalabilidad.
- Los tiempos internos de PostgreSQL y MongoDB no son directamente equivalentes.
- La medición de Kafka no incluye el consumo ni el procesamiento posterior de los eventos.
- Las calificaciones ponderadas todavía deben justificarse con evidencia.

## 8. Conclusión

PostgreSQL, MongoDB y Kafka se utilizan para resolver necesidades distintas del proyecto.

La conclusión definitiva se establecerá después de completar la matriz ponderada y analizar las mediciones y características de cada tecnología.
