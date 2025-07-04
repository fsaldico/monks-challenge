/* CONTENIDO COMPLETO DEL SCRIPT DE VERIFICACIÓN */
CREATE OR REPLACE TABLE `mm-tse-latam-interviews.challange_florencia.Resultados_Verificacion` AS
WITH verificacion_limp AS (
  -- [Todo el contenido del script de verificación]
  ...
);

SELECT *,
  CASE
    -- [Lógica de validación]
  END AS status
FROM (
  SELECT * FROM verificacion_limp
  UNION ALL
  SELECT * FROM verificacion_anal
)
ORDER BY metric;
