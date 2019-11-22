#Requires -Version 3.0

Param(
  [string] [Parameter(Mandatory = $true)] $TenantId,
  [string] [Parameter(Mandatory = $true)] $SubscriptionId,
  [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
  [string] [Parameter(Mandatory = $true)] $Name,
  [bool] [Parameter(Mandatory = $false)] $Delete = $false
)

$DebugPreference="Continue"
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

try {
  [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(' ', '_'), '3.0.0')
}
catch { }

function IsInstalled {
  param (
    [string]$Module
  )
  return (Get-InstalledModule -Name $Module -ErrorAction "SilentlyContinue") -as [bool]
}

# Connecting to account
Connect-AzAccount -SubscriptionId $SubscriptionId -Tenant $TenantId
$LoggedInUser = (Get-AzContext).Account.Id
$Location = "West Europe"

# Delete resources
if ($Delete) {
  Remove-AzApiManagement -ResourceGroupName $ResourceGroupName -Name $Name
  Remove-AzResourceGroup -Name $ResourceGroupName

  Write-Host "Resources deleted."
  EXIT 0
}

# Create new resource group with tags
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{Owner=$LoggedInUser; Deletable="Anytime"; Reason="apim 101 session"}

# Create API Management instance in the background since the cmdlet takes a while to return.
Start-Job -ArgumentList $ResourceGroupName,$Name,$Location,$LoggedInUser -ScriptBlock {
  param($ResourceGroupName, $Name, $Location, $LoggedInUser)
  New-AzApiManagement -ResourceGroupName $ResourceGroupName -Name $Name -Sku "Consumption" -Location $Location -Organization "MyOrganization" -AdminEmail $LoggedInUser
  Write-Host "Provisioning API Management instance. Check in a few minutes."
}

