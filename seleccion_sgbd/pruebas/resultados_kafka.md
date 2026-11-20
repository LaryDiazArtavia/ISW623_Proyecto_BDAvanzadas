
# Resultados de rendimiento - Kafka

## Entorno

- Motor: Apache Kafka 3.8.0
- Ejecución: Docker
- Puerto: 9093
- Tópico: pruebas_eventos_vuelos
- Librería: kafka-python 3.0.13
- Eventos sintéticos: 10000

## Resultados

| Medida | Resultado |
|---|---:|
| Eventos enviados y confirmados | 10000 |
| Tiempo total | 3.318 segundos |
| Eventos por segundo | 3013.56 |

## Observaciones

- Se publicaron 10000 eventos sintéticos de vuelos.
- Los eventos representaron despegues, aterrizajes y retrasos.
- El productor recibió confirmación de los envíos.
- La prueba terminó sin errores.

## Verificación del tópico

Se verificó el tópico `pruebas_eventos_vuelos` mediante las herramientas de administración de Kafka.

| Elemento | Resultado |
|---|---|
| Particiones | 1 |
| Factor de replicación | 1 |
| Líder | Broker 1 |
| Réplicas sincronizadas | 1 |
| Offset final | 10000 |

El offset final coincide con la cantidad de eventos publicados durante la prueba.

Esta verificación confirma la posición final del registro, pero no sustituye una prueba de consumo de mensajes.

## Limitaciones

La medición corresponde a una sola ejecución y evalúa únicamente la publicación de eventos.

No incluye el consumo de los eventos ni su procesamiento mediante NiFi.

Para evaluar el rendimiento con mayor precisión, es necesario repetir la prueba y considerar la configuración del productor y del servidor.
