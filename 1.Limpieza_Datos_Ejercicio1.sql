/* EJERCICIO 1: LIMPIEZA DE DATOS */

-- 1. Normalización de países y fechas
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA` AS
SELECT
  CAST(ID_PEDIDO AS STRING) AS ID_PEDIDO,
  CAST(ID_PRODUCTO AS STRING) AS ID_PRODUCTO,
  CASE
    WHEN UPPER(PAIS) LIKE 'ARG%' THEN 'ARG'
    WHEN UPPER(PAIS) LIKE 'BRA%' THEN 'BRA'
    WHEN UPPER(PAIS) LIKE 'MEX%' THEN 'MEX'
    ELSE PAIS
  END AS PAIS,
  CAST(CANTIDAD AS INT64) AS CANTIDAD,
  CAST(PRECIO_MONEDA_LOCAL AS FLOAT64) AS PRECIO_MONEDA_LOCAL,
  PARSE_DATE('%Y-%m-%d', FECHA_CREACION) AS CREATION_DATE
FROM `mm-tse-latam-interviews.challange_florencia.ventas_2`
WHERE
  -- Filtro de fechas válidas
  FECHA_CREACION BETWEEN '2022-01-01' AND '2022-03-31'
  -- Filtro de países válidos
  AND UPPER(PAIS) IN ('ARGENTINA', 'BRASIL', 'MEXICO', 'ARG', 'BRA', 'MEX')
  -- Filtro de valores numéricos válidos
  AND CAST(CANTIDAD AS INT64) > 0
  AND CAST(PRECIO_MONEDA_LOCAL AS FLOAT64) > 0;

-- 2. Verificación de resultados
SELECT
  '1. Total registros' AS metrica,
  CAST(COUNT(*) AS STRING) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`

UNION ALL

SELECT
  '2. Rango fechas' AS metrica,
  CONCAT(MIN(CREATION_DATE), ' - ', MAX(CREATION_DATE)) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`

UNION ALL

SELECT
  '3. Distribución ' || PAIS AS metrica,
  CAST(COUNT(*) AS STRING) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
GROUP BY PAIS

UNION ALL

SELECT
  '4. Valores inválidos' AS metrica,
  CAST(SUM(CASE WHEN PRECIO_MONEDA_LOCAL <= 0 OR CANTIDAD <= 0 THEN 1 ELSE 0 END) AS STRING) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;
