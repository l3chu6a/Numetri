-- ============================================
-- OVER (PARTITION BY)
-- ============================================
SELECT 
    country,
    product,
    gross_sales,
    SUM(gross_sales) OVER (PARTITION BY country) AS total_por_pais
FROM sales_data;

-- ============================================
-- MOVING AVERAGE (WINDOW FRAME)
-- ============================================
SELECT 
    country,
    year,
    month_number,
    gross_sales,
    AVG(gross_sales) OVER (
        PARTITION BY country 
        ORDER BY year, month_number 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS promedio_movil
FROM sales_data;

-- ============================================
-- RANK
-- ============================================
SELECT 
    country,
    product,
    gross_sales,
    RANK() OVER (
        PARTITION BY country 
        ORDER BY gross_sales DESC
    ) AS ranking_sales_data
FROM sales_data;

-- ============================================
-- DENSE_RANK
-- ============================================
SELECT 
    segment,
    product,
    profit,
    DENSE_RANK() OVER (
        PARTITION BY segment 
        ORDER BY profit DESC
    ) AS rank_dense
FROM sales_data;

-- ============================================
-- ROW_NUMBER
-- ============================================
SELECT 
    segment,
    product,
    profit,
    ROW_NUMBER() OVER (
        PARTITION BY segment 
        ORDER BY profit DESC
    ) AS fila
FROM sales_data;

-- ============================================
-- PIVOT (PostgreSQL / MySQL)
-- ============================================
SELECT 
    country,
    SUM(CASE WHEN month_name = 'January' THEN gross_sales ELSE 0 END) AS January,
    SUM(CASE WHEN month_name = 'February' THEN gross_sales ELSE 0 END) AS February
FROM sales_data
GROUP BY country;

-- ============================================
-- HAVING
-- ============================================
SELECT 
    country,
    SUM(gross_sales) AS total_sales_data
FROM sales_data
WHERE month_name IN ('January', 'February')
GROUP BY country
HAVING SUM(gross_sales) > 150000;

-- ============================================
-- CTE RECURSIVA (ejemplo genérico)
-- ============================================
WITH RECURSIVE jerarquia AS (
    SELECT id, product
    FROM sales_data
    WHERE product = 'Paseo'  -- cambiar según contexto real
)
SELECT * FROM jerarquia;

-- ============================================
-- SUBQUERY
-- ============================================
SELECT 
    v1.country,
    v1.product,
    v1.gross_sales,
    v1.month_name
FROM sales_data v1
WHERE gross_sales = (
    SELECT MAX(v2.gross_sales)
    FROM sales_data v2
    WHERE v2.country = v1.country
);
