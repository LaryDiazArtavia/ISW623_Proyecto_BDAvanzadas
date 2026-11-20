
# Hoja de decisiones - Aerolínea Regional

## Objetivo

Analizar los resultados del dashboard para identificar posibles mejoras en la puntualidad, la ocupación y la planificación de los vuelos de la aerolínea regional.


## Hallazgo 1. Retrasos por ruta y horario

La ruta San José - Limón registró la mayor acumulación de retrasos, con 5455 minutos, seguida de San José - Quepos, con 5400 minutos.

En cuanto a los horarios, las 10:00 presentaron la mayor acumulación de retrasos, con 4095 minutos, seguidas de las 18:00, con 4030 minutos.

Estos resultados permiten identificar las rutas y los horarios que requieren mayor atención operativa.

**Acción recomendada:**

Revisar la programación de vuelos en las rutas y horarios con mayores retrasos, evaluar ajustes en los tiempos de salida y mejorar la disponibilidad de aeronaves y tripulación.

**Limitación:**

Los resultados corresponden a datos sintéticos. Los retrasos acumulados también dependen de la cantidad de vuelos, por lo que deben analizarse junto con los promedios antes de tomar decisiones definitivas.


## Hallazgo 2. Ocupación de las rutas

La ruta Limón - San José presentó la mayor ocupación promedio, con un 65.36%.

Por otra parte, San José - Liberia registró la menor ocupación, con un 60.97%.

**Acción recomendada:**

Analizar la demanda de pasajeros por ruta antes de modificar la frecuencia de los vuelos. También se podría evaluar el uso de aeronaves con capacidades diferentes para aprovechar mejor los asientos disponibles.

## Hallazgo 3. Relación entre clima y retrasos

En los datos analizados, los vuelos registrados con lluvia presentaron un retraso promedio de 63 minutos.

Los vuelos con condiciones soleadas registraron un retraso promedio de 6.98 minutos.

**Acción recomendada:**

Considerar las condiciones meteorológicas durante la planificación de vuelos y establecer medidas preventivas para las operaciones que puedan verse afectadas por lluvias intensas.

## Limitaciones del análisis

- Los resultados provienen de 1000 vuelos sintéticos creados para desarrollar y probar el dashboard.
- Las condiciones meteorológicas y los retrasos fueron generados mediante reglas artificiales, por lo que no demuestran una relación causal real.
- El análisis no utiliza todavía los datos integrados del Data Warehouse definitivo.
- No se incluyen costos operativos ni información histórica real de la aerolínea.
- Las recomendaciones deben validarse nuevamente cuando se disponga de los datos definitivos.

## Conclusión

El dashboard permite comparar los retrasos, la ocupación y las condiciones meteorológicas de las rutas.

Los resultados muestran cómo estas visualizaciones pueden apoyar decisiones relacionadas con la programación de vuelos, el aprovechamiento de aeronaves y la planificación operativa.

Los hallazgos actuales son preliminares y deberán revisarse durante la integración final del proyecto.
