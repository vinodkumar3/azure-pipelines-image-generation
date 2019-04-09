param(
[String]$SourceStorageAccountName,
[String]$SourceStorageAccountKey,
[String]$TargetStorageAccountName,
[String]$TargetStorageAccountKey,
[String]$AbsoluteUri,
[String]$DestContainer,
[String]$DestBlob
)

Install-Module -Name AzureRM -AllowClobber

$SourceContext = New-AzureStorageContext -StorageAccountName $SourceStorageAccountName -StorageAccountKey $SourceStorageAccountKey
$DestContext = New-AzureStorageContext -StorageAccountName $TargetStorageAccountName -StorageAccountKey $TargetStorageAccountKey
Start-CopyAzureStorageBlob -AbsoluteUri $AbsoluteUri -Context $SourceContext -DestContext $DestContext -DestContainer $DestContainer -DestBlob $DestBlob

#optional statement just to get the status of copy
#Get-AzureStorageBlobCopyState -Blob MMS.M149.VS2019.2.vhd -Container vhds -Context $targetContext
