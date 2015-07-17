# Variable Declaration for new VM Creation
$vmName_toCreate = "ritwik-devbox51"
$svcName_toCreate = "ritwik-devbox51"
$imageName_toReplicate = "ritwik-devbox5-pr-GN"
$location_toCreate = "West US"
$storageAccount_toUse = "ritwikstorage"
$instanceSize_toCreate = "Basic_A1"


# Check if current storage account is same as the storage account to use

$currentSubscription = (Get-AzureSubscription)[0]
$currentSubscriptionName = $currentSubscription.SubscriptionName
$currentStorageAccountName = $currentSubscription.CurrentStorageAccountName

if ($currentStorageAccountName -ne $storageAccount_toUse) 
{
    Write-Host "Setting the correct storage account..."
    Set-AzureSubscription -SubscriptionName $currentSubscriptionName -CurrentStorageAccountName $storageAccount_toUse
}


# Accept confirmation from user on type of image being used

$whetherSPImage = "reset"
while ($whetherSPImage -ne "Y" -and $whetherSPImage -ne "N")
{
    $whetherSPImage = Read-Host "Are you creating this VM from a Specialized Image? (Y/N)"
}


if ($whetherSPImage -eq "N") 
{
    # If this is NOT being created from a specialized image, accept new admin credentials

    $adminUser = Read-Host "Admin User Name "
    $adminPwd = Read-Host "Admin Password "

    Write-Host "Creating new VM from mentioned image...."    
    New-AzureQuickVM -Windows -ImageName $imageName_toReplicate -Location $location_toCreate -Name $vmName_toCreate –ServiceName $svcName_toCreate -InstanceSize $instanceSize_toCreate -AdminUserName $adminUser –Password $adminPwd

    
}
else 
{
    # If this IS being created from a specialized image, admin credentials not required
    Write-Host "Since you are using a Specialized Image, Admin credentials are the same as the VM from where the image was captured."
    Write-Host "Creating new VM from mentioned image...."    
    New-AzureQuickVM -Windows -ImageName $imageName_toReplicate -Location $location_toCreate -Name $vmName_toCreate –ServiceName $svcName_toCreate -InstanceSize $instanceSize_toCreate 
}


