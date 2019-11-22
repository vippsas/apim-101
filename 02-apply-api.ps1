#Requires -Version 3.0

Param(
    [string] [Parameter(Mandatory = $true)] $ServiceName,
    [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
    [string] [Parameter(Mandatory = $true)] $ApiId,
    [string] [Parameter(Mandatory = $true)] $Path,
    [string] [Parameter(Mandatory = $false)] $SwaggerFile = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/master/examples/v3.0/petstore.yaml"
)

$DebugPreference = "Continue"
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3

try {
  [Microsoft.Azure.Common.Authentication.AzureSession]::ClientFactory.AddUserAgent("VSAzureTools-$UI$($host.name)".replace(' ', '_'), '3.0.0')
}
catch { }

$apimContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName

# Deploy petstore swagger file
Import-AzApiManagementApi -Context $apimContext -SpecificationFormat "Swagger" -SpecificationPath $SwaggerFile -Path $Path -ApiId $ApiId  

Write-Host -ForegroundColor Green "Api applied."