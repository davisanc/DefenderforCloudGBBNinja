### ---------------------------------------------------------------------------------
### ASC Alert simulation for Azure VM - Using Extensions
### ---------------------------------------------------------------------------------

# ::::::::::::::::::::::::::::::::::::::::::::::
#  Type: Detection
#  Description: Custom Script - Extension trigger
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

# Settings for Custom Script Extension
$Settings =  '{"fileUris":[],"commandToExecute":"echo ascTest"}'

# Provide VM info
$VMObject = Get-AzVM | out-gridview -Title "Select a VM" -PassThru
$VMName = $VMObject.Name
$Loc = $VMObject.Location
$ResourceGroup = $VMObject.ResourceGroupName

# Execute Custom Script Extension
Write-Host "Executing ..."
Set-AzVMExtension -Publisher "Microsoft.Compute" -ResourceGroupName $ResourceGroup -VMName $VMName -Name "CustomScriptExtension" -Location $Loc -Type "CustomScriptExtension" -TypeHandlerVersion "1.3" -SettingString $Settings