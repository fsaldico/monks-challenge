# 🧥 Análisis de Ventas Minoristas  
**Primer Trimestre 2022 - Argentina, Brasil y México**  

[![Licencia MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Google BigQuery](https://img.shields.io/badge/Google%20BigQuery-4285F4?logo=googlecloud&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-003B57?logo=postgresql&logoColor=white)

Repositorio con la solución completa para el challenge de análisis de ventas minoristas. Contiene scripts SQL para limpieza de datos, análisis comercial y validación técnica.

## 📁 Estructura del Repositorio
Archivo	Descripción
Limpieza_Datos_Ejercicio1.sql	Limpieza de datos y creación de tabla depurada
Analisis_Ventas_Ejercicio2.sql	Análisis de ventas, ranking e insights
Verificacion_Resultados.sql	Validación técnica de resultados
Consulta_Resultados.sql	Consulta para visualizar resultados de validación
📋 Flujo de Trabajo




🚀 Instalación y Ejecución
Prerrequisitos:
• Acceso a Google BigQuery
• Permisos en el proyecto: mm-tse-latam-interviews
• Dataset: challange_florencia

Ejecución Paso a Paso:
1.Limpieza de datos:
-- Ejecutar en BigQuery
[CONTENIDO DE Limpieza_Datos_Ejercicio1.sql]

2.Análisis de ventas:
-- Ejecutar en BigQuery
[CONTENIDO DE Analisis_Ventas_Ejercicio2.sql]

3.Validación técnica:
-- Ejecutar en BigQuery
[CONTENIDO DE Verificacion_Resultados.sql]

4.Verificar resultados:
-- Ejecutar en BigQuery
[CONTENIDO DE Consulta_Resultados.sql]

📊 Resultados Clave
Hallazgos Principales:

1.Producto líder: Zapatos GTV (#1 en los tres países durante enero y febrero)
2.Productos más estables:
Argentina: Blazer fixed (CV: 0.20%)
Brasil: Blazer fixed (CV: 8.29%)
México: Remera unisex (CV: 6.49%)
3.Mayor variación geográfica: Remera unisex (11.54% de diferencia)

Métricas de Validación
Métrica	               Valor Obtenido	          Estado
Registros limpios	     5,754	                      ✅
Fechas válidas	       2022-01-01 a 2022-03-31	    ✅
Ingresos totales USD	 > 1,240,000	                ✅
Máxima diferencia	11.54%	                          ✅

📈 Visualización de Resultados
Ejecutar Consulta_Resultados.sql para obtener:

sql
SELECT * 
FROM `mm-tse-latam-interviews.challange_florencia.Resultados_Verificacion`
ORDER BY id_metric;

https://via.placeholder.com/600x300?text=Tabla+de+Validaci%25C3%25B3n+Completa

📌 Estructura de Datos
Tabla Principal: VENTAS_LIMPIA
sql
VENTAS_LIMPIA (
  ID_VENTA STRING,
  CREATION_DATE DATE,
  PAIS STRING,           -- Valores: ARG, BRA, MEX
  ID_PRODUCTO STRING,
  PRECIO_MONEDA_LOCAL FLOAT64,
  CANTIDAD INT64         -- Siempre > 0
)
Tablas Analíticas
sql
ranking_mensual (
  mes INT64,
  PAIS STRING,
  nombre_producto STRING,
  ingreso_usd FLOAT64,
  ranking INT64
)

productos_estables (
  PAIS STRING,
  nombre_producto STRING,
  coef_variacion FLOAT64
)

🤝 Contribución
Haz un fork del proyecto

Crea una rama (git checkout -b feature/nueva-funcionalidad)

Realiza tus cambios

Haz commit (git commit -m 'Añade nueva funcionalidad')

Haz push a la rama (git push origin feature/nueva-funcionalidad)

Abre un Pull Request

📄 Licencia
Este proyecto está bajo la licencia MIT.

✉️ Contacto
Florencia Saldico
fsaldico@example.com
LinkedIn
