-- Gold: Sales performance by geographic region
CREATE OR REFRESH MATERIALIZED VIEW gold_sales_by_region
CLUSTER BY (region)
COMMENT "Regional sales metrics for geographic performance analysis"
AS
SELECT
  st.region,
  st.store_type,
  COUNT(DISTINCT s.sale_id) AS transaction_count,
  COUNT(DISTINCT s.customer_id) AS unique_customers,
  COUNT(DISTINCT s.store_id) AS store_count,
  SUM(s.quantity) AS total_units_sold,
  SUM(s.total) AS total_revenue,
  AVG(s.total) AS avg_transaction_value,
  SUM(s.discount_amount) AS total_discounts,
  -- Calculate revenue per store
  SUM(s.total) / COUNT(DISTINCT s.store_id) AS avg_revenue_per_store,
  -- Calculate conversion metrics
  COUNT(DISTINCT s.customer_id) * 1.0 / NULLIF(COUNT(DISTINCT s.sale_id), 0) AS customer_to_transaction_ratio,
  current_timestamp() AS _updated_at
FROM silver_sales s
INNER JOIN silver_stores st ON s.store_id = st.store_id
WHERE s.data_quality_status = 'VALID'
  AND st.data_quality_status = 'VALID'
GROUP BY st.region, st.store_type
;
