
INSERT INTO dw.dim_fecha (
    fecha, anio, trimestre, mes, dia, dia_semana
)
SELECT DISTINCT
    fecha,
    EXTRACT(YEAR FROM fecha)::INTEGER,
    EXTRACT(QUARTER FROM fecha)::INTEGER,
    EXTRACT(MONTH FROM fecha)::INTEGER,
    EXTRACT(DAY FROM fecha)::INTEGER,
    EXTRACT(ISODOW FROM fecha)::INTEGER
FROM dashboard_pruebas.vuelos
ON CONFLICT (fecha) DO NOTHING;

INSERT INTO dw.dim_ruta (
    codigo_ruta, origen, destino
)
SELECT DISTINCT
    ruta,
    TRIM(SPLIT_PART(ruta, ' - ', 1)),
    TRIM(SPLIT_PART(ruta, ' - ', 2))
FROM dashboard_pruebas.vuelos
ON CONFLICT (codigo_ruta) DO NOTHING;

INSERT INTO dw.dim_aeronave (
    codigo_aeronave, tipo_aeronave, capacidad
)
SELECT DISTINCT
    'TIPO-' || capacidad,
    'Aeronave regional',
    capacidad
FROM dashboard_pruebas.vuelos
ON CONFLICT (codigo_aeronave) DO NOTHING;

INSERT INTO dw.dim_clima (condicion)
SELECT DISTINCT clima
FROM dashboard_pruebas.vuelos
ON CONFLICT (condicion) DO NOTHING;

INSERT INTO dw.fact_vuelos (
    codigo_vuelo,
    fecha_key,
    ruta_key,
    aeronave_key,
    clima_key,
    pasajeros,
    capacidad,
    retraso_minutos,
    cantidad_vuelos
)
SELECT
    'VUELO-' || v.vuelo_id,
    f.fecha_key,
    r.ruta_key,
    a.aeronave_key,
    c.clima_key,
    v.pasajeros,
    v.capacidad,
    v.retraso_minutos,
    1
FROM dashboard_pruebas.vuelos v
JOIN dw.dim_fecha f ON f.fecha = v.fecha
JOIN dw.dim_ruta r ON r.codigo_ruta = v.ruta
JOIN dw.dim_aeronave a ON a.codigo_aeronave = 'TIPO-' || v.capacidad
JOIN dw.dim_clima c ON c.condicion = v.clima
ON CONFLICT (codigo_vuelo) DO NOTHING;
