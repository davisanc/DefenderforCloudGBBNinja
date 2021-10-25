### ---------------------------------------------------------------------------------
### ASC MicroBurst Simulation for Azure Defender ARM
### ---------------------------------------------------------------------------------

# ::::::::::::::::::::::::::::::::::::::::::::::
# MicroBurst Github
# ::::::::::::::::::::::::::::::::::::::::::::::

# 0 - Connect to CoreSvcs-SRV1

# 1 - Download MicroBurst
cd C:\temp\MicroBurst-master

# 2 - Run MicroBurst Script
Set-ExecutionPolicy -ExecutionPolicy Bypass

# 3 - Import MicroBurst.ps1
Connect-AzAccount
Import-Module .\MicroBurst.psm1 #ImportModule, will import need functions based on what is installed on the box

# 4 - MicroBurst Usage Example.

# ::::::::::::::::::::::::::::::::::::::::::::::
# Enumerate Azure Services Anonymously (based on subdomains)
# DNS brute forcing to find existing Azure services subdomains.
# ::::::::::::::::::::::::::::::::::::::::::::::

cd .\Misc
.\Invoke-EnumerateAzureSubDomains.ps1
Invoke-EnumerateAzureSubDomains -Base ptstuems -Verbose

