
-- OLAP 1: ROLLUP por año, mes y ruta

SELECT
    CASE WHEN GROUPING(f.anio) = 1 THEN 'TOTAL' ELSE f.anio::TEXT END AS anio,
    CASE WHEN GROUPING(f.mes) = 1 THEN 'TOTAL' ELSE f.mes::TEXT END AS mes,
    CASE WHEN GROUPING(r.codigo_ruta) = 1
        THEN 'TOTAL'
        ELSE r.codigo_ruta
    END AS ruta,
    SUM(v.cantidad_vuelos) AS total_vuelos,
    SUM(v.pasajeros) AS total_pasajeros,
    SUM(v.retraso_minutos) AS retraso_acumulado
FROM dw.fact_vuelos v
JOIN dw.dim_fecha f ON v.fecha_key = f.fecha_key
JOIN dw.dim_ruta r ON v.ruta_key = r.ruta_key
GROUP BY ROLLUP(f.anio, f.mes, r.codigo_ruta)
ORDER BY f.anio NULLS LAST, f.mes NULLS LAST, r.codigo_ruta NULLS LAST;

-- OLAP 2: CUBE por ruta y clima

SELECT
    CASE WHEN GROUPING(r.codigo_ruta) = 1
        THEN 'TOTAL'
        ELSE r.codigo_ruta
    END AS ruta,
    CASE WHEN GROUPING(c.condicion) = 1
        THEN 'TOTAL'
        ELSE c.condicion
    END AS clima,
    SUM(v.cantidad_vuelos) AS total_vuelos,
    ROUND(AVG(v.retraso_minutos), 2) AS retraso_promedio,
    SUM(v.pasajeros) AS total_pasajeros
FROM dw.fact_vuelos v
JOIN dw.dim_ruta r ON v.ruta_key = r.ruta_key
JOIN dw.dim_clima c ON v.clima_key = c.clima_key
GROUP BY CUBE(r.codigo_ruta, c.condicion)
ORDER BY r.codigo_ruta NULLS LAST, c.condicion NULLS LAST;

-- Vista materializada: resumen mensual por ruta

CREATE MATERIALIZED VIEW IF NOT EXISTS dw.mv_resumen_vuelos AS
SELECT
    f.anio,
    f.mes,
    r.codigo_ruta,
    SUM(v.cantidad_vuelos)::BIGINT AS total_vuelos,
    SUM(v.pasajeros)::BIGINT AS total_pasajeros,
    SUM(v.capacidad)::BIGINT AS capacidad_total,
    SUM(v.retraso_minutos)::BIGINT AS retraso_acumulado,
    ROUND(
        SUM(v.retraso_minutos)::NUMERIC /
        NULLIF(SUM(v.cantidad_vuelos), 0),
        2
    ) AS retraso_promedio,
    ROUND(
        100.0 * SUM(v.pasajeros) /
        NULLIF(SUM(v.capacidad), 0),
        2
    ) AS ocupacion_porcentaje
FROM dw.fact_vuelos v
JOIN dw.dim_fecha f ON v.fecha_key = f.fecha_key
JOIN dw.dim_ruta r ON v.ruta_key = r.ruta_key
GROUP BY f.anio, f.mes, r.codigo_ruta;

CREATE UNIQUE INDEX IF NOT EXISTS idx_mv_resumen_vuelos
ON dw.mv_resumen_vuelos(anio, mes, codigo_ruta);

REFRESH MATERIALIZED VIEW dw.mv_resumen_vuelos;

SELECT *
FROM dw.mv_resumen_vuelos
ORDER BY anio, mes, codigo_ruta;
