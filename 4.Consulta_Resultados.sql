/* CONSULTA PARA VISUALIZACIÓN DE RESULTADOS CLAVE */
SELECT 
  metrica,
  valor_obtenido,
  valor_esperado,
  estado,
  CASE 
    WHEN id_metric = '08_estabilidad_count' THEN 'RESPUESTA PREGUNTA 1'
    WHEN id_metric = '09_max_diferencia' THEN 'RESPUESTA PREGUNTA 2'
    WHEN id_metric = '07_productos_lideres' THEN 'REQUERIMIENTO PRINCIPAL'
    ELSE 'VERIFICACIÓN GENERAL'
  END AS categoria
FROM `mm-tse-latam-interviews.challange_florencia.Resultados_Verificacion`
ORDER BY 
  CASE id_metric
    WHEN '01_total_registros' THEN 1
    WHEN '02_fecha_min' THEN 2
    WHEN '03_fecha_max' THEN 3
    WHEN '04_paises_unicos' THEN 4
    WHEN '05_valores_invalidos' THEN 5
    WHEN '06_total_ingresos_usd' THEN 6
    WHEN '07_productos_lideres' THEN 7
    WHEN '08_estabilidad_count' THEN 8
    WHEN '09_max_diferencia' THEN 9
  END;
