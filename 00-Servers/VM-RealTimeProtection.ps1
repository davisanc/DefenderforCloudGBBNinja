﻿### ---------------------------------------------------------------------------------
### ASC Alert simulation for Azure VM - Using Extensions
### ---------------------------------------------------------------------------------

# ::::::::::::::::::::::::::::::::::::::::::::::
#  Type: Detection
#  Description: AntiMalware - runtime disable-enable trigger
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
$SettingsDisable = '{"AntimalwareEnabled" : "true", "Exclusions" : {"Extensions" : "", "Paths" : "", "Processes" : ""},
          "RealtimeProtectionEnabled" : "false", "ScheduledScanSettings" : {"isEnabled": "true", "scanType" : "Quick", "day" : "7", "time" : "100" }}'

# Settings to remove the exclusion
$SettingsEnable = '{"AntimalwareEnabled" : "true", "Exclusions" : {"Extensions" : "", "Paths" : "", "Processes" : ""},
          "RealtimeProtectionEnabled" : "true", "ScheduledScanSettings" : {"isEnabled": "true", "scanType" : "Quick", "day" : "7", "time" : "100" }}'

# Provide VM info
$VMObject = Get-AzVM | out-gridview -Title "Select a VM" -PassThru
$VMName = $VMObject.Name
$Loc = $VMObject.Location
$ResourceGroup = $VMObject.ResourceGroupName

Write-Host "Disable Runtime ..."

# Exclude the binary
Set-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name "IaasAntimalware" -Location $Loc -Publisher "Microsoft.Azure.Security" -Type "IaasAntimalware" -TypeHandlerVersion "1.3" -SettingString $SettingsDisable

# Write-Host "Enable Runtime ..."

# Remove the exclusion
# Set-AzVMExtension -ResourceGroupName $ResourceGroup -VMName $VMName -Name "IaasAntimalware" -Location $Loc -Publisher "Microsoft.Azure.Security" -Type "IaasAntimalware" -TypeHandlerVersion "1.3" -SettingString $SettingsEnable

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

# Extension is not turning off RT Protection (Tamper Protection probably)
Get-MpComputerStatus