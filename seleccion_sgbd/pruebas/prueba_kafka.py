import json
import os
import time

from kafka import KafkaProducer

SERVIDOR = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
TOPICO = "pruebas_eventos_vuelos"
TOTAL_EVENTOS = 10000

productor = KafkaProducer(
    bootstrap_servers=SERVIDOR,
    value_serializer=lambda dato: json.dumps(dato).encode("utf-8")
)

inicio = time.perf_counter()

confirmaciones = []

for i in range(1, TOTAL_EVENTOS + 1):
    evento = {
        "vuelo_id": i,
        "tipo_evento": ["despegue", "aterrizaje", "retraso"][i % 3],
        "retraso_minutos": i % 60
    }

    confirmaciones.append(
        productor.send(TOPICO, value=evento)
    )

for confirmacion in confirmaciones:
    confirmacion.get(timeout=30)

productor.flush()

duracion = time.perf_counter() - inicio
productor.close()

print(f"Eventos enviados: {TOTAL_EVENTOS}")
print(f"Tiempo total: {duracion:.3f} segundos")
print(f"Eventos por segundo: {TOTAL_EVENTOS / duracion:.2f}")
