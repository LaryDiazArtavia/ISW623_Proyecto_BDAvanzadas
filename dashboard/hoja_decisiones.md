
# Hoja de decisiones - Aerolínea Regional

## Objetivo

Analizar los resultados del dashboard para identificar posibles mejoras en la puntualidad, la ocupación y la planificación de los vuelos de la aerolínea regional.

## Hallazgo 1. Retrasos por ruta y horario

El dashboard muestra diferencias en los minutos acumulados de retraso entre las cinco rutas analizadas.

También se identificaron horarios con una mayor acumulación de retrasos, especialmente alrededor de las 10:00 y las 18:00.

**Acción recomendada:**

Revisar la programación de los vuelos en los horarios con mayores retrasos y evaluar ajustes en los tiempos de salida y en la disponibilidad de aeronaves y tripulación.

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
