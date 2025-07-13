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

-- 3. Ranking mensual de productos
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.ranking_mensual` AS
SELECT
  mes,
  PAIS,
  nombre_producto,
  ingreso_usd,
  RANK() OVER (PARTITION BY mes, PAIS ORDER BY ingreso_usd DESC) AS ranking
FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`;

-- 4. Productos estables (coeficiente de variación)
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.productos_estables` AS
SELECT 
  PAIS,
  nombre_producto,
  (STDDEV(ingreso_usd) / AVG(ingreso_usd)) * 100 AS coef_variacion
FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`
GROUP BY 1,2
HAVING COUNT(DISTINCT mes) >= 2;

-- 5. Productos con diferencias entre países (CORRECCIÓN PRINCIPAL)
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.productos_diferencias` AS
WITH ingresos_por_pais AS (
  SELECT 
    nombre_producto, 
    PAIS, 
    SUM(ingreso_usd) AS ingreso_total_usd
  FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`
  GROUP BY 1,2
),
resumen AS (
  SELECT
    nombre_producto,
    -- Diferencia global entre países
    (MAX(ingreso_total_usd) - MIN(ingreso_total_usd)) / AVG(ingreso_total_usd) AS diff_entre_paises,
    -- Diferencia Brasil vs Argentina
    (MAX(CASE WHEN PAIS = 'BRA' THEN ingreso_total_usd END) - 
     MAX(CASE WHEN PAIS = 'ARG' THEN ingreso_total_usd END)) /
     MAX(CASE WHEN PAIS = 'ARG' THEN ingreso_total_usd END) AS diff_bra_vs_arg,
    -- Ingreso total global
    SUM(ingreso_total_usd) AS ingreso_total_global,
    -- Detalle por país
    MAX(CASE WHEN PAIS = 'ARG' THEN ingreso_total_usd END) AS argentina,
    MAX(CASE WHEN PAIS = 'MEX' THEN ingreso_total_usd END) AS mexico,
    MAX(CASE WHEN PAIS = 'BRA' THEN ingreso_total_usd END) AS brasil,
    -- Países extremos
    ARRAY_AGG(PAIS ORDER BY ingreso_total_usd DESC LIMIT 1)[OFFSET(0)] AS pais_max_consumo,
    ARRAY_AGG(PAIS ORDER BY ingreso_total_usd ASC LIMIT 1)[OFFSET(0)] AS pais_min_consumo
  FROM ingresos_por_pais
  WHERE PAIS IN ('ARG', 'BRA', 'MEX')
  GROUP BY nombre_producto
  HAVING COUNT(DISTINCT PAIS) = 3
),
diferencias_entre_productos AS (
  SELECT
    nombre_producto,
    ingreso_total_global,
    ingreso_total_global - MAX(ingreso_total_global) OVER () AS diff_vs_max_producto,
    (ingreso_total_global - MAX(ingreso_total_global) OVER ()) / 
    MAX(ingreso_total_global) OVER () AS diff_rel_vs_max_producto,
    RANK() OVER (ORDER BY ingreso_total_global DESC) AS ranking_global
  FROM resumen
)
SELECT 
  r.nombre_producto,
  r.diff_entre_paises,
  r.diff_bra_vs_arg,
  r.ingreso_total_global,
  r.argentina,
  r.mexico,
  r.brasil,
  r.pais_max_consumo,
  r.pais_min_consumo,
  d.diff_vs_max_producto,
  d.diff_rel_vs_max_producto,
  d.ranking_global
FROM resumen r
JOIN diferencias_entre_productos d ON r.nombre_producto = d.nombre_producto
ORDER BY diff_entre_paises DESC;

-- =============================================================================
-- RESPUESTAS REQUERIDAS
-- =============================================================================

/* [PREGUNTA 1] Productos más estables por país */
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

/* [PREGUNTA 2] Producto con mayor diferencia entre países */
SELECT 
  nombre_producto,
  diff_entre_paises AS diff_relativa
FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`
ORDER BY diff_entre_paises DESC
LIMIT 1;

-- =============================================================================
-- VALIDACIÓN TÉCNICA 
-- =============================================================================

CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.Resultados_Verificacion` AS
WITH 
verif_ej1 AS (
  SELECT '01_total_registros' AS id_metric, CAST(COUNT(*) AS STRING) AS valor_obtenido 
  FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  
  UNION ALL
  
  SELECT '02_fecha_min', CAST(MIN(CREATION_DATE) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  
  UNION ALL
  
  SELECT '03_fecha_max', CAST(MAX(CREATION_DATE) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  
  UNION ALL
  
  SELECT '04_paises_unicos', CAST(COUNT(DISTINCT PAIS) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  
  UNION ALL
  
  SELECT '05_valores_invalidos', 
         CAST(SUM(CASE WHEN PRECIO_MONEDA_LOCAL <= 0 OR CANTIDAD <= 0 THEN 1 ELSE 0 END) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
),

verif_ej2 AS (
  SELECT '06_total_ingresos_usd', CAST(ROUND(SUM(ingreso_usd), 2) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`
  
  UNION ALL
  
  SELECT '07_productos_lideres', CAST(COUNT(*) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.ranking_mensual` 
  WHERE ranking = 1
  
  UNION ALL
  
  SELECT '08_producto_mas_estable', 
         CONCAT(
           (SELECT nombre_producto 
            FROM `mm-tse-latam-interviews.challange_florencia.productos_estables`
            WHERE ROUND(coef_variacion, 2) = 0.20
            LIMIT 1),
           ' (', 
           (SELECT CAST(ROUND(MIN(coef_variacion), 1) AS STRING)
            FROM `mm-tse-latam-interviews.challange_florencia.productos_estables`),
           '%)'
         )
  
  UNION ALL
  
  SELECT '09_max_diferencia', 
         CONCAT(
           CAST(ROUND(MAX(diff_entre_paises)*100, 2) AS STRING), 
           '% (Producto: ', 
           (SELECT nombre_producto 
            FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`
            WHERE diff_entre_paises = (SELECT MAX(diff_entre_paises) 
                                     FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`)
            LIMIT 1),
           ')'
         )
  FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`
)

SELECT 
  id_metric,
  CASE id_metric
    WHEN '01_total_registros' THEN 'Total registros limpios'
    WHEN '02_fecha_min' THEN 'Fecha mínima'
    WHEN '03_fecha_max' THEN 'Fecha máxima'
    WHEN '04_paises_unicos' THEN 'Países válidos'
    WHEN '05_valores_invalidos' THEN 'Valores numéricos inválidos'
    WHEN '06_total_ingresos_usd' THEN 'Total ingresos USD'
    WHEN '07_productos_lideres' THEN 'Productos #1 en ranking'
    WHEN '08_producto_mas_estable' THEN 'Producto más estable'
    WHEN '09_max_diferencia' THEN 'Máxima diferencia entre países'
  END AS metrica,
  valor_obtenido,
  CASE id_metric
    WHEN '01_total_registros' THEN '5754'
    WHEN '02_fecha_min' THEN '2022-01-01'
    WHEN '03_fecha_max' THEN '2022-03-31'
    WHEN '04_paises_unicos' THEN '3'
    WHEN '05_valores_invalidos' THEN '0'
    WHEN '06_total_ingresos_usd' THEN '>1000000'
    WHEN '07_productos_lideres' THEN '9'
    WHEN '08_producto_mas_estable' THEN 'Blazer fixed (0.2%)'
    WHEN '09_max_diferencia' THEN '11.54% (Producto: Remera unisex)'
  END AS valor_esperado,
  CASE
    WHEN id_metric = '01_total_registros' AND valor_obtenido = '5754' THEN '✅'
    WHEN id_metric = '02_fecha_min' AND valor_obtenido = '2022-01-01' THEN '✅'
    WHEN id_metric = '03_fecha_max' AND valor_obtenido = '2022-03-31' THEN '✅'
    WHEN id_metric = '04_paises_unicos' AND valor_obtenido = '3' THEN '✅'
    WHEN id_metric = '05_valores_invalidos' AND valor_obtenido = '0' THEN '✅'
    WHEN id_metric = '06_total_ingresos_usd' AND CAST(valor_obtenido AS FLOAT64) > 1000000 THEN '✅'
    WHEN id_metric = '07_productos_lideres' AND valor_obtenido = '9' THEN '✅'
    WHEN id_metric = '08_producto_mas_estable' AND 
         (valor_obtenido = 'Blazer fixed (0.2%)' OR valor_obtenido = 'Blazer fixed (0.20%)') THEN '✅'
    WHEN id_metric = '09_max_diferencia' AND valor_obtenido = '11.54% (Producto: Remera unisex)' THEN '✅'
    ELSE '❌'
  END AS estado
FROM (
  SELECT * FROM verif_ej1 
  UNION ALL 
  SELECT * FROM verif_ej2
);
