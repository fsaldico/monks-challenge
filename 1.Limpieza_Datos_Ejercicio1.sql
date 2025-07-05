/* EJERCICIO 2: ANÁLISIS DE VENTAS */

-- [REQUERIMIENTO PRINCIPAL: Ranking de productos por ingresos USD]
-- 1. Normalización de tipos de cambio
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.tdc_normalizado` AS
SELECT
  DATE(FECHA_TDC) AS FECHA_TDC,
  CASE
    WHEN UPPER(PAIS) LIKE 'ARG%' THEN 'ARG'
    WHEN UPPER(PAIS) LIKE 'BRA%' THEN 'BRA'
    WHEN UPPER(PAIS) LIKE 'MEX%' THEN 'MEX'
    ELSE PAIS
  END AS PAIS,
  TDC
FROM `mm-tse-latam-interviews.challange_florencia.tdc_2`;

-- [BASE PARA TODOS LOS ANÁLISIS]
-- 2. Cálculo de ingresos mensuales en USD
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales` AS
SELECT
  EXTRACT(MONTH FROM v.CREATION_DATE) AS mes,
  v.PAIS,
  COALESCE(p.NOMBRE, 'Producto-' || v.ID_PRODUCTO) AS nombre_producto,
  SUM( (v.PRECIO_MONEDA_LOCAL * v.CANTIDAD) / t.TDC ) AS ingreso_usd
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA` v
JOIN `mm-tse-latam-interviews.challange_florencia.productos_2` p 
  ON v.ID_PRODUCTO = CAST(p.ID_PRODUCTO AS STRING)
JOIN `mm-tse-latam-interviews.challange_florencia.tdc_normalizado` t 
  ON v.PAIS = t.PAIS AND v.CREATION_DATE = t.FECHA_TDC
GROUP BY 1,2,3;

-- [REQUERIMIENTO PRINCIPAL: Ranking de productos]
-- 3. Ranking mensual de productos
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.ranking_mensual` AS
SELECT
  mes,
  PAIS,
  nombre_producto,
  ingreso_usd,
  RANK() OVER (PARTITION BY mes, PAIS ORDER BY ingreso_usd DESC) AS ranking
FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`;

-- [CONSIGNA PREGUNTA 1: Productos con ventas estables]
-- 4. Productos estables (coeficiente de variación)
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.productos_estables` AS
SELECT 
  PAIS,
  nombre_producto,
  (STDDEV(ingreso_usd) / AVG(ingreso_usd)) * 100 AS coef_variacion
FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`
GROUP BY 1,2
HAVING COUNT(DISTINCT mes) >= 2;  -- Solo productos con datos en ≥2 meses

-- [CONSIGNA PREGUNTA 2: Diferencias entre países]
-- 5. Productos con diferencias entre países
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.productos_diferencias` AS
WITH ingresos_por_pais AS (
  SELECT 
    nombre_producto, 
    PAIS, 
    SUM(ingreso_usd) AS ingreso_total_usd
  FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`
  GROUP BY 1,2
)
SELECT
  nombre_producto,
  (MAX(ingreso_total_usd) - MIN(ingreso_total_usd)) / AVG(ingreso_total_usd) AS diff_relativa
FROM ingresos_por_pais
GROUP BY 1
HAVING COUNT(DISTINCT PAIS) >= 2;  -- Solo productos en ≥2 países

-- =============================================================================
-- RESPUESTAS REQUERIDAS
-- =============================================================================

/* [RESPUESTA PREGUNTA 1] Productos más estables por país */
SELECT 
  PAIS,
  nombre_producto,
  coef_variacion
FROM `mm-tse-latam-interviews.challange_florencia.productos_estables` p1
WHERE coef_variacion = (
  SELECT MIN(coef_variacion) 
  FROM `mm-tse-latam-interviews.challange_florencia.productos_estables` p2 
  WHERE p2.PAIS = p1.PAIS
)
ORDER BY PAIS;

/* [RESPUESTA PREGUNTA 2] Producto con mayor diferencia entre países */
SELECT 
  nombre_producto,
  diff_relativa
FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`
ORDER BY diff_relativa DESC
LIMIT 1;
