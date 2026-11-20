
CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS dw.dim_fecha (
    fecha_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    anio INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    dia INTEGER NOT NULL,
    dia_semana INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS dw.dim_ruta (
    ruta_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_ruta VARCHAR(50) NOT NULL UNIQUE,
    origen VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS dw.dim_aeronave (
    aeronave_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_aeronave VARCHAR(50) NOT NULL UNIQUE,
    tipo_aeronave VARCHAR(100) NOT NULL,
    capacidad INTEGER NOT NULL CHECK (capacidad > 0)
);

CREATE TABLE IF NOT EXISTS dw.dim_clima (
    clima_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    condicion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS dw.fact_vuelos (
    vuelo_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_operacion VARCHAR(80) NOT NULL UNIQUE,
    codigo_vuelo VARCHAR(50) NOT NULL,
    fecha_key INTEGER NOT NULL REFERENCES dw.dim_fecha(fecha_key),
    ruta_key INTEGER NOT NULL REFERENCES dw.dim_ruta(ruta_key),
    aeronave_key INTEGER NOT NULL REFERENCES dw.dim_aeronave(aeronave_key),
    clima_key INTEGER NOT NULL REFERENCES dw.dim_clima(clima_key),
    hora_salida TIME NOT NULL,
    pasajeros INTEGER NOT NULL CHECK (pasajeros >= 0),
    capacidad INTEGER NOT NULL CHECK (capacidad > 0),
    retraso_minutos INTEGER NOT NULL CHECK (retraso_minutos >= 0),
    cantidad_vuelos INTEGER NOT NULL DEFAULT 1 CHECK (cantidad_vuelos = 1),
    CHECK (pasajeros <= capacidad)
);

CREATE INDEX IF NOT EXISTS idx_fact_vuelos_fecha
    ON dw.fact_vuelos(fecha_key);

CREATE INDEX IF NOT EXISTS idx_fact_vuelos_ruta
    ON dw.fact_vuelos(ruta_key);

CREATE INDEX IF NOT EXISTS idx_fact_vuelos_aeronave
    ON dw.fact_vuelos(aeronave_key);

CREATE INDEX IF NOT EXISTS idx_fact_vuelos_clima
    ON dw.fact_vuelos(clima_key);
