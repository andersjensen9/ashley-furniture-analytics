-- Gold: Customer-level metrics for segmentation and lifetime value analysis
CREATE OR REFRESH MATERIALIZED VIEW gold_customer_metrics
CLUSTER BY (segment, customer_lifecycle)
COMMENT "Customer behavior metrics for segmentation and LTV analysis"
AS
SELECT
  c.customer_id,
  c.full_name,
  c.segment,
  c.customer_lifecycle,
  c.state,
  c.tenure_days,
  -- Purchase metrics
  COUNT(DISTINCT s.sale_id) AS total_transactions,
  SUM(s.total) AS lifetime_value,
  AVG(s.total) AS avg_transaction_value,
  MAX(s.sale_date) AS last_purchase_date,
  MIN(s.sale_date) AS first_purchase_date,
  DATEDIFF(CURRENT_DATE(), MAX(s.sale_date)) AS days_since_last_purchase,
  -- Recency-Frequency-Monetary (RFM) components
  DATEDIFF(CURRENT_DATE(), MAX(s.sale_date)) AS recency_days,
  COUNT(DISTINCT s.sale_id) AS frequency,
  SUM(s.total) AS monetary_value,
  -- Product preferences
  COUNT(DISTINCT s.product_id) AS unique_products_purchased,
  SUM(s.quantity) AS total_units_purchased,
  AVG(s.discount_pct) AS avg_discount_taken,
  current_timestamp() AS _updated_at
FROM silver_customers c
INNER JOIN silver_sales s ON c.customer_id = s.customer_id
WHERE c.data_quality_status = 'VALID'
  AND s.data_quality_status = 'VALID'
GROUP BY
  c.customer_id,
  c.full_name,
  c.segment,
  c.customer_lifecycle,
  c.state,
  c.tenure_days
;
