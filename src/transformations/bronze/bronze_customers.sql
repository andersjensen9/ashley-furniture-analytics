-- Bronze: Ingest raw customer data from volume with streaming
CREATE OR REFRESH STREAMING TABLE bronze_customers
CLUSTER BY (customer_id)
COMMENT "Raw customer data with metadata"
AS
SELECT
  *,
  current_timestamp() AS _ingested_at,
  _metadata.file_path AS _source_file,
  _metadata.file_modification_time AS _source_modified_at
FROM cloud_files(
  '/Volumes/andersjensen_fevm_1_catalog/ashley_furniture_sdp/raw_data/customers/',
  'json'
);
