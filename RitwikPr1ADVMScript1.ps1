$subscription = Get-AzureSubscription
$subcriptionname = $subscription.SubscriptionName

$image = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201408.01-en.us-127GB.vhd"
$location = "West US"
$vmname = "ritwikpr1vnetvm1"
$cloudservicename = "ritwikpr1vnetsvc"
$vnetname = "ritwikpr1vnet"
$agname = "ritwikpr1ag2"
$subnet = "Subnet-AD"
$avset = "ritwikpr1avs2"
$domain = "ritwik.dell.com"

$credential = Get-Credential -Message "Enter User Credentials"

$username = $credential.UserName
$pwd = $credential.GetNetworkCredential().Password

New-AzureVMConfig -Name $vmname -InstanceSize small -ImageName $image -AvailabilitySetName $avset |
    Add-AzureProvisioningConfig -AdminUsername $username -Password $pwd |
    Set-AzureOSDisk -HostCaching ReadOnly | 
    New-AzureVM -ServiceName $cloudservicename -AffinityGroup $agname -VNetName $vnetname -WaitForBoot


. $PSScriptRoot\InstallWinRMCertAzureVM.ps1 -SubscriptionName $subcriptionname -ServiceName $cloudservicename -Name $vmname

$connectionuri = Get-AzureWinRMUri -ServiceName $cloudservicename -Name $vmname

Invoke-Command 