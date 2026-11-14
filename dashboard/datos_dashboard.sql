
CREATE SCHEMA IF NOT EXISTS dashboard_pruebas;

CREATE TABLE IF NOT EXISTS dashboard_pruebas.vuelos (
    vuelo_id INTEGER PRIMARY KEY,
    ruta VARCHAR(100) NOT NULL,
    aeropuerto_origen VARCHAR(100) NOT NULL,
    aeropuerto_destino VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    pasajeros INTEGER NOT NULL,
    capacidad INTEGER NOT NULL,
    retraso_minutos INTEGER NOT NULL,
    clima VARCHAR(30) NOT NULL
);

TRUNCATE TABLE dashboard_pruebas.vuelos;

INSERT INTO dashboard_pruebas.vuelos (
    vuelo_id,
    ruta,
    aeropuerto_origen,
    aeropuerto_destino,
    fecha,
    hora,
    pasajeros,
    capacidad,
    retraso_minutos,
    clima
)
SELECT
    numero,
    CASE numero % 5
        WHEN 0 THEN 'San Jose - Liberia'
        WHEN 1 THEN 'San Jose - Limon'
        WHEN 2 THEN 'San Jose - Quepos'
        WHEN 3 THEN 'Liberia - San Jose'
        ELSE 'Limon - San Jose'
    END,
    CASE numero % 5
        WHEN 0 THEN 'San Jose'
        WHEN 1 THEN 'San Jose'
        WHEN 2 THEN 'San Jose'
        WHEN 3 THEN 'Liberia'
        ELSE 'Limon'
    END,
    CASE numero % 5
        WHEN 0 THEN 'Liberia'
        WHEN 1 THEN 'Limon'
        WHEN 2 THEN 'Quepos'
        ELSE 'San Jose'
    END,
    DATE '2026-01-01' + (numero % 90),
    TIME '06:00' + ((numero % 16) * INTERVAL '1 hour'),
    35 + (numero % 45),
    90,
    CASE
        WHEN numero % 4 = 0 THEN 45 + (numero % 40)
        WHEN numero % 4 = 1 THEN 15 + (numero % 25)
        ELSE numero % 15
    END,
    CASE numero % 4
        WHEN 0 THEN 'Lluvia'
        WHEN 1 THEN 'Nublado'
        WHEN 2 THEN 'Soleado'
        ELSE 'Tormenta'
    END
FROM generate_series(1, 1000) AS numero;
