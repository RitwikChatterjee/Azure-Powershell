<#
.SYNOPSIS

Creates a VM from a specified custom image

.DESCRIPTION

Creates a VM of the specified size at the specified location from a previous captured custom image. 
It requests confirmation whether this is a specialized script. If not, requires admin user and password to be specified.

#>


# Variable Declaration for new VM Creation
$vmName_toCreate = "ritwik-devbox53"
$svcName_toCreate = "ritwik-devbox53"
$imageName_toReplicate = "ritwik-devbox51Image-GN"
$location_toCreate = "West US"
$storageAccount_toUse = "ritwikstorage"
$instanceSize_toCreate = "Basic_A1"


# Check if current storage account is same as the storage account to use

$currentSubscription = (Get-AzureSubscription)[0]
$currentSubscriptionName = $currentSubscription.SubscriptionName

$currentStorageAccountName = $currentSubscription.CurrentStorageAccountName

if ($currentStorageAccountName -ne $storageAccount_toUse) 
{
    Write-Host "Changing the Current Storage Account to the correct storage account..."
    Set-AzureSubscription -SubscriptionName $currentSubscriptionName -CurrentStorageAccountName $storageAccount_toUse   
}

do {
    $confirmIntention = Read-Host "Do you want to proceed with Creating a new VM " $vmName_toCreate " from image " $imageName_toReplicate "? (Y). Press Ctrl+C to quit."

} while ($confirmIntention -ne "Y")


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


