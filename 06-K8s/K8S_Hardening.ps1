### ---------------------------------------------------------------------------------
### Push Image to K8s cluster and test Hardening from ASC (Azure Policy using Gatekeeper)
### Need to review steps (old version) + artifacts
### ---------------------------------------------------------------------------------

# 0 - Connect to Linux box 
# 0 - Make sure to perform steps to push container first to ACR (check folder ACR)

# 2 - Deploy to AKS
    # 0 - Open Cloud Shell
        $RESOURCE_GROUP = "AppDelivery-RG"
        $AKS_CLUSTER_NAME="Spoke1-AKS"
        # Authenticate with kubectl and get authorized IPs to communicate with kubectl
        az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
        # get my public ip ___
        curl ifconfig.me 
        # Check current AuthorizedIpRanges under apiServerAccessProfile:
        az aks show -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME
        # Update AuthorizedIPRanges
        az aks update -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME --api-server-authorized-ip-ranges 51.144.82.212/32
        # Validate access with kubectl (can take a few minutes to refresh)
        kubectl get nodes && kubectl get pods --namespace threatapps
    # 1 - Create a new namespace (threatapps)
    kubectl get namespace
    kubectl create namespace threatapps
    kubectl get namespace
    # 2 - Configure AKS to be able to authenticate to the container registry with vulnerable app
    $ACR_NAME="Spoke1VulnACR"
    az aks update --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP --attach-acr $ACR_NAME
    # 3 - Deploy Vulnerable container in AKS
        # Create the manifest file (Yaml)
        mkdir threatsapp
        code dvwa.yaml
        # Save file and apply configurations in the ratingsapp namespace
        kubectl apply --namespace threatapps -f dvwa.yaml
        # You can watch the pods rolling out using the -w flag 
        kubectl get pods --namespace threatapps -l app=dvwa -w
        # You can view their logs by using:
        kubectl logs dvwa-65fb56876b-hcqzg --namespace threatapps # and
        kubectl describe pod dvwa-65fb56876b-hcqzg --namespace threatapps
    # Check status of deployment
    kubectl get deployment dvwa --namespace threatapps
    # Trigger ASC evaluation scan for Azure policy
    az policy state trigger-scan --resource-group $RESOURCE_GROUP
    # Create hunting query based on non-compliance alert
    # Check deployment and pods and clean once detection has been triggered
    kubectl get pods -A # list pods
    kubectl delete namespaces threatapp