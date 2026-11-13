
# Resultados de las pruebas de seguridad

## PostgreSQL

Se configuraron los roles `rol_analista` y `rol_etl` bajo el principio de mínimo privilegio.

| Permiso | rol_analista | rol_etl |
|---|---|---|
| SELECT | Permitido | Permitido |
| INSERT | Denegado | Permitido |
| UPDATE | Denegado | Permitido |
| DELETE | Denegado | Denegado |

Las pruebas se realizaron correctamente sobre una tabla independiente.

## MongoDB

Se creó la vista `vista_pasajeros_protegidos` para ocultar los nombres y números de pasaporte de los pasajeros.

También se configuró el rol `rol_consulta_protegida` y el usuario `usuario_consulta`.

### Resultados

- El usuario pudo consultar la vista protegida.
- Los nombres aparecieron como `CONFIDENCIAL`.
- Los pasaportes aparecieron como `********`.
- El acceso directo a la colección `reservas` fue rechazado con `MongoServerError[Unauthorized]`.

## Conclusión

Las pruebas demostraron que los roles configurados permiten restringir operaciones en PostgreSQL y proteger el acceso a los datos personales en MongoDB.

Las validaciones se realizaron en entornos de prueba. Los permisos deberán aplicarse y comprobarse nuevamente cuando se integre la plataforma definitiva.
