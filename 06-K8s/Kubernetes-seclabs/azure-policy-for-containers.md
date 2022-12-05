### Azure Policy for Containers
Azure Policy extends Gatekeeper v3, an admission controller webhook for Open Policy Agent (OPA), to apply at-scale enforcements and safeguards on your clusters in a centralized, consistent manner. Azure Policy makes it possible to manage and report on the compliance state of your Kubernetes clusters from one place. The add-on enacts the following functions:
- Checks with Azure Policy service for policy assignments to the cluster.
- Deploys policy definitions into the cluster as constraint template and constraint custom resources
- Reports auditing and compliance details back to Azure Policy service.

#### Initiatives
|Name |Description |Policies |Version |
|---|---|---|---|
|[Kubernetes cluster pod security baseline standards for Linux-based workloads](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/Kubernetes/Kubernetes_PSPBaselineStandard.json) |This initiative includes the policies for the Kubernetes cluster pod security baseline standards. This policy is generally available for Kubernetes Service (AKS), and preview for Azure Arc enabled Kubernetes. For instructions on using this policy, visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |5 |1.2.1 |
|[Kubernetes cluster pod security restricted standards for Linux-based workloads](https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/Kubernetes/Kubernetes_PSPRestrictedStandard.json) |This initiative includes the policies for the Kubernetes cluster pod security restricted standards. This policy is generally available for Kubernetes Service (AKS), and preview for Azure Arc enabled Kubernetes. For instructions on using this policy, visit [https://aka.ms/kubepolicydoc](https://aka.ms/kubepolicydoc). |8 |2.3.1 |

see Kubernetes cluster pod security baseline standards for Linux-based workloads
![Kubernetes cluster pod security baseline standards for Linux-based workloads](../images/linux-restricted-policies.jpg)


#### Deploy Azure Policy for Azure Kubernetes Services
```bash
az aks enable-addons --addons azure-policy --name MyAKSCluster --resource-group MyResourceGroup
kubectl get pods -n kube-system
kubectl get pods -n gatekeeper-system
```
#### Deploy Azure Policy for Azure Arc Enabled Kubernetes
```bash
az connectedk8s list -o table
az k8s-extension create --cluster-type connectedClusters --cluster-name my-test-cluster --resource-group my-test-rg --extension-type Microsoft.PolicyInsights --name azurepolicy
kubectl get pods -n kube-system
kubectl get pods -n gatekeeper-system
```

#### Sample Auditing
Assign *Kubernetes cluster pod security baseline standards for Linux-based workloads* Initiative to your subscription
- Go To Azure Policy
- Click Assignments from the left menu
- Click Assign initiative button
- select the scope
- Select *Kubernetes cluster pod security baseline standards for Linux-based workloads* Initiative 
- Review and Create

After 15 mins later based on the initative, which is assigned, all uncomplaint pods in Azure Kubernetes Services and Arc Enabled Kubernetes cluster will be shown.
![Kubernetes cluster pod security baseline standards for Linux-based workloads Output](../images/linux-restricted-policies-overview-result.jpg)

By clicking each individiual policy inside initiative will show you more details on the cluster and the corresponding uncompliant pods
![Kubernetes cluster pod security baseline standards for Linux-based workloads Kubernetes clusters should not allow container privilege escalation](../images/linux-restricted-policies-detailed-result.jpg)
