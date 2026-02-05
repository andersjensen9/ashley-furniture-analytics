-- Silver: Cleaned and validated store data
CREATE OR REFRESH STREAMING TABLE silver_stores
CLUSTER BY (region, store_type)
COMMENT "Cleaned store data with data quality validations"
AS
SELECT
  store_id,
  store_name,
  region,
  store_type,
  state,
  city,
  zip_code,
  CAST(opened_date AS DATE) AS opened_date,
  _ingested_at,
  -- Data quality flags
  CASE
    WHEN store_id IS NULL THEN 'MISSING_ID'
    WHEN store_name IS NULL THEN 'MISSING_NAME'
    WHEN region IS NULL THEN 'MISSING_REGION'
    ELSE 'VALID'
  END AS data_quality_status
FROM STREAM(bronze_stores)
WHERE store_id IS NOT NULL  -- Filter out invalid records
;
