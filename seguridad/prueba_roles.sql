
CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS dw.vuelos_prueba (
    id INTEGER PRIMARY KEY,
    codigo_vuelo VARCHAR(20) NOT NULL
);

INSERT INTO dw.vuelos_prueba (id, codigo_vuelo)
VALUES (1, 'VL-001')
ON CONFLICT (id) DO NOTHING;

GRANT SELECT ON dw.vuelos_prueba TO rol_analista;

SET ROLE rol_analista;

SELECT * FROM dw.vuelos_prueba;

RESET ROLE;

SELECT
    has_table_privilege(
        'rol_analista',
        'dw.vuelos_prueba',
        'SELECT'
    ) AS puede_consultar,
    has_table_privilege(
        'rol_analista',
        'dw.vuelos_prueba',
        'INSERT'
    ) AS puede_insertar,
    has_table_privilege(
        'rol_analista',
        'dw.vuelos_prueba',
        'UPDATE'
    ) AS puede_actualizar,
    has_table_privilege(
        'rol_analista',
        'dw.vuelos_prueba',
        'DELETE'
    ) AS puede_eliminar;
