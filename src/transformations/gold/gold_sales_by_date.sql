-- Gold: Daily sales metrics for time-series analysis
CREATE OR REFRESH MATERIALIZED VIEW gold_sales_by_date
CLUSTER BY (sale_date)
COMMENT "Daily sales aggregations for trend analysis and forecasting"
AS
SELECT
  sale_date,
  sale_year,
  sale_month,
  is_weekend,
  COUNT(DISTINCT sale_id) AS transaction_count,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT store_id) AS active_stores,
  SUM(quantity) AS total_units_sold,
  SUM(subtotal) AS gross_revenue,
  SUM(discount_amount) AS total_discounts,
  SUM(tax) AS total_tax,
  SUM(total) AS net_revenue,
  AVG(total) AS avg_transaction_value,
  MAX(total) AS max_transaction_value,
  MIN(total) AS min_transaction_value,
  -- Calculate average discount percentage
  AVG(discount_pct) AS avg_discount_rate,
  current_timestamp() AS _updated_at
FROM silver_sales
WHERE data_quality_status = 'VALID'
GROUP BY sale_date, sale_year, sale_month, is_weekend
;
