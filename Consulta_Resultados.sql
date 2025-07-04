/* CONSULTA PARA VISUALIZAR RESULTADOS DE VERIFICACIÓN */
SELECT 
  metrica,
  valor_obtenido,
  valor_esperado,
  estado
FROM `mm-tse-latam-interviews.challange_florencia.Resultados_Verificacion`
ORDER BY id_metric;
