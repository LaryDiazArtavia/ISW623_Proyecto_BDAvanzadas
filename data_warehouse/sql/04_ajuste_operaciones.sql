
BEGIN;

ALTER TABLE dw.fact_vuelos
ADD COLUMN IF NOT EXISTS id_operacion VARCHAR(80);

ALTER TABLE dw.fact_vuelos
ADD COLUMN IF NOT EXISTS hora_salida TIME;

UPDATE dw.fact_vuelos f
SET
    id_operacion = 'VUELO-' || v.vuelo_id,
    hora_salida = v.hora
FROM dashboard_pruebas.vuelos v
WHERE f.codigo_vuelo = 'VUELO-' || v.vuelo_id
  AND (f.id_operacion IS NULL OR f.hora_salida IS NULL);

ALTER TABLE dw.fact_vuelos
ALTER COLUMN id_operacion SET NOT NULL;

ALTER TABLE dw.fact_vuelos
ALTER COLUMN hora_salida SET NOT NULL;

ALTER TABLE dw.fact_vuelos
DROP CONSTRAINT IF EXISTS fact_vuelos_codigo_vuelo_key;

CREATE UNIQUE INDEX IF NOT EXISTS idx_fact_vuelos_operacion
ON dw.fact_vuelos(id_operacion);

COMMIT;
