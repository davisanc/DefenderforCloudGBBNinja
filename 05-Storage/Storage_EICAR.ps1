### ---------------------------------------------------------------------------------
### ASC Alert simulation for Storage
### ---------------------------------------------------------------------------------

# Simple test, uploading test malware (EICAR) to an Azure Storage account

# 00 - Create a Storage Account
$storageAccountName = "githubsadfgcuiatglpfp2cs"
$containerName = "eicarsimulation"

# 01 - Using AzCLI (use the portal to avoid EICAR problems in the corp machine :) )
    # Create folder for the simulation
    mkdir Defender4Storage
    cd ./Defender4Storage
    # Create EICAR File (be careful to not save or paste EICAR string in your corp machine)
    New-Item -Path . -Name "GetRichNowFile.txt" -ItemType "file" -Value "IncludeEICARString"
    cat ./GetRichNowFile.txt #Validate
    # Create a new container in your storage account
    az storage container create --account-name $storageAccountName --name $containerName --auth-mode login
    # Upload file to the container created
    az storage blob upload --account-name $storageAccountName --container-name $containerName --file ./GetRichNowFile.txt --name GetRichNowFile --auth-mode login