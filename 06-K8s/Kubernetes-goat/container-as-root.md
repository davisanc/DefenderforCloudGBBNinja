# Running containers as root user should be avoided

Running the process inside of a container as the root user is a common misconfiguration in many clusters. While root may be an absolute requirement for some workloads, it should be avoided when possible. If the container were to be compromised, the attacker would have root-level privileges that allow actions such as starting a malicious process that otherwise wouldn’t be permitted with other users on the system

From a view in Defender for Cloud, you can pivot to one of your Kubernetes cluster and look for a recommendation that shows if a cluster runs containers as root mode

![container as root](/images/container-as-root.PNG)

Insecure configurations such as this one is seen as one of the OWASP Top 10 misconfigurations for Kubernetes
https://github.com/OWASP/www-project-kubernetes-top-ten/blob/main/2022/en/src/K01-insecure-workload-configurations.md

For this lab we will create a pod using a manifest file that will use the nginx image stored in the ACR registry, and using pod SecurityContext it will deploy the container in root mode

The manifests file looks like this:

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-as-root
spec:
  containers:
  - name: nginx-as-root
    image: k8sgoatacr.azurecr.io/nginx:latest
  securityContext:  
    #root user
    runAsUser: 0
```

We will use a Github action to dpeloy a workflow that pushes the container image into a kubernetes pod

We will have an Azure Policy that denies the creation of such container. We will use this Policy Definition:

```
Kubernetes cluster pods and containers should only run with approved user and group IDs
```

![azure policy as non root](/images/azure-policy-nonroot.PNG)

And assign the policy definition to your scope

In Github, we will have a workflow (action) that will use the pod manifest file that creates the container as root mode. We run the action and Azure policy should deny this effect

![container as root](/images/container-as-root.PNG)