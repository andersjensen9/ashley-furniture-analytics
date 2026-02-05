# Ashley Furniture Analytics - Databricks Asset Bundle

A production-ready medallion architecture for Ashley Furniture retail analytics, built with Spark Declarative Pipelines and deployed via Databricks Asset Bundles.

## Architecture

### 🥉 Bronze Layer (Raw Ingestion)
- `bronze_stores` - 30 retail locations with Auto Loader
- `bronze_products` - 200 furniture products
- `bronze_customers` - 8,000 customers
- `bronze_sales` - 50,000 transactions

### 🥈 Silver Layer (Cleaned & Enriched)
- Data quality validations
- Type casting and standardization
- Calculated fields (profit margins, customer tenure, date parts)
- Invalid record filtering

### 🥇 Gold Layer (Business Aggregations)
- Daily sales metrics
- Category performance
- Regional analysis
- Customer RFM segmentation
- Product performance KPIs

## Quick Start

### Prerequisites
- Databricks CLI installed
- Databricks workspace access
- Unity Catalog enabled

### Local Development

```bash
# Validate the bundle
databricks bundle validate

# Deploy to dev
databricks bundle deploy --target dev

# Run the pipeline
databricks bundle run ashley_furniture_medallion
```

### Multi-Environment Deployment

```bash
# Deploy to staging
databricks bundle deploy --target staging

# Deploy to production (requires approval in prod mode)
databricks bundle deploy --target prod
```

## Environments

| Environment | Catalog | Schema | Mode | Auto-Deploy |
|-------------|---------|--------|------|-------------|
| **dev** | andersjensen_fevm_1_catalog | ashley_furniture_sdp_dev | development | ✅ On PR merge |
| **staging** | andersjensen_fevm_1_catalog | ashley_furniture_sdp_staging | development | ⏸️ Manual |
| **prod** | andersjensen_fevm_1_catalog | ashley_furniture_sdp_prod | production | ⏸️ Manual + Approval |

## CI/CD Pipeline

### On Pull Request
- Bundle validation
- SQL syntax checking
- Schema compatibility checks

### On Merge to Main
- Auto-deploy to dev
- Run integration tests
- Tag for staging/prod deployment

### Production Deployment
- Manual trigger via Git tag
- Requires approval
- Automatic rollback on failure

## Project Structure

```
ashley_furniture_pipeline/
├── databricks.yml              # Bundle configuration
├── resources/
│   └── pipeline.yml            # Pipeline resource definition
├── src/
│   └── transformations/
│       ├── bronze/             # Raw ingestion (4 tables)
│       ├── silver/             # Cleaned data (4 tables)
│       └── gold/               # Aggregations (5 views)
├── .github/
│   └── workflows/
│       ├── ci.yml              # PR validation
│       └── deploy.yml          # Deployment automation
└── README.md                   # This file
```

## Data Volume

- **Bronze**: 58,230 raw records
- **Silver**: ~58,000 validated records
- **Gold**: 5 aggregation views
- **Time Range**: 12 months of data
- **Total Revenue**: ~$35M

## Key Features

- ✅ Serverless compute (auto-scaling)
- ✅ Liquid Clustering (modern partitioning)
- ✅ Data quality validations
- ✅ Streaming ingestion with Auto Loader
- ✅ Materialized views (auto-refresh)
- ✅ Multi-environment support
- ✅ CI/CD with GitHub Actions
- ✅ Full lineage tracking

## Commands Reference

```bash
# Validate configuration
databricks bundle validate --target dev

# Deploy without running
databricks bundle deploy --target dev

# Deploy and run
databricks bundle deploy --target dev
databricks bundle run ashley_furniture_medallion

# Check deployment status
databricks bundle summary

# Destroy resources
databricks bundle destroy --target dev
```

## Monitoring

View pipeline runs:
- Dev: https://fevm-andersjensen-fevm-1.cloud.databricks.com/pipelines/
- Monitor via Databricks UI or CLI
- Check data quality metrics in gold layer

## Contributing

1. Create feature branch
2. Make changes to transformations
3. Run `databricks bundle validate`
4. Create pull request
5. Merge after approval
6. Auto-deploys to dev

## Support

For issues or questions:
- Check pipeline logs in Databricks UI
- Review GitHub Actions workflow logs
- Validate bundle configuration locally

## CI/CD Test

This change tests the GitHub Actions workflow.
