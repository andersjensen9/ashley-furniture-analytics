-- Gold: Product-level performance metrics
CREATE OR REFRESH MATERIALIZED VIEW gold_product_performance
CLUSTER BY (category, item_type)
COMMENT "Product performance metrics for inventory and merchandising decisions"
AS
SELECT
  p.product_id,
  p.product_name,
  p.category,
  p.item_type,
  p.price,
  p.cost,
  p.profit_margin_pct,
  p.in_stock,
  -- Sales metrics
  COUNT(DISTINCT s.sale_id) AS times_sold,
  SUM(s.quantity) AS total_units_sold,
  SUM(s.total) AS total_revenue,
  AVG(s.total / NULLIF(s.quantity, 0)) AS avg_selling_price,
  SUM(s.quantity * p.profit_per_unit) AS total_profit,
  -- Customer reach
  COUNT(DISTINCT s.customer_id) AS unique_customers,
  COUNT(DISTINCT s.store_id) AS stores_sold_at,
  -- Discount analysis
  AVG(s.discount_pct) AS avg_discount_rate,
  SUM(s.discount_amount) AS total_discounts_given,
  -- Date metrics
  MAX(s.sale_date) AS last_sold_date,
  DATEDIFF(CURRENT_DATE(), MAX(s.sale_date)) AS days_since_last_sale,
  current_timestamp() AS _updated_at
FROM silver_products p
INNER JOIN silver_sales s ON p.product_id = s.product_id
WHERE p.data_quality_status = 'VALID'
  AND s.data_quality_status = 'VALID'
GROUP BY
  p.product_id,
  p.product_name,
  p.category,
  p.item_type,
  p.price,
  p.cost,
  p.profit_margin_pct,
  p.profit_per_unit,
  p.in_stock
;
