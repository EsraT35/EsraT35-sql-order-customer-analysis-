-- =====================================================
-- CASE 3: SELLER ANALYSIS
-- =====================================================

-- Question 1:
-- Identify the top 5 sellers with the fastest delivery times
-- and analyze their order volumes.

WITH delivery_times AS (
    SELECT 
        oi.seller_id,
        o.order_id,
        (o.order_delivered_customer_date - o.order_purchase_timestamp) AS delivery_duration
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT 
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    AVG(delivery_duration) AS avg_delivery_time
FROM delivery_times
GROUP BY 1
ORDER BY total_orders DESC
LIMIT 5;


-- Question 1 (continued):
-- Analyze average review scores of the selected sellers.

SELECT 
    s.seller_id,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM reviews r
JOIN order_items oi ON oi.order_id = r.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
GROUP BY 1
ORDER BY average_review_score DESC;


-- Question 2:
-- Which sellers sell products across the highest number of categories?
-- Do sellers with more categories also have more orders?

WITH seller_category_counts AS (
    SELECT 
        oi.seller_id,
        COUNT(DISTINCT p.product_category_name) AS category_count
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY 1
),
seller_order_counts AS (
    SELECT 
        seller_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM order_items
    GROUP BY 1
)
SELECT 
    scc.seller_id,
    scc.category_count,
    soc.order_count
FROM seller_category_counts scc
JOIN seller_order_counts soc ON scc.seller_id = soc.seller_id
ORDER BY category_count DESC
LIMIT 5;
