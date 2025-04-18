Over PARTITION

SELECT 
    id,
    vendedor,
    monto,
    SUM(monto) OVER (PARTITION BY vendedor) AS total_por_vendedor
FROM ventas;
======================================================================================================================================
SELECT 
    vendedor,
    fecha,
    monto,
    AVG(monto) OVER (
        PARTITION BY vendedor 
        ORDER BY fecha 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS promedio_movil
FROM ventas;
======================================================================================================================================
RANK

SELECT 
    vendedor,
    monto,
    fecha,
    RANK() OVER (
        PARTITION BY vendedor 
        ORDER BY monto DESC
    ) AS ranking_ventas
FROM ventas;
======================================================================================================================================
Dense RANK
SELECT 
    vendedor,
    region,
    monto,
    fecha,
    DENSE_RANK() OVER (
        PARTITION BY region 
        ORDER BY monto DESC
    ) AS rank_dense
FROM ventas;
======================================================================================================================================
Row NUMBER
SELECT 
    vendedor,
    region,
    monto,
    fecha,
    ROW_NUMBER() OVER (
        PARTITION BY region 
        ORDER BY monto DESC
    ) AS fila
FROM ventas;
======================================================================================================================================
Pivot
SELECT *
FROM (
    SELECT vendedor, mes, monto
    FROM ventas
) AS origen
PIVOT (
    SUM(monto)
    FOR mes IN ([Enero], [Febrero])
) AS tabla_pivot;

Pivot para postgreSQL y Mysql
SELECT 
    vendedor,
    SUM(CASE WHEN mes = 'Enero' THEN monto ELSE 0 END) AS Enero,
    SUM(CASE WHEN mes = 'Febrero' THEN monto ELSE 0 END) AS Febrero
FROM ventas
GROUP BY vendedor;

======================================================================================================================================
HAVING
SELECT 
    vendedor,
    SUM(monto) AS total_ventas
FROM ventas
WHERE mes IN ('Enero', 'Febrero')
GROUP BY vendedor
HAVING SUM(monto) > 150;
======================================================================================================================================
CTE

WITH RECURSIVE jerarquia AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE jefe_id IS NULL
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;
======================================================================================================================================
Subqueries
SELECT 
    v1.vendedor,
    v1.monto,
    v1.fecha
FROM ventas v1
WHERE monto = (
    SELECT MAX(v2.monto)
    FROM ventas v2
    WHERE v2.vendedor = v1.vendedor
);
