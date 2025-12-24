-- =====================================================
-- CASE 4: PAYMENT ANALYSIS
-- =====================================================

-- Question 1:
-- In which regions do customers most frequently use high installment payments?
-- (Example: 24-installment payments)

SELECT 
    c.customer_state AS customer_state,
    p.payment_installments AS installment_count,
    COUNT(*) AS order_count
FROM payments p
JOIN orders o ON o.order_id = p.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE p.payment_installments = 24
GROUP BY 1,2
ORDER BY order_count DESC;


-- Question 2:
-- Calculate the number of successful orders and total payment amount
-- by payment type. Only delivered orders are considered successful.

SELECT 
    p.payment_type AS payment_type,
    COUNT(DISTINCT o.order_id) AS successful_order_count,
    ROUND(SUM(p.payment_value)) AS total_payment_amount
FROM payments p
JOIN orders o ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY successful_order_count DESC;


-- Question 3a:
-- Category-based analysis of orders paid in a single installment.

SELECT 
    pr.product_category_name AS product_category,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM payments p
JOIN order_items oi ON oi.order_id = p.order_id
JOIN products pr ON pr.product_id = oi.product_id
WHERE p.payment_installments = 1
  AND pr.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY order_count DESC
LIMIT 10;


-- Question 3b:
-- Category-based analysis of orders paid in multiple installments.

WITH installment_orders AS (
    SELECT 
        pr.product_category_name AS product_category,
        COUNT(DISTINCT oi.order_id) AS order_count
    FROM payments p
    JOIN order_items oi ON oi.order_id = p.order_id
    JOIN products pr ON pr.product_id = oi.product_id
    WHERE p.payment_installments > 1
      AND pr.product_category_name IS NOT NULL
    GROUP BY 1
)
SELECT 
    product_category,
    order_count
FROM installment_orders
ORDER BY order_count DESC
LIMIT 10;
