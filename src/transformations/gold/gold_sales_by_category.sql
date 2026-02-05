-- Gold: Sales performance by product category
CREATE OR REFRESH MATERIALIZED VIEW gold_sales_by_category
CLUSTER BY (category)
COMMENT "Category-level sales metrics for product performance analysis"
AS
SELECT
  p.category,
  COUNT(DISTINCT s.sale_id) AS transaction_count,
  COUNT(DISTINCT s.customer_id) AS unique_customers,
  COUNT(DISTINCT s.product_id) AS products_sold,
  SUM(s.quantity) AS total_units_sold,
  SUM(s.total) AS total_revenue,
  AVG(s.total) AS avg_transaction_value,
  SUM(s.discount_amount) AS total_discounts,
  AVG(s.discount_pct) AS avg_discount_rate,
  -- Calculate profit metrics
  SUM(s.quantity * p.profit_per_unit) AS estimated_profit,
  AVG(p.profit_margin_pct) AS avg_profit_margin_pct,
  current_timestamp() AS _updated_at
FROM silver_sales s
INNER JOIN silver_products p ON s.product_id = p.product_id
WHERE s.data_quality_status = 'VALID'
  AND p.data_quality_status = 'VALID'
GROUP BY p.category
;
