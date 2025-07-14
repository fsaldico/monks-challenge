# 🧥 Análisis de Ventas - Monks Challenge  
**Primer Trimestre 2022 en Argentina, Brasil y México**

## 📌 Visión General  
Análisis de datos de ventas utilizando:  
- BigQuery para procesamiento (SQL)  
- Looker Studio para visualización  

[![Licencia](https://img.shields.io/badge/Licencia-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
[![GitHub](https://img.shields.io/badge/GitHub-Repositorio-black)](https://github.com/)  

## 🔧 Detalle Técnico del Pipeline  

### 1. Limpieza de Datos (`1.Limpieza_Datos_Ejercicio1.sql`)  
**Objetivo**: Transformación de datos brutos en la creación de tabla analizable (`VENTAS_LIMPIA`).  

**Se obtendrá**:  
- Consistencia en formatos  
- Integridad de valores  
- Rango temporal correcto (Q1 2022)  

**Dataset inicial**: 6,000 registros brutos  
**Registros eliminados**: 246 (4.1% del total)  

#### 🛠 Procesos Clave Implementados  
Aplicamos 8 filtros para:  
1. Generar UUID para IDs nulos, convertir a STRING  
2. Asignar fecha por defecto si es nula y convertir a DATE  
3. Normalizar países a códigos de 3 letras  
4. Asegurar que ID_PRODUCTO sea STRING  
5. Tomar valor absoluto de la cantidad (eliminar negativos)  
6. Filtrar registros sin precio  
7. Filtrar por período de interés (primer trimestre 2022)  
8. Excluir cantidades cero o negativas  
*(cada código aplicado está incluido en `1.Limpieza_Datos_Ejercicio1.sql`)*  

#### ✅ Verificaciones Automáticas (`-- VERIFICACIONES POST-LIMPIEZA --`)  
Aplicamos 4 controles de calidad:  

1. **Conteo de registros**  
Fila métrica valor
1 1. Total registros 5754

2. **Rango de fechas**  
Fila métrica valor
1 2. Rango fechas 2022-01-01 - 2022-03-31

3. **Distribución por país**  
Fila métrica valor
1 3. Distribución BRA 1913
2 3. Distribución MEX 1922
3 3. Distribución ARG 1919

4. **Valores numéricos inválidos**  
Fila métrica valor
1 4. Valores inválidos 0


**Al finalizar**: Se crea la tabla `VENTAS_LIMPIA`, resultado de la depuración de `ventas_2`.

---

### 2. 🔍 Análisis de ventas desde datos limpios (`2.Analisis_Ventas_Ejercicio2.sql`)  
**Objetivo**: Analizar información completamente fidelizada para optimización de recursos.  

**Procedimiento**:  
1. Creación de `tdc_normalizado` (Normalización de tipos de cambio)  
2. Creación de `ingresos_mensuales` (Cálculo de ingresos mensuales en USD)  
3. Creación de `productos_estables` (con `coef_variacion`) y `productos_diferencias` (con `diff_entre_paises`)  

## 📊 Resultados Clave  

### Tabla 1: Comparación de Productos  

| Producto          | Unidades | Ingresos USD   | Participación | Dif. vs Líder Ventas | Dif. vs Líder Ingresos |  
|-------------------|----------|---------------|----------------|----------------------|------------------------|  
| Piluso multix     | 6,541    | $98,822.70    | 20.47%         | +0.90%               | -78.05%                |  
| Pack x 3 Medias   | 6,482    | $32,143.89    | 20.29%         | +1.77%               | -92.86%                |  
| Zapatos GTV       | 6,425    | $450,417.20   | 20.11%         | 0.00% (Líder)        | 0.00%                  |  
| Blazer fixed      | 6,359    | $321,234.42   | 19.90%         | +2.78%               | -28.68%                |  
| Remera unisex     | 6,143    | $155,815.12   | 19.23%         | +6.08%               | -65.41%                |  
| **Total general** | **31,950** | **$1,058,433.33** | - | - | - |  

### Tabla 2: Desempeño por País  

| País      | Ingresos USD   | % Total | Estabilidad (Coef.) | Ingreso/Unidad |  
|-----------|---------------|---------|---------------------|----------------|  
| México    | $356,441.78   | 33.68%  | 51.72               | $24.14         |  
| Argentina | $353,351.74   | 33.38%  | 43.77               | $30.16         |  
| Brasil    | $348,639.79   | 32.94%  | 53.03               | $20.06         |  

---

## 🔍 Respuestas Técnicas  

**Pregunta 1: Productos más estables**  

| País      | Producto Estable | Variación Mensual |  
|-----------|------------------|-------------------|  
| Argentina | Blazer fixed     | 0.20% (Mínima)    |  
| Brasil    | Blazer fixed     | 8.29%             |  
| México    | Remera unisex    | 6.49%             |  

**Pregunta 2: Diferencias geográficas**  

**Remera unisex**:  
- Diferencia máxima: 11.54% (Brasil vs Argentina)  
- Ingreso total: $155,815.12  
- Distribución:  
- Brasil: $54,000 (34.6%)  
- México: $53,810  
- Argentina: $48,005  

---

## 🎯 Hallazgos clave:  

✅ **Argentina** es el mercado más estable (coeficiente: 43.77) y **Blazer fixed** es el producto con comportamiento más regular.  
✅ Mayor variación en **Remera unisex** entre Brasil y Argentina (11.54%), con mayor consumo en Brasil (2132 vs 1908 unidades).  
✅ **Zapatos GTV** genera más ingresos ($450K) pero **Piluso multix** vende más unidades (6541).  

---

## 3. Visualización de datos  
📊 [Ver gráficos en Looker Studio](https://lookerstudio.google.com/s/kt3FSWMyw4Q)  

---

## 📬 Contacto  
✉️ fsaldico@gmail.com  

**Última actualización**: 14/07/2025  

> **Notas**:  
> - Todos los scripts son ejecutables en BigQuery sin modificaciones.  
> - Para replicar el análisis:  
>   ```bash
>   bq query --use_legacy_sql=false < scripts/1.Limpieza_Datos_Ejercicio1.sql  
>   bq query --use_legacy_sql=false < scripts/2.Analisis_Ventas_Ejercicio2.sql  
>   ```
