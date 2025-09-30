# Azure Deployment Guide for Kootumb

This guide will help you deploy the Kootumb social media platform to Azure using containerization and automated CI/CD pipelines.

## Prerequisites

1. **Azure Account**: Ensure you have an active Azure subscription
2. **Azure CLI**: Install Azure CLI on your local machine
3. **Docker**: Install Docker for local testing
4. **GitHub Repository**: Your code should be in a GitHub repository

## Deployment Options

### Option 1: Azure Container Instances (Simple)

Use the provided `azure-container-instances.yml` file for quick deployment:

```bash
# Run the deployment script
./azure-deployment.sh
```

### Option 2: Azure Web Apps (Recommended for Production)

Follow these steps for a full production deployment:

#### Step 1: Create Azure Resources

```bash
# Login to Azure
az login

# Create resource group
az group create --name kootumb-rg --location "East US"

# Create container registry
az acr create --resource-group kootumb-rg --name kootumbregistry --sku Basic --admin-enabled true

# Create MySQL server
az mysql flexible-server create \
  --resource-group kootumb-rg \
  --name kootumb-mysql-server \
  --admin-user kootumbadmin \
  --admin-password YourSecurePassword123! \
  --sku-name Standard_B1ms \
  --version 8.0.21

# Create database
az mysql flexible-server db create \
  --resource-group kootumb-rg \
  --server-name kootumb-mysql-server \
  --database-name kootumb_db

# Create App Service Plan
az appservice plan create \
  --name kootumb-plan \
  --resource-group kootumb-rg \
  --sku B1 \
  --is-linux

# Create Web App
az webapp create \
  --resource-group kootumb-rg \
  --plan kootumb-plan \
  --name kootumb-backend \
  --deployment-container-image-name nginx
```

#### Step 2: Configure GitHub Secrets

Add these secrets to your GitHub repository:

1. Go to GitHub Repository → Settings → Secrets and variables → Actions
2. Add the following secrets:

```
AZURE_REGISTRY_USERNAME: [Get from Azure Container Registry]
AZURE_REGISTRY_PASSWORD: [Get from Azure Container Registry]
AZURE_WEBAPP_PUBLISH_PROFILE: [Download from Azure Web App]
```

To get the registry credentials:
```bash
az acr credential show --name kootumbregistry --resource-group kootumb-rg
```

To get the publish profile:
```bash
az webapp deployment list-publishing-profiles --name kootumb-backend --resource-group kootumb-rg --xml
```

#### Step 3: Configure Web App Settings

```bash
# Configure container settings
az webapp config container set \
  --name kootumb-backend \
  --resource-group kootumb-rg \
  --container-image-name kootumbregistry.azurecr.io/kootumb-backend:latest \
  --container-registry-url https://kootumbregistry.azurecr.io \
  --container-registry-user [registry-username] \
  --container-registry-password [registry-password]

# Set application settings
az webapp config appsettings set \
  --name kootumb-backend \
  --resource-group kootumb-rg \
  --settings \
    DJANGO_SETTINGS_MODULE=kongo.settings \
    DEBUG=False \
    SECRET_KEY="your-production-secret-key" \
    DATABASE_URL="mysql://kootumbadmin:YourSecurePassword123!@kootumb-mysql-server.mysql.database.azure.com:3306/kootumb_db" \
    ALLOWED_HOSTS="kootumb-backend.azurewebsites.net,localhost,127.0.0.1" \
    CORS_ALLOWED_ORIGINS="https://your-frontend-domain.com"
```

#### Step 4: Deploy Using GitHub Actions

1. Push your code to the main branch
2. The GitHub Actions workflow will automatically:
   - Run tests
   - Build Docker image
   - Push to Azure Container Registry
   - Deploy to Azure Web App
   - Run database migrations

## Local Testing

Test your deployment locally using Docker Compose:

```bash
# Build and run locally
docker-compose up --build

# Access the application
curl http://localhost:8000/health/
```

## Environment Variables

Configure these environment variables in Azure:

| Variable | Description | Example |
|----------|-------------|---------|
| `SECRET_KEY` | Django secret key | `your-secret-key` |
| `DEBUG` | Debug mode | `False` |
| `DATABASE_URL` | MySQL connection string | `mysql://user:pass@host:3306/db` |
| `ALLOWED_HOSTS` | Allowed hostnames | `yourdomain.com,localhost` |
| `CORS_ALLOWED_ORIGINS` | CORS origins | `https://yourfrontend.com` |

## Frontend Configuration

Update your Flutter app to connect to the Azure backend:

```dart
// In your Flutter app configuration
const String baseUrl = 'https://kootumb-backend.azurewebsites.net';
```

## Monitoring and Logs

View application logs:
```bash
az webapp log tail --name kootumb-backend --resource-group kootumb-rg
```

## Scaling

Scale your application:
```bash
az appservice plan update --name kootumb-plan --resource-group kootumb-rg --sku S1
```

## Troubleshooting

1. **Container fails to start**: Check logs and ensure all environment variables are set
2. **Database connection issues**: Verify MySQL server settings and connection string
3. **CORS issues**: Update CORS_ALLOWED_ORIGINS with your frontend domain

## Security Considerations

1. Use Azure Key Vault for secrets
2. Enable HTTPS only
3. Configure proper firewall rules for MySQL
4. Use managed identity for secure connections

## Cost Optimization

1. Use Azure Container Instances for development
2. Scale down during non-peak hours
3. Use Basic tier for development environments
4. Monitor usage with Azure Cost Management

## Next Steps

1. Set up SSL certificates
2. Configure custom domain
3. Set up monitoring and alerts
4. Implement backup strategies
5. Set up staging environment
