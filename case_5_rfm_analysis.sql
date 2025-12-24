-- =====================================================
-- CASE 5: RFM ANALYSIS
-- =====================================================

-- Step 1: Recency
-- Calculate days since the customer's most recent purchase.

WITH recency AS (
    SELECT 
        customer_id,
        MAX(invoicedate)::date AS last_invoice_date,
        DATE '2011-12-09' - MAX(invoicedate)::date AS recency_days
    FROM rfm
    WHERE customer_id IS NOT NULL
    GROUP BY 1
),

-- Step 2: Frequency
-- Count the number of unique invoices per customer.

frequency AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoiceno) AS frequency
    FROM rfm
    WHERE customer_id IS NOT NULL
      AND invoiceno NOT LIKE 'C%'
    GROUP BY 1
),

-- Step 3: Monetary
-- Calculate total monetary value per customer.

monetary AS (
    SELECT 
        customer_id,
        ROUND(SUM(quantity * unitprice)) AS monetary_value
    FROM rfm
    WHERE customer_id IS NOT NULL
    GROUP BY 1
    HAVING SUM(quantity * unitprice) > 0
),

-- Step 4: RFM Scoring
rfm_scores AS (
    SELECT 
        r.customer_id,
        r.recency_days,
        NTILE(5) OVER (ORDER BY r.recency_days DESC) AS recency_score,
        f.frequency,
        CASE
            WHEN f.frequency = 1 THEN 1
            WHEN f.frequency = 2 THEN 2
            WHEN f.frequency = 3 THEN 3
            WHEN f.frequency BETWEEN 4 AND 6 THEN 4
            ELSE 5
        END AS frequency_score,
        m.monetary_value,
        NTILE(5) OVER (ORDER BY m.monetary_value) AS monetary_score
    FROM recency r
    JOIN frequency f ON r.customer_id = f.customer_id
    JOIN monetary m ON r.customer_id = m.customer_id
)

-- Final RFM Score
SELECT 
    customer_id,
    recency_score || '-' || frequency_score || '-' || monetary_score AS rfm_score
FROM rfm_scores
LIMIT 10;
