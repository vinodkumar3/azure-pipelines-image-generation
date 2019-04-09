Login-AzureRmAccount

$SubscriptionId = "b7a1d774-113d-4364-82af-75ce6919ef88"
Set-AzureRmContext -SubscriptionId $SubscriptionId

$ServicePrincipalClientSecret = $env:UserName + [System.GUID]::NewGuid().ToString().ToUpper();
$spDisplayName = [System.GUID]::NewGuid().ToString().ToUpper()

$sp = New-AzureRmADServicePrincipal -DisplayName $spDisplayName -Password (ConvertTo-SecureString $ServicePrincipalClientSecret -AsPlainText -Force)

Sleep 60

New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ApplicationId
$sub = Get-AzureRmSubscription -SubscriptionId $SubscriptionId

Write-Host $sub.TenantId # tenantId
Write-Host $sp.ApplicationId # client Id
Write-Host $ServicePrincipalClientSecret # client secret
Write-Host $sp.Id # object Id
