-- Silver: Cleaned customer data with derived attributes
CREATE OR REFRESH STREAMING TABLE silver_customers
CLUSTER BY (segment, state)
COMMENT "Cleaned customer data with profile enrichment"
AS
SELECT
  customer_id,
  CONCAT(first_name, ' ', last_name) AS full_name,
  first_name,
  last_name,
  LOWER(email) AS email,  -- Standardize email
  phone,
  segment,
  UPPER(state) AS state,  -- Standardize state
  zip_code,
  CAST(signup_date AS DATE) AS signup_date,
  -- Calculate customer tenure in days
  DATEDIFF(CURRENT_DATE(), CAST(signup_date AS DATE)) AS tenure_days,
  -- Categorize tenure
  CASE
    WHEN DATEDIFF(CURRENT_DATE(), CAST(signup_date AS DATE)) < 90 THEN 'New'
    WHEN DATEDIFF(CURRENT_DATE(), CAST(signup_date AS DATE)) < 365 THEN 'Established'
    ELSE 'Loyal'
  END AS customer_lifecycle,
  _ingested_at,
  -- Data quality
  CASE
    WHEN customer_id IS NULL THEN 'MISSING_ID'
    WHEN email IS NULL OR NOT email LIKE '%@%' THEN 'INVALID_EMAIL'
    ELSE 'VALID'
  END AS data_quality_status
FROM STREAM(bronze_customers)
WHERE customer_id IS NOT NULL
;
