# Política de retención de datos

## 1. Objetivo

Establecer medidas para conservar, proteger y eliminar de forma segura los datos utilizados en el proyecto de aeropuerto y aerolínea regional, evitando almacenar información durante más tiempo del necesario.

## 2. Datos utilizados

El proyecto trabaja con información de vuelos, rutas, aeronaves, tripulación, reservas, pasajeros y condiciones meteorológicas.

Los nombres y números de pasaporte de los pasajeros se consideran datos personales y requieren medidas especiales de protección.

## 3. Conservación de datos

Los siguientes períodos se establecen como política interna para los datos sintéticos utilizados en el proyecto académico.

| Tipo de información | Período de conservación |
|---|---|
| Datos operativos de vuelos y rutas | Hasta finalizar la evaluación del proyecto |
| Reservas y datos personales sintéticos | Hasta finalizar las pruebas y la evaluación |
| Datos de la zona raw | 30 días |
| Datos de las zonas curated y rejected | 60 días |
| Respaldos de las bases de datos | 30 días |
| Archivos temporales de procesamiento | 7 días |

Los períodos propuestos podrán ajustarse según las necesidades de validación y los requisitos de la evaluación académica.

## 4. Eliminación de datos

Cuando se cumpla el período de conservación:

- Se eliminarán los archivos temporales y los datos que ya no sean necesarios.
- Se revisarán y eliminarán los respaldos que hayan superado su período de conservación.
- Se evitará mantener copias innecesarias de información personal.
- Se comprobará que la eliminación no afecte los procesos de restauración o las evidencias necesarias para la evaluación.
- Se registrarán las eliminaciones realizadas cuando corresponda.

## 5. Protección de datos personales

El acceso a nombres y pasaportes estará restringido mediante roles y permisos.

En MongoDB se utilizará una vista de consulta que oculte estos datos personales. Los usuarios destinados al análisis tendrán acceso únicamente a la información autorizada.

El dashboard mostrará información agrupada sobre vuelos, rutas, retrasos, ocupación y condiciones meteorológicas, sin exponer nombres ni pasaportes.

## 6. Aplicación y revisión de la política

Los períodos de conservación se revisarán cuando cambien las fuentes de datos, los procesos de almacenamiento o los requisitos de seguridad.

La eliminación de los datos deberá ejecutarse de manera controlada y verificarse durante la operación del sistema.

Esta política define los períodos y procedimientos propuestos. Su aplicación automática o manual deberá comprobarse durante la integración final del proyecto.