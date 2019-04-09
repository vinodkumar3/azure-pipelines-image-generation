param(
[String]$SubscriptionId,
[String]$AzureLocation,
[String]$ResourceGroupName,
[String]$StorageAccountName
)

Set-AzureRmContext -SubscriptionId $SubscriptionId

$resourceGroupExists = $true;
try
{
    Get-AzureRmResourceGroup -Name $ResourceGroupName
    $resourceGroupExists = $true
    Write-Verbose "Resource group was found, will delete and recreate it."
}
catch 
{
    Write-Verbose "Resource group was not found, will create it."
    $resourceGroupExists = $false;
}

if ($resourceGroupExists) 
{
    # Cleanup the resource group if it already exitsted before
    Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force
}

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $AzureLocation
New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName -Location $AzureLocation -SkuName "Standard_LRS"

$ResourceGroupKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName).Value[0]

Write-Host "##vso[task.setvariable variable=SourceStorageAccountName] $ResourceGroupName"
Write-Host "##vso[task.setvariable variable=SourceStorageAccountKey] $ResourceGroupKey"
