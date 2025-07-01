CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.VENTAS_LIMPIA` AS
SELECT DISTINCT
  ID_VENTA,
  DATE(CREATION_DATE) AS CREATION_DATE,
  PAIS,
  ID_PRODUCTO,
  PRECIO_MONEDA_LOCAL,
  CANTIDAD
FROM `mm-tse-latam-interviews.challange_florencia.ventas_2`
WHERE
  ID_VENTA IS NOT NULL
  AND PRECIO_MONEDA_LOCAL IS NOT NULL
  AND CANTIDAD > 0
  AND PAIS IN ('ARG','BRA','MEX')
  AND CAST(ID_PRODUCTO AS STRING) IN (  -- Conversión clave aquí
    SELECT CAST(ID_PRODUCTO AS STRING)  -- Conversión aquí también
    FROM `mm-tse-latam-interviews.challange_florencia.productos_2`
  );
