-- =====================================================
-- CASE 1: ORDER ANALYSIS
-- =====================================================

-- Question 1:
-- Analyze monthly order distribution using order_approved_at.

SELECT 
  TO_CHAR(order_approved_at, 'yyyy-mm') AS order_month,
  COUNT(order_id) AS order_count
FROM orders
WHERE order_approved_at IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- Question 2:
-- Analyze monthly order counts by order status.

SELECT 
  TO_CHAR(order_approved_at, 'yyyy-mm') AS order_month,
  COUNT(order_id) AS total_orders,
  COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) AS delivered_orders,
  COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) AS canceled_orders,
  COUNT(CASE WHEN order_status = 'approved' THEN 1 END) AS approved_orders,
  COUNT(CASE WHEN order_status = 'created' THEN 1 END) AS created_orders,
  COUNT(CASE WHEN order_status = 'invoiced' THEN 1 END) AS invoiced_orders,
  COUNT(CASE WHEN order_status = 'processing' THEN 1 END) AS processing_orders,
  COUNT(CASE WHEN order_status = 'shipped' THEN 1 END) AS shipped_orders,
  COUNT(CASE WHEN order_status = 'unavailable' THEN 1 END) AS unavailable_orders
FROM orders
WHERE order_approved_at IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- Question 3:
-- Analyze order counts by product category for a specific month.

WITH category_orders AS (
    SELECT
      TO_CHAR(o.order_approved_at, 'yyyy-mm') AS order_month,
      p.product_category_name AS product_category,
      COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    LEFT JOIN order_items oi ON oi.order_id = o.order_id
    LEFT JOIN products p ON p.product_id = oi.product_id
    WHERE o.order_approved_at IS NOT NULL
      AND p.product_category_name IS NOT NULL
    GROUP BY 1,2
)
SELECT *
FROM category_orders
WHERE order_month = '2017-11'
ORDER BY order_count DESC
LIMIT 10;


-- Question 4a:
-- Analyze order distribution by day of the week.

SELECT 
  TO_CHAR(order_purchase_timestamp, 'Day') AS weekday,
  COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY 1
ORDER BY order_count DESC;


-- Question 4b:
-- Analyze order distribution by day of the month.

SELECT 
  EXTRACT(DAY FROM order_purchase_timestamp) AS day_of_month,
  COUNT(DISTINCT order_id) AS order_count
FROM orders
GROUP BY 1
ORDER BY 1;
