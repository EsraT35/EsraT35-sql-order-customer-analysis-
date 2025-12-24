-- =====================================================
-- CASE 2: CUSTOMER ANALYSIS
-- =====================================================

-- Question:
-- Which cities have customers who place the highest number of orders?

WITH customer_order_counts AS (
    SELECT 
        c.customer_city AS customer_city,
        c.customer_unique_id AS customer_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY 1,2
)
SELECT 
    customer_city,
    SUM(order_count) AS total_orders
FROM customer_order_counts
GROUP BY 1
ORDER BY total_orders DESC
LIMIT 10;
