# GitHub Setup Guide

## Step 1: Create GitHub Repository

1. Go to https://github.com/andersjensen-dbx
2. Click "New repository"
3. **Repository name**: `ashley-furniture-analytics`
4. **Description**: `Production-ready Ashley Furniture analytics with Databricks Asset Bundles`
5. **Visibility**: Private (or Public for demo)
6. **DO NOT** initialize with README (we already have one)
7. Click "Create repository"

## Step 2: Connect Local Repo to GitHub

```bash
cd /Users/anders.jensen/ai-dev-kit/ai-dev-project/ashley_furniture_pipeline

# Add remote
git remote add origin https://github.com/andersjensen-dbx/ashley-furniture-analytics.git

# Create initial commit
git commit -m "Initial commit: Ashley Furniture Medallion Architecture

- Bronze layer: 4 streaming tables with Auto Loader
- Silver layer: 4 cleaned tables with data quality
- Gold layer: 5 business aggregation views
- Databricks Asset Bundle configuration
- GitHub Actions CI/CD workflows
- Multi-environment support (dev/staging/prod)"

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Configure GitHub Secrets

Go to: https://github.com/andersjensen-dbx/ashley-furniture-analytics/settings/secrets/actions

Add these secrets:

### Required Secrets

**DATABRICKS_HOST**
```
https://fevm-andersjensen-fevm-1.cloud.databricks.com
```

**DATABRICKS_TOKEN**
```
dapi********************************
```

**Note**: For production, create a service principal token instead of personal access token.

### Optional Secrets (for notifications)

**SLACK_WEBHOOK** (optional)
```
https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

## Step 4: Configure GitHub Environments

Go to: https://github.com/andersjensen-dbx/ashley-furniture-analytics/settings/environments

### Create Environments:

**1. dev** (No protection rules)
- Deploys automatically on push to main
- No approval required

**2. staging** (Optional protection)
- Required reviewers: 1 person
- Manual deployment only

**3. production** (Strict protection)
- Required reviewers: 2 people
- Manual deployment only
- Deployment branches: main only

## Step 5: Test the Setup

### Test Local Deployment
```bash
cd /Users/anders.jensen/ai-dev-kit/ai-dev-project/ashley_furniture_pipeline

# Validate bundle
databricks bundle validate --target dev

# Deploy locally to test
databricks bundle deploy --target dev
```

### Test GitHub Actions

1. **Create a test branch:**
```bash
git checkout -b test/ci-workflow
echo "# Test change" >> README.md
git add README.md
git commit -m "Test: trigger CI workflow"
git push origin test/ci-workflow
```

2. **Create Pull Request:**
- Go to GitHub repository
- Click "Pull requests" → "New pull request"
- Select `test/ci-workflow` → `main`
- Create pull request
- Watch CI workflow run ✅

3. **Merge to trigger deployment:**
- Merge the PR
- Watch deploy workflow run
- Check Databricks for deployed pipeline

## Step 6: Demo Flow

### Quick Iteration (No GitHub)
```bash
# Make changes locally
vim src/transformations/gold/gold_new_metric.sql

# Deploy directly
databricks bundle deploy --target dev
databricks bundle run ashley_furniture_medallion
```

### Production Flow (With GitHub)
```bash
# Make changes locally
vim src/transformations/gold/gold_new_metric.sql

# Create branch and PR
git checkout -b feature/new-metric
git add .
git commit -m "Add new gold metric"
git push origin feature/new-metric

# → Create PR on GitHub
# → CI validates
# → Merge PR
# → Auto-deploys to dev
```

## Switching Between Modes

### Mode 1: Quick Iteration (Current workflow)
- Local changes
- `databricks bundle deploy --target dev`
- Fast feedback
- No code review

### Mode 2: Production CI/CD (GitHub workflow)
- Branch → PR → Review → Merge
- Automated testing
- Environment promotion
- Full audit trail

**Both modes work!** Use Mode 1 for exploration, Mode 2 for production changes.

## Common Commands

```bash
# Check current remote
git remote -v

# See deployment status
databricks bundle summary

# Validate before pushing
databricks bundle validate --target dev

# Deploy to specific environment
databricks bundle deploy --target staging

# View GitHub Actions logs
gh run list  # if gh CLI installed
```

## Troubleshooting

### Can't push to GitHub
- Check you're authenticated: `gh auth status`
- Or use personal access token: https://github.com/settings/tokens

### CI workflow fails
- Check secrets are configured correctly
- Verify Databricks token is valid
- Check workflow logs in GitHub Actions tab

### Bundle validation fails
- Run locally first: `databricks bundle validate`
- Check databricks.yml syntax
- Verify all paths are correct

## Next Steps

After setup:
1. ✅ Validate local deployment works
2. ✅ Push to GitHub
3. ✅ Configure secrets
4. ✅ Test CI/CD workflow
5. ✅ Demo the setup to stakeholders!

## Resources

- [Databricks Asset Bundles Docs](https://docs.databricks.com/dev-tools/bundles/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Your Pipeline](https://fevm-andersjensen-fevm-1.cloud.databricks.com/pipelines/)
