-- Silver: Cleaned sales data with enriched transaction details
CREATE OR REFRESH STREAMING TABLE silver_sales
CLUSTER BY (sale_date, store_id)
COMMENT "Cleaned sales transactions with calculated metrics and validations"
AS
SELECT
  sale_id,
  CAST(sale_timestamp AS TIMESTAMP) AS sale_timestamp,
  CAST(sale_date AS DATE) AS sale_date,
  -- Extract date parts for analytics
  YEAR(CAST(sale_date AS DATE)) AS sale_year,
  MONTH(CAST(sale_date AS DATE)) AS sale_month,
  DAYOFWEEK(CAST(sale_date AS DATE)) AS sale_day_of_week,
  CASE WHEN DAYOFWEEK(CAST(sale_date AS DATE)) IN (1,7) THEN TRUE ELSE FALSE END AS is_weekend,
  store_id,
  customer_id,
  product_id,
  CAST(quantity AS INT) AS quantity,
  CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
  CAST(subtotal AS DECIMAL(10,2)) AS subtotal,
  CAST(discount_amount AS DECIMAL(10,2)) AS discount_amount,
  CAST(discount_pct AS DECIMAL(5,4)) AS discount_pct,
  CAST(tax AS DECIMAL(10,2)) AS tax,
  CAST(total AS DECIMAL(10,2)) AS total,
  delivery_method,
  payment_method,
  _ingested_at,
  -- Data quality validation
  CASE
    WHEN sale_id IS NULL THEN 'MISSING_ID'
    WHEN total <= 0 THEN 'INVALID_TOTAL'
    WHEN quantity <= 0 THEN 'INVALID_QUANTITY'
    WHEN discount_pct < 0 OR discount_pct > 1 THEN 'INVALID_DISCOUNT'
    ELSE 'VALID'
  END AS data_quality_status
FROM STREAM(bronze_sales)
WHERE sale_id IS NOT NULL
  AND total > 0
  AND quantity > 0
;
