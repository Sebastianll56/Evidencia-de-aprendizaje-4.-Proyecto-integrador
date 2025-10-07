-- Archivo: Pruebas_Calidad.sql
-- Proyecto: EA4_GrupoS_IntegracionFinal
-- Autor: Sebastián Londoño Londoño
-- Descripción: Validaciones de integridad y consistencia de datos


-- 1. Verificar integridad entre la tabla de hechos y dimensiones
SELECT COUNT(*) AS registros_huerfanos
FROM Hechos_Ventas hv
LEFT JOIN Dim_Clientes dc ON hv.id_cliente = dc.id_cliente
WHERE dc.id_cliente IS NULL;

-- 2. Validar valores nulos en dimensiones
SELECT 'Dim_Productos' AS tabla, COUNT(*) AS nulos
FROM Dim_Productos WHERE nombre_producto IS NULL;

SELECT 'Dim_Empleados' AS tabla, COUNT(*) AS nulos
FROM Dim_Empleados WHERE nombre_empleado IS NULL;

-- 3. Validar duplicados en las dimensiones
SELECT id_cliente, COUNT(*) AS repeticiones
FROM Dim_Clientes
GROUP BY id_cliente
HAVING COUNT(*) > 1;

SELECT id_producto, COUNT(*) AS repeticiones
FROM Dim_Productos
GROUP BY id_producto
HAVING COUNT(*) > 1;

-- 4. Comprobar totales de ventas por mes
SELECT YEAR(fecha) AS año, MONTH(fecha) AS mes, SUM(monto_total) AS total_ventas
FROM Hechos_Ventas
GROUP BY YEAR(fecha), MONTH(fecha)
ORDER BY año, mes;

-- 5. Comparar totales de ventas del modelo estrella con fuente transaccional
SELECT SUM(monto_total) AS total_modelo_estrella
FROM Hechos_Ventas;

SELECT SUM(total_pedido) AS total_transaccional
FROM Fact_Pedidos_Original;

-- 6. Verificar correspondencia de claves en la tabla de hechos
SELECT COUNT(*) AS inconsistencias
FROM Hechos_Ventas hv
WHERE hv.id_producto NOT IN (SELECT id_producto FROM Dim_Productos)
   OR hv.id_cliente NOT IN (SELECT id_cliente FROM Dim_Clientes)
   OR hv.id_empleado NOT IN (SELECT id_empleado FROM Dim_Empleados);

-- Fin del archivo
