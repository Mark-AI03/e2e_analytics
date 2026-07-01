-- -- TOP 10 highest Revenue
-- SELECT
--     TOP 10
--     product_id,
--     ROUND(SUM(sale_price), 2) AS [total_sales_revenue]
-- FROM df_orders
-- GROUP BY product_id
-- ORDER BY total_sales_revenue DESC


-- -- Top 5 highest selling products in each region
-- WITH cte AS (
-- SELECT
--     product_id,
--     region,
--     ROUND(SUM(sale_price), 2) AS [total_sales]
-- FROM df_orders
-- GROUP BY product_id, region
-- ),
-- ranked AS (
-- SELECT
--     *,
--     ROW_NUMBER() OVER(
--         PARTITION BY region ORDER BY total_sales DESC
--     ) AS [rank]
-- FROM cte
-- )
-- SELECT *
-- FROM ranked
-- WHERE rank <=5


-- WITH cte AS (
-- SELECT
--     MONTH(order_date) AS [order_month],
--     YEAR(order_date) AS [order_year],
--     ROUND(SUM(sale_price),2) AS [total_sales]
-- FROM df_orders
-- GROUP BY MONTH(order_date),YEAR(order_date)
-- )
-- SELECT
--     order_month,
--     SUM(CASE WHEN order_year = 2022 THEN total_sales ELSE 0 END) AS sales_2022,
--     SUM(CASE WHEN order_year = 2023 THEN total_sales ELSE 0 END) AS sales_2023
-- FROM cte
-- GROUP BY order_month
-- ORDER BY order_month


-- WITH cte AS (
-- SELECT
--     category,
--     FORMAT(order_date, 'yyyyMM') AS [order_month],
--     ROUND(SUM(sale_price),2) AS [total_sales]
-- FROM df_orders
-- GROUP BY
--     category,
--     FORMAT(order_date, 'yyyyMM')
-- ),
-- ranked AS (
-- SELECT
--     *,
--     ROW_NUMBER() OVER(
--         PARTITION BY category ORDER BY total_sales DESC
--     ) AS [rank]
-- FROM cte
-- )
-- SELECT *
-- FROM ranked
-- WHERE rank = 1


-- question 5: which sub-category had the highest growth by profit in 2023 vs 2022.
SELECT TOP 1 *
FROM (
SELECT
    sub_category,
    SUM(CASE WHEN order_year = 2022 THEN total_profit ELSE 0 END) AS [profit_2022],
    SUM(CASE WHEN order_year = 2023 THEN total_profit ELSE 0 END) AS [profit_2023],
    (SUM(CASE WHEN order_year = 2023 THEN total_profit ELSE 0 END) - SUM(CASE WHEN order_year = 2022 THEN total_profit ELSE 0 END)) / NULLIF(SUM(CASE WHEN order_year = 2022 THEN total_profit ELSE 0 END), 0) * 100 AS [growth_percentage]
FROM (
    SELECT
        sub_category,
        FORMAT(order_date, 'yyyy') AS [order_year],
        ROUND(SUM(profit),2) AS [total_profit]
    FROM df_orders
    GROUP BY sub_category, FORMAT(order_date, 'yyyy')
) cte
GROUP BY sub_category
) cte2
ORDER BY growth_percentage DESC