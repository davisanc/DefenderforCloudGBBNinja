### ---------------------------------------------------------------------------------
### ASC Alert simulation for Azure VM - Using Extensions
### ---------------------------------------------------------------------------------

# ::::::::::::::::::::::::::::::::::::::::::::::
#  Type: Detection 
#  Description: AntiMalware - exclusion trigger
# ::::::::::::::::::::::::::::::::::::::::::::::

Param([switch] $Force)

# Check if PowerShellGet exists
if (Get-Module -ListAvailable -Name PowerShellGet) {
    Write-Host "PowerShellGet Module exists"
} 
else {
    if ($PSBoundParameters.ContainsKey('Force')) {
        Install-Module -Name PowerShellGet -Force
    }
    else {
        Write-Warning -Message ('PowerShellGet Not Found. Please use the -force flag to install PowerShellGet and Azure Powershell')
        Exit
    }
}

# Install Azure Powershell
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported. Use the -force flag to install the necessary modules.')
    Exit

} elseif($PSBoundParameters.ContainsKey('Force')) {
    Install-Module -Name Az -AllowClobber -Scope CurrentUser

} elseif (!(Get-Module -Name Az.Compute -ListAvailable)) {
    Write-Warning -Message ('Azure Powershell Not Found. Please use the -force flag to install Azure Powershell')
    Exit
}

# Login User
Connect-AzAccount

# Select Subscription
$Subscription = Get-AzSubscription | out-gridview -Title "Select a subscription" -PassThru
Select-AzSubscription $Subscription

# Settings to exclude a binary
$SettingsEx = '{"AntimalwareEnabled" : "true", "Exclusions" : {"Extensions" : "", "Paths" : "", "Processes" : "NinjaGBB.txt"},
          "RealtimeProtectionEnabled" : "true", "ScheduledScanSettings" : {"isEnabled": "true", "scanType" : "Quick", "day" : "7", "time" : "100" }}'

# Settings to remove the exclusion
$SettingsRemoveEx = '{"AntimalwareEnabled" : "true", "Exclusions" : {"Extensions" : "", "Paths" : "", "Processes" : ""},
          "RealtimeProtectionEnabled" : "true", "ScheduledScanSettings" : {"isEnabled": "true", "scanType" : "Quick", "day" : "7", "time" : "100" }}'

# Provide VM info
$VMObject = Get-AzVM | out-gridview -Title "Select a VM" -PassThru
$VMName = $VMObject.Name
$Loc = $VMObject.Location
$ResourceGroup = $VMObject.ResourceGroupName

Write-Host "Excluding binary ..."

# Exclude the binary
Set-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name "IaasAntimalware" -Location $Loc -Publisher "Microsoft.Azure.Security" -Type "IaasAntimalware" -TypeHandlerVersion "1.3" -SettingString $SettingsEx

# Write-Host "Removing the exclusion ..."

# # Remove the exclusion
# Set-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name "IaasAntimalware" -Location $Loc -Publisher "Microsoft.Azure.Security" -Type "IaasAntimalware" -TypeHandlerVersion "1.3" -SettingString $SettingsRemoveEx


# ::::::::::::::::::::::::::::::::::::::::::::::
# 				Power Shell AM
#  Type: Validation
#  Description: AntiMalware - exclusion trigger
# ::::::::::::::::::::::::::::::::::::::::::::::

# Provide VM info
$VMObject = Get-AzVM | out-gridview -Title "Select a VM" -PassThru
$VMName = $VMObject.Name
$Loc = $VMObject.Location
$ResourceGroup = $VMObject.ResourceGroupName

# Verify VM Extension Properties
Get-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name "IaasAntimalware"

# Cannot verify the settings (Tamper Protetion)
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
# Download EICAR Test file with NinjaGBB.txt name?