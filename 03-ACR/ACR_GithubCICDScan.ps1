################ CI/CD Capabilities ###############
###################################################

    # Test Capability of Container Vulnerability Scanning in the CI/CD Pipeline through a github Action workflow
    # The feature provides the ability to push the VUlnerabilities found in CI/CD to Azure Defender as well so that Sec Admin can see what did the developer saw.
    # Feature needs to be enabled in Azure Defender (CI/CD Integration)
        # Customers do not have to pay for App Insights to get the results from this feature.
    # More info: https://aka.ms/ascdevsecops


    # 1) Enable Azure Defender for Container Registries at the subscription level

    # 2) Enable the CI/CD integration in the Security Center Portal
        # Copy the <authentication token> and <connection string>

    # 3) Create a CI/CD Pipeline Repo in Github | Will be used to test the feature
        # 1. Create new repo in the portal first (without readme file), then create local folder as well.
        cd ./ASC-CICDScanv2
        # 2. Initialize the repo and create Readme file
        echo "# ASC-CICDScanv2" >> README.md
        git init
        git add README.md
        git commit -m "first commit"
        git remote add origin https://github.com/UserSecLab/ASC-CICDScanv2.git
        git push -u origin master
        # 3. Create gitb environment variable in the portal to push docker to ACR | repo -> Settings -> Secrets
        ACR_USERNAME # from ACR Portal (enabled admin access)
        ACR_PASSWORD # # from ACR Portal (enabled admin access)
        ASC_AUTH_TOKEN # from ASC Portal
        ASC_CONNECTION_STRING # from ASC Portal
        # 4. Create a new github Action (CI Docker-Image workflow) and commit
        git pull # get latest from repo
            # Notice the new github/workflow folder with Yaml file to create and push the image to a remote repo
        # 5. Create a vulnerable docker image (dockerfile)
            # In this case, creating a docker image with out of date Firefox version
        # 6. Update github action workflow to 1) build the vulnerable dockerfile 2) Scan the image with ASC (trivy) 3) push to ACR and upload results
        # 7. Push to repo and check results
        git add .
        git commit -m "updating repo"
        git push -u origin master


