-- Bronze: Ingest raw sales transaction data from volume with streaming
CREATE OR REFRESH STREAMING TABLE bronze_sales
CLUSTER BY (sale_date, store_id)
COMMENT "Raw sales transactions with metadata"
AS
SELECT
  *,
  current_timestamp() AS _ingested_at,
  _metadata.file_path AS _source_file,
  _metadata.file_modification_time AS _source_modified_at
FROM cloud_files(
  '/Volumes/andersjensen_fevm_1_catalog/ashley_furniture_sdp/raw_data/sales/',
  'json'
);
