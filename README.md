🧥 Análisis de Ventas - Monks Challenge
Primer Trimestre 2022 en Argentina, Brasil y México

📌 Visión General
Análisis de datos de ventas utilizando:

BigQuery para procesamiento (SQL)

Looker Studio para visualización

GitHub para control de versiones

https://img.shields.io/badge/Licencia-MIT-blue.svg
https://img.shields.io/badge/GitHub-Repositorio-black

🔧 Detalle Técnico del Pipeline
1. Limpieza de Datos (1.Limpieza_Datos_Ejercicio1.sql)

Objetivo: Transformación de datos brutos en la creacion de tabla analizable (VENTAS_LIMPIA).

Se obtendra:
*Consistencia en formatos
*Integridad de valores
*Rango temporal correcto (Q1 2022)

Dataset inicial: 6,000 registros brutos
Registros eliminados: 246 (4.1% del total)

Procedimiento:
🛠 Procesos Clave Implementados. Aplicamos 8 filtros para:
1.-- Generar UUID para IDs nulos, convertir a STRING
2.-- Asignar fecha por defecto si es nula y convertir a DATE
3.-- Normalizar países a códigos de 3 letras
4.-- Asegurar que ID_PRODUCTO sea STRING
5.-- Tomar valor absoluto de la cantidad (eliminar negativos)
6.-- Filtrar registros sin precio
7.-- Filtrar por período de interés (primer trimestre 2022)
8.-- Excluir cantidades cero o negativas
( cada codigo alplicado esta incluido en 1.Limpieza_Datos_Ejercicio1.sql )

✅ Verificaciones Automáticas (-- VERIFICACIONES POST-LIMPIEZA-- ). Aplicamos 4 controles de calidad para asegurarnos que los cambios se hallan relizado:

1.-- Conteo de registros.
Resultado:
Fila	métrica	valor
1	1. Total registros	5754

2.-- Rango de fechas.
Resultado:
Fila	metrica	valor
1	2. Rango fechas	2022-01-01 - 2022-03-31

3.-- Distribución por país
Resultado:
Fila	metrica	valor
1	3. Distribución BRA	1913
2	3. Distribución MEX	1922
3	3. Distribución ARG	1919

4.-- Valores numéricos inválidos.
Resultado:
Fila	metrica	valor
1	4. Valores inválidos	0

Al finalizar el proceso quedara creada la tabla VENTAS_LIMPIA, resultado de la depuracion de la tabla ventas_2.

2.🔍  Analisis de ventas desde datos limpios ( 2.Analisis_Ventas_Ejercicio2.sql )

Objetivo: Analizar informaciòn completamente fidelizada, a partir de la cual se pueda extraer informaciòn desde donde se puedan tomar conclusiones para una posterioroptimizacion de recursos. Se obtendran respuestas a la Pregunta 1 y 2 .

Procedimiento:
Se creara la tabla tdc_normalizado, a partir de la Normalización de tipos de cambio; luego, la tabla ingresos_mensuales, a partir del Cálculo de ingresos mensuales en USD; y a partir de esta ultima, productos_estables con coef_variacion y productos_diferencias con diff_entre_paises. 
Con esta información se agruparon los siguientes datos:

📊 Resultados Clave
Tabla 1: Comparación de Productos
Producto	Unidades	Ingresos USD	Participación	Dif. vs Líder Ventas	Dif. vs Líder Ingresos
Piluso multix	6541	$98822,70	20,47%	+0,90%	-78,05%
Pack x 3 Medias	6482	$32143,89	20,29%	+1,77%	-92,86%
Zapatos GTV	6425	$450417,20	20,11%	0,00% (Líder)	0,00%
Blazer fixed	6359	$321234,42	19,90%	+2,78%	-28,68%
Remera unisex	6143	$155815,12	19,23%	+6,08%	-65,41%
Pack x 3 Medias	6482	$32143,89	20,29%	+1,77%	-92,86%
Piluso multix 6541 $98822,70	20,47%	+0,90%	-78,05%
Total general:

31,950 unidades vendidas

$1,058,433.33 en ingresos

Tabla 2: Desempeño por País
País	Ingresos USD	% Total	Estabilidad (Coef.)	Ingreso/Unidad
México	$356,441.78	33.68%	51.72	$24.14
Argentina	$353,351.74	33.38%	43.77	$30.16
Brasil	$348,639.79	32.94%	53.03	$20.06

🔍 Respuestas Técnicas
Pregunta 1: Productos más estables
markdown
| País      | Producto Estable | Variación Mensual |
|-----------|------------------|-------------------|
| Argentina | Blazer fixed     | 0.20% (Mínima)    |
| Brasil    | Blazer fixed     | 8.29%             |
| México    | Remera unisex    | 6.49%             |

Pregunta 2: Diferencias geográficas
markdown
**Remera unisex**:  
- Diferencia máxima: 11.54% (Brasil vs Argentina)  
- Ingreso total: $155,815.12  
- Distribución:  
  - Brasil: $54,000 (34.6%)  
  - México: $53,810  
  - Argentina: $48,005  

🎯 Hallazgos clave:

✅ Argentina es el mercado más estable entre los 3 paises (coeficiente: 43.77) y Blazer fixed es el producto que mantuvo un comportamiento de consumo más regular.  
✅Entre Brasil y Argentina se observó la mayor variacion entre consumos de un mismo producto (Remera unisex) en una medida de un %11,54 entre ambos, siendo que en Brasil se consumieron mas unidades que en Argentina (2132 vs 1908 ) representando un 34,7% y 31,1% respectivamente.

✅ Zapatos GTV genera más ingresos ($450K) pero Piluso multix vende más unidades (6541)

3. Visualizacion de datos a travez de graficos: https://lookerstudio.google.com/s/kt3FSWMyw4Q

📬 Contacto
✉️ fsaldico@gmail.com

Última actualización: 14/07/2025

Notas:
Todos los scripts son ejecutables en BigQuery sin modificaciones.

Para replicar el análisis:
bq query --use_legacy_sql=false < scripts/1.Limpieza_Datos_Ejercicio1.sql
bq query --use_legacy_sql=false < scripts/2.Analisis_Ventas_Ejercicio2.sql
