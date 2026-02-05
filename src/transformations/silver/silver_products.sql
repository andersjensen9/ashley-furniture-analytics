-- Silver: Cleaned and enriched product data
CREATE OR REFRESH STREAMING TABLE silver_products
CLUSTER BY (category, item_type)
COMMENT "Cleaned product catalog with calculated metrics"
AS
SELECT
  product_id,
  product_name,
  category,
  item_type,
  CAST(price AS DECIMAL(10,2)) AS price,
  CAST(cost AS DECIMAL(10,2)) AS cost,
  -- Calculate profit margin
  ROUND((price - cost) / NULLIF(price, 0) * 100, 2) AS profit_margin_pct,
  CAST(price - cost AS DECIMAL(10,2)) AS profit_per_unit,
  sku,
  CAST(in_stock AS BOOLEAN) AS in_stock,
  _ingested_at,
  -- Data quality validation
  CASE
    WHEN product_id IS NULL THEN 'MISSING_ID'
    WHEN price <= 0 THEN 'INVALID_PRICE'
    WHEN cost < 0 THEN 'INVALID_COST'
    WHEN price < cost THEN 'NEGATIVE_MARGIN'
    ELSE 'VALID'
  END AS data_quality_status
FROM STREAM(bronze_products)
WHERE product_id IS NOT NULL
  AND price > 0
;
