CREATE SCHEMA IF NOT EXISTS pruebas_sgbd;

CREATE TABLE IF NOT EXISTS pruebas_sgbd.vuelos (
    id SERIAL PRIMARY KEY,
    codigo_vuelo VARCHAR(20) NOT NULL,
    origen VARCHAR(50) NOT NULL,
    destino VARCHAR(50) NOT NULL,
    pasajeros INTEGER NOT NULL,
    retraso_minutos INTEGER NOT NULL
);

TRUNCATE TABLE pruebas_sgbd.vuelos RESTART IDENTITY;

INSERT INTO pruebas_sgbd.vuelos (
    codigo_vuelo,
    origen,
    destino,
    pasajeros,
    retraso_minutos
)
SELECT
    'VL-' || numero,
    'Aeropuerto ' || (numero % 10),
    'Aeropuerto ' || ((numero + 3) % 10),
    20 + (numero % 100),
    numero % 60
FROM generate_series(1, 10000) AS numero;

ANALYZE pruebas_sgbd.vuelos;

EXPLAIN (ANALYZE, BUFFERS)
SELECT origen, COUNT(*) AS total_vuelos
FROM pruebas_sgbd.vuelos
GROUP BY origen;

EXPLAIN (ANALYZE, BUFFERS)
SELECT *
FROM pruebas_sgbd.vuelos
WHERE retraso_minutos > 30;
