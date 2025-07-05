/* SCRIPT DE VALIDACIÓN TÉCNICA: VERIFICA CALIDAD DE DATOS Y RESULTADOS */
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
  
  SELECT '08_estabilidad_count', CAST(COUNT(DISTINCT PAIS) AS STRING) 
  FROM `mm-tse-latam-interviews.challange_florencia.productos_estables` p1
  WHERE coef_variacion = (
    SELECT MIN(coef_variacion) 
    FROM `mm-tse-latam-interviews.challange_florencia.productos_estables` p2 
    WHERE p2.PAIS = p1.PAIS
  )
  
  UNION ALL
  
  SELECT '09_max_diferencia', CAST(ROUND(MAX(diff_relativa)*100, 2) AS STRING) 
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
    WHEN '08_estabilidad_count' THEN 'Países con producto estable identificado'
    WHEN '09_max_diferencia' THEN 'Máxima diferencia entre países (%)'
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
    WHEN '08_estabilidad_count' THEN '3'
    WHEN '09_max_diferencia' THEN '11.54'
  END AS valor_esperado,
  CASE
    WHEN id_metric = '01_total_registros' AND valor_obtenido = '5754' THEN '✅'
    WHEN id_metric = '02_fecha_min' AND valor_obtenido = '2022-01-01' THEN '✅'
    WHEN id_metric = '03_fecha_max' AND valor_obtenido = '2022-03-31' THEN '✅'
    WHEN id_metric = '04_paises_unicos' AND valor_obtenido = '3' THEN '✅'
    WHEN id_metric = '05_valores_invalidos' AND valor_obtenido = '0' THEN '✅'
    WHEN id_metric = '06_total_ingresos_usd' AND CAST(valor_obtenido AS FLOAT64) > 1000000 THEN '✅'
    WHEN id_metric = '07_productos_lideres' AND valor_obtenido = '9' THEN '✅'
    WHEN id_metric = '08_estabilidad_count' AND valor_obtenido = '3' THEN '✅'
    WHEN id_metric = '09_max_diferencia' AND ROUND(CAST(valor_obtenido AS FLOAT64), 2) = 11.54 THEN '✅'
    ELSE '❌'
  END AS estado
FROM (
  SELECT * FROM verif_ej1 
  UNION ALL 
  SELECT * FROM verif_ej2
);
