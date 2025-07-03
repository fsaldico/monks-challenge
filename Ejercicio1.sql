/* EJERCICIO 1: INTEGRIDAD DE DATOS */
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA` AS
SELECT 
  -- Filtro 1: Generar UUID para IDs nulos
  CASE 
    WHEN ID_VENTA IS NULL THEN GENERATE_UUID()
    ELSE CAST(ID_VENTA AS STRING)
  END AS ID_VENTA,
  
  -- Filtro 2: Asignar fecha por defecto si es nula
  DATE(COALESCE(CREATION_DATE, '2022-01-01')) AS CREATION_DATE,
  
  -- Filtro 3: Normalizar países a códigos estándar
  CASE 
    WHEN REGEXP_CONTAINS(UPPER(PAIS), r'ARG|AR') THEN 'ARG'
    WHEN REGEXP_CONTAINS(UPPER(PAIS), r'BRA|BR') THEN 'BRA'
    WHEN REGEXP_CONTAINS(UPPER(PAIS), r'MEX|MX') THEN 'MEX'
  END AS PAIS,
  
  -- Filtro 4: Unificar tipo de dato para ID_PRODUCTO
  CAST(ID_PRODUCTO AS STRING) AS ID_PRODUCTO,
  
  PRECIO_MONEDA_LOCAL,
  
  -- Filtro 5: Convertir cantidades negativas a positivas
  ABS(CANTIDAD) AS CANTIDAD
  
FROM `mm-tse-latam-interviews.challange_florencia.ventas_2`
WHERE
  -- Filtro 6: Excluir registros sin precio
  PRECIO_MONEDA_LOCAL IS NOT NULL
  
  -- Filtro 7: Limitar a período enero-marzo 2022
  AND CREATION_DATE BETWEEN '2022-01-01' AND '2022-03-31'
  
  -- Filtro 8: Excluir cantidades cero o negativas
  AND ABS(CANTIDAD) > 0;

-- =============================================================================
-- VERIFICACIÓN DE CALIDAD POST-LIMPIEZA
-- =============================================================================

-- Verificación 1: Conteo de registros limpios
SELECT 
  'VENTAS_LIMPIA' AS tabla,
  COUNT(*) AS total_registros
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;

-- Verificación 2: Rango de fechas válido
SELECT 
  MIN(CREATION_DATE) AS fecha_minima,
  MAX(CREATION_DATE) AS fecha_maxima
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;

-- Verificación 3: Países válidos
SELECT 
  PAIS,
  COUNT(*) AS conteo
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`
GROUP BY PAIS;

-- Verificación 4: Valores numéricos válidos
SELECT 
  COUNTIF(PRECIO_MONEDA_LOCAL <= 0) AS precios_invalidos,
  COUNTIF(CANTIDAD <= 0) AS cantidades_invalidas
FROM `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA`;
