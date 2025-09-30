# Azure Web App for Containers configuration
# Deploy this using Azure CLI or Azure Portal

# Resource Group
RESOURCE_GROUP="kootumb-rg"
LOCATION="East US"

# App Service Plan
APP_SERVICE_PLAN="kootumb-plan"
SKU="B1"  # Basic tier, upgrade to S1 or P1V2 for production

# Web App
WEB_APP_NAME="kootumb-backend"
CONTAINER_REGISTRY="kootumbregistry.azurecr.io"
CONTAINER_IMAGE="kootumb-backend:latest"

# Database (Azure Database for MySQL)
MYSQL_SERVER_NAME="kootumb-mysql-server"
MYSQL_ADMIN_USER="kootumb_admin"
MYSQL_ADMIN_PASSWORD="YourSecurePassword123!"
MYSQL_DATABASE="kootumb_db"

# Storage Account
STORAGE_ACCOUNT="kootumbstorage"

# Environment Variables for Web App
APP_SETTINGS=(
    "DEBUG=False"
    "ALLOWED_HOSTS=$WEB_APP_NAME.azurewebsites.net,localhost"
    "DATABASE_URL=mysql://$MYSQL_ADMIN_USER:$MYSQL_ADMIN_PASSWORD@$MYSQL_SERVER_NAME.mysql.database.azure.com:3306/$MYSQL_DATABASE?ssl_mode=REQUIRED"
    "SECRET_KEY=your-very-secure-secret-key-change-this"
    "CORS_ALLOW_ALL_ORIGINS=True"
    "AZURE_STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT"
    "AZURE_STORAGE_ACCOUNT_KEY=your-storage-account-key"
)

# Deployment Commands (run these in Azure CLI)
echo "Creating Azure resources for Kootumb deployment..."
echo "Run these commands in Azure CLI:"
echo ""
echo "# 1. Create Resource Group"
echo "az group create --name $RESOURCE_GROUP --location '$LOCATION'"
echo ""
echo "# 2. Create App Service Plan"
echo "az appservice plan create --name $APP_SERVICE_PLAN --resource-group $RESOURCE_GROUP --sku $SKU --is-linux"
echo ""
echo "# 3. Create Container Registry"
echo "az acr create --resource-group $RESOURCE_GROUP --name kootumbregistry --sku Basic --admin-enabled true"
echo ""
echo "# 4. Create MySQL Server"
echo "az mysql server create --resource-group $RESOURCE_GROUP --name $MYSQL_SERVER_NAME --admin-user $MYSQL_ADMIN_USER --admin-password '$MYSQL_ADMIN_PASSWORD' --sku-name B_Gen5_1 --version 8.0"
echo ""
echo "# 5. Create MySQL Database"
echo "az mysql db create --resource-group $RESOURCE_GROUP --server-name $MYSQL_SERVER_NAME --name $MYSQL_DATABASE"
echo ""
echo "# 6. Create Storage Account"
echo "az storage account create --name $STORAGE_ACCOUNT --resource-group $RESOURCE_GROUP --location '$LOCATION' --sku Standard_LRS"
echo ""
echo "# 7. Create Web App"
echo "az webapp create --resource-group $RESOURCE_GROUP --plan $APP_SERVICE_PLAN --name $WEB_APP_NAME --deployment-container-image-name $CONTAINER_REGISTRY/$CONTAINER_IMAGE"
