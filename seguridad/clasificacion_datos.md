
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

Para proteger la información se implementaron y probaron las siguientes medidas:

- Configuración de roles y permisos en PostgreSQL aplicando el principio de mínimo privilegio.
- Restricción de modificaciones para los usuarios de consulta.
- Enmascarado de nombres y números de pasaporte mediante una vista protegida en MongoDB.
- Restricción del acceso a los datos personales originales según el rol del usuario.
- Utilización de datos sintéticos durante las pruebas.
- Ejecución de pruebas de respaldo y restauración con comprobación mediante checksum.

Adicionalmente, se establece como medida de seguridad evitar la publicación de contraseñas y credenciales en el repositorio Git.

## 4. Ley N.º 8968

La Ley N.º 8968 de Costa Rica protege a las personas frente al tratamiento de sus datos personales.

En este proyecto se considera importante proteger el nombre y el pasaporte de los pasajeros, ya que permiten identificar a una persona.

Para respetar esta normativa, se limitará el acceso a la información personal y se utilizarán datos sintéticos.

## 5. Aplicación en el proyecto

La información personal de los pasajeros estará almacenada en la fuente semiestructurada.

Los datos utilizados en el dashboard serán principalmente datos operativos y resultados agrupados, como cantidad de vuelos, retrasos y ocupación.

De esta forma, será posible analizar las operaciones de la aerolínea sin mostrar información personal de sus pasajeros.
