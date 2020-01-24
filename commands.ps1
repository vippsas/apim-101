$SubscriptionId = "f8fd3f8e-49d5-4c8e-8d21-f7e0bbbde0df"
$TenantId = "805bc25d-8e64-4ed6-8d24-3883c9068c5a"

$Name = "VIPPSAT2api04"

Connect-AzAccount -SubscriptionId $SubscriptionId -Tenant $TenantId

$LoggedInUser = (Get-AzContext).Account.Id
$Location = "West Europe"

$ResourceGroupName = "VIPPS-AT2-rg"
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Tag @{Owner=$LoggedInUser; Deletable="Anytime"; Reason="APIM 101 Session"}

$apimContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $Name


New-AzApiManagement -ResourceGroupName $ResourceGroupName -Name $Name -Sku "Consumption" -Location $Location -Organization "MyOrganization" -AdminEmail $LoggedInUser
$apimContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $Name

$SwaggerfileUrl = "https://conferenceapi.azurewebsites.net?format=json"
Import-AzApiManagementApi -Context $apimContext -SpecificationFormat "Swagger" -SpecificationUrl $SwaggerfileUrl -Path $Path -ApiId $ApiId

# ----------------------------------------------
Get-AzApiManagementProduct -Context $apimContext | select -exp ProductId

Get-AzApiManagementPolicy -Context $apimContext -ProductId $product

foreach($product in $products) { Get-AzApiManagementPolicy -Context $apimContext -ProductId $product -SaveAs "policies/prod/$product.xml" }

# --------

for file in $files; do md5_uat=$(md5 uat/$file | cut -d "=" -f 2 | awk '{$1=$1};1'); md5_prod=$(md5 prod/$file | cut -d "=" -f 2 | awk '{$1=$1};1'); if [[ "$md5_uat" != "$md5_prod" ]]; then echo $file; fi; done

for file in $files; do content=$(sed -n '/<inbound>/,/<\/inbound>/p' uat/$file); if [ -n "$content" ]; then echo $content > inbound/$file; fi; done
for file in $files; do content=$(sed -n '/<outbound>/,/<\/outbound>/p' uat/$file); if [ -n "$content" ]; then echo $content > outbound/$file; fi; done

for file in $(ls inbound); do content2=$(sed -n '/<log-to-eventhub/,/<\/log-to-eventhub>/p' inbound/$file); if [ -n "$content2" ]; then echo $content2 > log-to-eventhub-inbound/$file; fi; done

for file in $(ls outbound); do content3=$(sed -n '/<log-to-eventhub/,/<\/log-to-eventhub>/p' outbound/$file); if [ -n "$content3" ]; then echo $content3 > log-to-eventhub-outbound/$file; fi; done