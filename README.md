# 🧥 Análisis de Ventas Mayorista de Ropa
**Primer Trimestre 2022 - Argentina, Brasil y México**  

[![Licencia MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Google BigQuery](https://img.shields.io/badge/Google%20BigQuery-4285F4?logo=googlecloud&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-003B57?logo=postgresql&logoColor=white)

📌 Estructura del Repositorio (GitHub)
🔗 Acceder al repositorio

📊 Resultados Clave

Tabla 1. Comparación Global de Productos
Producto	Unidades	Ingresos (USD)	Participación	Diferencia con Líder (Ventas)	Diferencia con Líder (Ingresos)
Piluso multix	6,541	$98,822.70	20.47%	0.90%	-78.05%
Pack x 3 - Medias infantiles	6,482	$32,143.89	20.29%	1.77%	-92.86%
Zapatos GTV	6,425	$450,417.20	20.11%	0.00% (Líder en ingresos)	0.00%
Blazer fixed	6,359	$321,234.42	19.90%	2.78%	-28.68%
Remera unisex	6,143	$155,815.12	19.23%	6.08%	-65.41%
Total unidades vendidas: 31,950
Total ingresos globales: $1,058,433.33

Tabla 2. Distribución de Ingresos por País
País	Ingresos USD	% del Total
México	$356,441.78	33.68%
Argentina	$353,351.74	33.38%
Brasil	$348,639.79	32.94%
Tabla 3. Estabilidad de Mercados
País	Coeficiente de Variación
Argentina	43.77 (Más estable)
México	51.72
Brasil	53.03

📌 Respuestas a las Preguntas del Ejercicio 2
El archivo scripts/3.Resultados_preguntas.md contiene:

Pregunta 1: Productos más estables por país

## 📈 Análisis de Estabilidad por País

| País      | Producto más estable | Coeficiente de Variación |
|-----------|----------------------|--------------------------|
| Argentina | Blazer fixed         | 0.20%                    |
| Brasil    | Blazer fixed         | 8.29%                    |
| México    | Remera unisex        | 6.49%                    |

**Conclusión**:  
El Blazer fixed muestra la mayor estabilidad, especialmente en Argentina con apenas 0.2% de variación mensual.
Pregunta 2: Diferencias entre países
markdown
## 🌎 Diferencias Geográficas en Consumo

| Producto      | Diferencia Relativa | Ingreso Total USD | Distribución por País               |
|---------------|---------------------|------------------|-------------------------------------|
| Remera unisex | 11.54%              | $155,815.12      | ARG: $48,004.73 • MEX: $53,810.03 • BRA: $54,000.36 |

**Hallazgo clave**:  
Brasil consume un 11.54% más que Argentina en Remera unisex, mostrando las mayores diferencias regionales.
📊 Dashboard Interactivo
🔗 Acceder al Dashboard en Looker Studio

📬 Contacto
✉️ fsaldico@gmail.com
🔗 Repositorio GitHub

Nota: Los scripts SQL de análisis se encuentran en:

1.Limpieza_Datos_Ejercicio1.sql

2.Analisis_Ventas_Ejercicio2.sql

