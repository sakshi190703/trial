# Deploy using Azure Resource Manager Template

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$Location,
    
    [Parameter(Mandatory=$true)]
    [SecureString]$MySqlAdminPassword,
    
    [Parameter(Mandatory=$false)]
    [string]$SiteName = "kootumb-backend",
    
    [Parameter(Mandatory=$false)]
    [string]$Sku = "B1"
)

# Login to Azure (if not already logged in)
Write-Host "Checking Azure login status..."
$context = Get-AzContext
if (-not $context) {
    Write-Host "Please login to Azure..."
    Connect-AzAccount
}

# Create resource group if it doesn't exist
Write-Host "Creating resource group: $ResourceGroupName"
$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if (-not $rg) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    Write-Host "Resource group created successfully"
} else {
    Write-Host "Resource group already exists"
}

# Deploy ARM template
Write-Host "Deploying Azure resources..."
$templateFile = "azure-template.json"

$deploymentParameters = @{
    siteName = $SiteName
    location = $Location
    sku = $Sku
    mysqlAdminPassword = $MySqlAdminPassword
}

try {
    $deployment = New-AzResourceGroupDeployment `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $templateFile `
        -TemplateParameterObject $deploymentParameters `
        -Verbose

    Write-Host "Deployment completed successfully!" -ForegroundColor Green
    Write-Host "Site URL: $($deployment.Outputs.siteUrl.Value)" -ForegroundColor Cyan
    Write-Host "Container Registry: $($deployment.Outputs.containerRegistryLoginServer.Value)" -ForegroundColor Cyan
    Write-Host "MySQL Server: $($deployment.Outputs.mysqlServerName.Value)" -ForegroundColor Cyan
    
} catch {
    Write-Error "Deployment failed: $($_.Exception.Message)"
    exit 1
}

Write-Host "Setup completed! Next steps:" -ForegroundColor Yellow
Write-Host "1. Push your Docker image to the container registry"
Write-Host "2. Configure GitHub Actions secrets"
Write-Host "3. Push code to trigger deployment"
