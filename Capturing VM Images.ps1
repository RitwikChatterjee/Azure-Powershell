<#
.SYNOPSIS

Captures VM Image of a given VM and Service Name

.DESCRIPTION

Captures VM Image of a given VM and Service Name. It accepts the Service Name and VM Name of the VM you wish to capture image for. It also captures an image name and image label. 
It appends SP or GN to the image name based on whether it is specialized or generalized image.

#>



# Variable Declaration for image capture

$serviceName_toCapture = "ritwik-devbox51"
$vmName_toCapture = "ritwik-devbox51"
$imageName_Captured = "ritwik-devbox51Image"
$imageLabel_Captured = "ritwik-devbox51 image. No changes on top of ritwikdevimageA320150624."

#  Internal Assumption Variables
$imageName_Captured_Specialized = $imageName_Captured + "-SP"
$imageName_Captured_Generalized = $imageName_Captured + "-GN"
$imageLabel_Captured_Specialized = $imageLabel_Captured + " - Specialized"
$imageLabel_Captured_Generalized = $imageLabel_Captured + " - Generalized"

do {
    $confirmIntention = Read-Host "Do you want to proceed with capturing VM image for " $vmName_toCapture "? (Y). Press Ctrl+C to quit."

} while ($confirmIntention -ne "Y")


$whetherCaptureSPImage = "reset"
while ($whetherCaptureSPImage -ne "Y" -and $whetherCaptureSPImage -ne "N")
{
    $whetherCaptureSPImage = Read-Host "Do you want to capture a Specialized Image? (Y/N)"
}

    Write-Host "Stopping the VM."
    Stop-AzureVM –ServiceName $serviceName_toCapture -Name $vmName_toCapture


if($whetherCaptureSPImage -eq "Y") 
{
    <#
    If you want to capture a virtual machine that you can use more like a checkpoint than a template, you can capture the image as a specialized image instead. This preserves server configuration like admin user credentials.
    This type of image is useful if you want to keep a copy of the virtual machine’s disks before you perform a task that might render the virtual machine useless. 
    In that case, you could use the image to redeploy the virtual machine.
    Note: It is a good practice to stop the vm before performing this operation.
    #>

    Write-Host "Capturing Specialized Image with modified Image Name = " $imageName_Captured_Specialized
    
    Save-AzureVMImage –ServiceName $serviceName_toCapture –Name $vmName_toCapture –ImageName $imageName_Captured_Specialized –OSState "Specialized" -ImageLabel $imageLabel_Captured_Specialized -Verbose

    Write-Host "Specialized Image capture successful. Starting up the VM."
    Start-AzureVM -ServiceName $serviceName_toCapture -Name $vmName_toCapture
}
else
{

    <#
    This captures an existing virtual machine named ‘MyVMToCapture’ as a generalized VM image named MyVMImage. 
    This creates an image you can use repeatedly, like a template, to deploy multiple instances of a virtual machine with the same disk configuration and run them at the same time. 
    Note: You must stop or Stop-deallocate the VM before performing this operation
    #>

    Write-Host "Capturing Generalized Image with modified Image Name = " $imageName_Captured_Generalized

    Save-AzureVMImage –ServiceName $serviceName_toCapture –Name $vmName_toCapture –ImageName $imageName_Captured_Generalized –OSState "Generalized" -ImageLabel $imageLabel_Captured_Generalized -Verbose


    Write-Host "Generalized Image capture successful. Checking Service."

    if ((Get-AzureVM -ServiceName $serviceName_toCapture) -eq $null)
    {
        Write-Host "There are no more VMs in the Cloud Service " $serviceName_toCapture

        $whetherDelCloudService = "reset"
        while ($whetherDelCloudService -ne "Y" -and $whetherDelCloudService -ne "N" )
        {
            $whetherDelCloudService = Read-Host "Do you want to delete the cloud service as well?"
        }
        
        Write-Host "TODO"
    }
    else
    {
        Write-Host "Other VMs detected in the Cloud Service"
    }

}


# Fetches the latest images created by user

Get-AzureVMImage | where {$_.Category -eq "User"} | Select -Property ImageName, Label, ModifiedTime | sort -Property ModifiedTime -Descending

# To remove an image

$imageName_toRemove = ""
#Remove-AzureVMImage –ImageName $imageName_toRemove


