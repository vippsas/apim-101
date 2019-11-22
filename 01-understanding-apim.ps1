#Requires -Version 3.0

<#
.SYNOPSIS
TenantId of where API Management will be created
.PARAMETER TenantId
SubscriptionId of where API Management will be created
.PARAMETER SubscriptionId
Resource Group to be created or updated where API Management will be created
.PARAMETER ResourceGroupName
Name of the API Management instance
.PARAMETER Name
If resource Group and its content shall be deleted. Default is $false
.PARAMETER Delete
#>
Param(
  [string] [Parameter(Mandatory = $true)] $TenantId,
  [string] [Parameter(Mandatory = $true)] $SubscriptionId,
  [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
  [string] [Parameter(Mandatory = $true)] $Name,
  [bool] [Parameter(Mandatory = $false)] $Delete = $false
)

###################################################################################################
#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = "Stop"

# Hide any progress bars, due to downloads and installs of remote components.
$ProgressPreference = "SilentlyContinue"

# Ensure we set the working directory to that of the script.
Push-Location $PSScriptRoot

# Discard any collected errors from a previous execution.
$Error.Clear()

# Configure strict debugging.
Set-PSDebug -Strict

$DebugPreference="Continue"

Set-StrictMode -Version 3

###################################################################################################
#
# Handle all errors in this script.
#

trap {
    # NOTE: This trap will handle all errors. There should be no need to use a catch below in this
    #       script, unless you want to ignore a specific error.
    $message = $Error[0].Exception.Message
    if ($message) {
        Write-Host -Object "`nERROR: $message" -ForegroundColor Red
    }

    Write-Host "`nThe script failed to run.`n"

    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}

try {
  [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(' ', '_'), '3.0.0')
}
catch { }

# Connecting to tenant/account
##Connect-AzAccount -SubscriptionId $SubscriptionId -Tenant $TenantId
$LoggedInUser = (Get-AzContext).Account.Id
$Location = "West Europe"

# Delete resources
if ($Delete) {
  Write-Host -ForegroundColor Green "Deleting resources."
  Remove-AzResourceGroup -Name $ResourceGroupName
  EXIT 0
}

# Create new resource group with meaningful tags
Write-Host -ForegroundColor Green "Creating Resource Group."
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{Owner=$LoggedInUser; Deletable="Anytime"; Reason="APIM 101 Session"}

# Create API Management instance in the background since the cmdlet takes a while to return.
Write-Host -ForegroundColor Green "Provisioning API Management instance ... takes some minutes."
New-AzApiManagement -ResourceGroupName $ResourceGroupName -Name $Name -Sku "Consumption" -Location $Location -Organization "MyOrganization" -AdminEmail $LoggedInUser

# Creating API Manegement Context
$apimContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $Name

# Deploy petstore swagger file
Write-Host -ForegroundColor Green "Applying Petstore swagger specification to API Management instance."
$ApiId = "PetstoreAPI"
$Path = "petstore"
$SwaggerfileUrl = "https://conferenceapi.azurewebsites.net?format=json"
Import-AzApiManagementApi -Context $apimContext -SpecificationFormat "Swagger" -SpecificationUrl $SwaggerfileUrl -Path $Path -ApiId $ApiId
