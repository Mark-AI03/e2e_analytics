CREATE VIEW top_10_products AS
SELECT
    TOP 10
    product_id,
    ROUND(SUM(sale_price), 2) AS [total_sales_revenue]
FROM df_orders
GROUP BY product_id
ORDER BY total_sales_revenue DESC


CREATE VIEW top_5_products_per_region AS
SELECT *
FROM (
    SELECT
        product_id,
        region,
        ROUND(SUM(sale_price), 2) AS [total_sales],
        ROW_NUMBER() OVER(
            PARTITION BY region ORDER BY SUM(sale_price) DESC
        ) AS [rank]
    FROM df_orders
    GROUP BY product_id, region
) ranked
WHERE rank <=5


CREATE VIEW month_over_month_growth AS
SELECT
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN total_sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN total_sales ELSE 0 END) AS sales_2023
FROM (
    SELECT
        MONTH(order_date) AS order_month,
        YEAR(order_date) AS order_year,
        ROUND(SUM(sale_price), 2) AS total_sales
    FROM df_orders
    GROUP BY MONTH(order_date), YEAR(order_date)
) cte
GROUP BY order_month
ORDER BY order_month


CREATE VIEW best_month_per_category AS
SELECT *
FROM
(
SELECT
    category,
    FORMAT(order_date, 'yyyyMM') AS [order_month],
    ROUND(SUM(sale_price),2) AS [total_sales],
    ROW_NUMBER() OVER(
        PARTITION BY category ORDER BY ROUND(SUM(sale_price),2) DESC
    ) AS [rank]
FROM df_orders
GROUP BY
    category,
    FORMAT(order_date, 'yyyyMM')
) ranked
WHERE rank = 1