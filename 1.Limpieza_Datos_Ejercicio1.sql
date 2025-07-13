/* EJERCICIO 1: LIMPIEZA DE DATOS */
-- Creación de la tabla VENTAS_LIMPIA con datos depurados y normalizados
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA` AS

SELECT 
  -- Generar UUID para IDs nulos, convertir a STRING
  CASE 
    WHEN ID_VENTA IS NULL THEN GENERATE_UUID()
    ELSE CAST(ID_VENTA AS STRING)
  END AS ID_VENTA,
  
  -- Asignar fecha por defecto si es nula y convertir a DATE
  DATE(COALESCE(CREATION_DATE, '2022-01-01')) AS CREATION_DATE,
  
  -- Normalizar países a códigos de 3 letras
  CASE 
    WHEN REGEXP_CONTAINS(UPPER(PAIS), r'ARG|AR') THEN 'ARG'
    WHEN REGEXP_CONTAINS(UPPER(PAIS), r'BRA|BR') THEN 'BRA'
    WHEN REGEXP_CONTAINS(UPPER(PAIS), r'MEX|MX') THEN 'MEX'
    ELSE 'OTRO'  -- Manejo explícito para otros casos
  END AS PAIS,
  
  -- Asegurar que ID_PRODUCTO sea STRING
  CAST(ID_PRODUCTO AS STRING) AS ID_PRODUCTO,
  
  CAST(PRECIO_MONEDA_LOCAL AS FLOAT64) AS PRECIO_MONEDA_LOCAL,
  
  -- Tomar valor absoluto de la cantidad (eliminar negativos)
  ABS(CAST(CANTIDAD AS INT64)) AS CANTIDAD
  
FROM `mm-tse-latam-interviews.challange_florencia.ventas_2`
WHERE
  -- Filtrar registros sin precio
  PRECIO_MONEDA_LOCAL IS NOT NULL
  -- Filtrar por período de interés (primer trimestre 2022)
  AND CREATION_DATE BETWEEN '2022-01-01' AND '2022-03-31'
  -- Excluir cantidades cero o negativas
  AND ABS(CAST(CANTIDAD AS INT64)) > 0;

-- =============================================================================
-- VERIFICACIONES POST-LIMPIEZA
-- =============================================================================

-- Conteo de registros
SELECT '1. Total registros' AS metrica, COUNT(*) AS valor 
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;

-- Rango de fechas
SELECT '2. Rango fechas' AS metrica, 
  CONCAT(MIN(CREATION_DATE), ' - ', MAX(CREATION_DATE)) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;

-- Distribución por país
SELECT '3. Distribución ' || PAIS AS metrica, COUNT(*) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
GROUP BY PAIS;

-- Valores numéricos inválidos
SELECT '4. Valores inválidos' AS metrica,
  SUM(CASE WHEN PRECIO_MONEDA_LOCAL <= 0 OR CANTIDAD <= 0 THEN 1 ELSE 0 END) AS valor
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;
