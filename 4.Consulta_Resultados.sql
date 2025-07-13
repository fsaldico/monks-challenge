-- EJERCICIO 2: RESULTADOS FINALES

/* PREGUNTA 1: Producto más estable por país */
SELECT 
  PAIS,
  nombre_producto,
  ROUND(coef_variacion, 2) AS coef_variacion
FROM (
  SELECT 
    PAIS,
    nombre_producto,
    coef_variacion,
    RANK() OVER (PARTITION BY PAIS ORDER BY coef_variacion) AS rank_estabilidad
  FROM `mm-tse-latam-interviews.challange_florencia.productos_estables`
)
WHERE rank_estabilidad = 1
ORDER BY PAIS;

/* PREGUNTA 2: Producto con mayor diferencia entre países */
SELECT 
  nombre_producto,
  ROUND(diff_entre_paises * 100, 2) AS diferencia_porcentual,
  ROUND(ingreso_total_global, 2) AS ingreso_total_usd,
  ROUND(argentina, 2) AS argentina_usd,
  ROUND(mexico, 2) AS mexico_usd,
  ROUND(brasil, 2) AS brasil_usd
FROM `mm-tse-latam-interviews.challange_florencia.productos_diferencias`
ORDER BY diff_entre_paises DESC
LIMIT 1;

/* VERIFICACIÓN TÉCNICA */
SELECT
  'Total registros limpios' AS metrica,
  COUNT(*) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`

UNION ALL

SELECT
  'Productos líderes por mes/país',
  COUNT(*)
FROM `mm-tse-latam-interviews.challange_florencia.ranking_mensual`
WHERE ranking = 1;
