/* SCRIPT DE VERIFICACIÓN DE RESULTADOS */
-- Crear tabla consolidada con resultados de validación
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.Resultados_Verificacion` AS
WITH 
-- Verificaciones del Ejercicio 1: Limpieza
verif_ej1 AS (
  SELECT '01_total_registros' AS id_metric, COUNT(*) AS valor_obtenido FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  UNION ALL
  SELECT '02_fecha_min', MIN(CREATION_DATE) FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  UNION ALL
  SELECT '03_fecha_max', MAX(CREATION_DATE) FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  UNION ALL
  SELECT '04_paises_unicos', COUNT(DISTINCT PAIS) FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
  UNION ALL
  SELECT '05_valores_invalidos', SUM(CASE WHEN PRECIO_MONEDA_LOCAL <= 0 OR CANTIDAD <= 0 THEN 1 ELSE 0 END) FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
),

-- Verificaciones del Ejercicio 2: Análisis
verif_ej2 AS (
  SELECT '06_total_ingresos_usd', SUM(ingreso_usd) FROM `mm-tse-latam-interviews.challange_florencia.ingresos_mensuales`
  UNION ALL
  SELECT '07_productos_lideres', COUNT(*) FROM `mm-tse-latam-interviews.challange_florencia.ranking_mensual` WHERE ranking = 1
  UNION ALL
  SELECT '08_max_diferencia', MAX(diff_relativa)*100 FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`
)

-- Consolidar y agregar descripciones
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
    WHEN '08_max_diferencia' THEN 'Máxima diferencia entre países (%)'
  END AS metrica,
  CAST(valor_obtenido AS STRING) AS valor_obtenido,
  CASE id_metric
    WHEN '01_total_registros' THEN '5754'
    WHEN '02_fecha_min' THEN '2022-01-01'
    WHEN '03_fecha_max' THEN '2022-03-31'
    WHEN '04_paises_unicos' THEN '3'
    WHEN '05_valores_invalidos' THEN '0'
    WHEN '06_total_ingresos_usd' THEN '>1000000'
    WHEN '07_productos_lideres' THEN '>10'
    WHEN '08_max_diferencia' THEN '11.54'
  END AS valor_esperado,
  CASE
    WHEN id_metric = '01_total_registros' AND valor_obtenido = 5754 THEN '✅'
    WHEN id_metric = '02_fecha_min' AND valor_obtenido = '2022-01-01' THEN '✅'
    WHEN id_metric = '03_fecha_max' AND valor_obtenido = '2022-03-31' THEN '✅'
    WHEN id_metric = '04_paises_unicos' AND valor_obtenido = 3 THEN '✅'
    WHEN id_metric = '05_valores_invalidos' AND valor_obtenido = 0 THEN '✅'
    WHEN id_metric = '06_total_ingresos_usd' AND valor_obtenido > 1000000 THEN '✅'
    WHEN id_metric = '07_productos_lideres' AND valor_obtenido > 10 THEN '✅'
    WHEN id_metric = '08_max_diferencia' AND ROUND(valor_obtenido, 2) = 11.54 THEN '✅'
    ELSE '❌'
  END AS estado
FROM (
  SELECT * FROM verif_ej1 
  UNION ALL 
  SELECT * FROM verif_ej2
);
