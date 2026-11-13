
# Clasificación y protección de datos

## 1. Descripción

El proyecto de aeropuerto y aerolínea regional utiliza datos de vuelos, aeronaves, rutas, tripulación, reservas y pasajeros.

Es necesario identificar qué información debe protegerse para evitar accesos no autorizados.

## 2. Clasificación de los datos

| Datos | Clasificación | Protección |
|---|---|---|
| Nombre del pasajero | Personal, acceso restringido | Ocultar en consultas públicas |
| Número de pasaporte | Personal, acceso restringido | Enmascarar y limitar el acceso |
| Reservas de pasajeros | Confidencial | Acceso según el rol |
| Información de vuelos | Operativa | Acceso controlado |
| Rutas y aeronaves | Operativa | Acceso controlado |
| Condiciones meteorológicas | Operativa | Consulta para análisis |

## 3. Medidas de seguridad

Para proteger la información se aplicarán las siguientes medidas:

- Crear usuarios con permisos según sus funciones.
- Evitar que los usuarios de consulta puedan modificar los datos.
- Enmascarar los números de pasaporte.
- Ocultar los nombres de pasajeros en los reportes públicos.
- Utilizar información sintética durante el desarrollo.
- Evitar publicar contraseñas y credenciales en GitHub.

## 4. Ley N.º 8968

La Ley N.º 8968 de Costa Rica protege a las personas frente al tratamiento de sus datos personales.

En este proyecto se considera importante proteger el nombre y el pasaporte de los pasajeros, ya que permiten identificar a una persona.

Para respetar esta normativa, se limitará el acceso a la información personal y se utilizarán datos sintéticos.

## 5. Aplicación en el proyecto

La información personal de los pasajeros estará almacenada en la fuente semiestructurada.

Los datos utilizados en el dashboard serán principalmente datos operativos y resultados agrupados, como cantidad de vuelos, retrasos y ocupación.

De esta forma, será posible analizar las operaciones de la aerolínea sin mostrar información personal de sus pasajeros.
