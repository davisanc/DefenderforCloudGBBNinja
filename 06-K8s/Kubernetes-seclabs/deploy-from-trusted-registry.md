# Kubernetes cluster containers should only use allowed images

On the following lab we will work on hardening the kubernetes environment in AKS, by only allowing deployment of container images from a trusted registry
The use of container images being depoyed directly on kubernetes services from external and non trusted repositories can be controlled, audited and denied by Azure Policy

We will work on an Azure Policy definition that will hardcore the name of the trusted ACR in our environment

Go to Azure Policy, look for the definition 'Kubernetes cluster containers should only use allowed images' and within Parametres, use the following regex to refer to your ACR registry in the Policy

```
^.*<name-of-ACR>/.+$
```

Asign the policy definition to your scope 


On your working machine, we will pull an nginx container from docker hub and push it to the container registry

```
docker pull nginx
```

Login to your ACR

```
docker login <ACR-Loginserver> -u [username] -p [password]
```

Tag the image with the name of your ACR registry

```
docker tag nginx <name-of-ACR>/nginx:latest
```

Push the image to yout ACR

```
 docker push <name-of-ACR>/nginx:latest
```

Verify within your ACR that you have a repository with the nginx image

Now, with a github action, deploy a workflow that will use the image from the trusted registry and deploy as a Pod
You can fork this https://github.com/davisanc/azure-voting-app-redis

Make sure you create the Github Action secrets to log into Azure to deploy the container into AKS. You will also need an Azure AD registered app with a federated credential for Github actions

Afterwards, you will use another Github action to deploy the same container using an external and untrusted registry, which will fail

![pod-failed-policy](/images/pod-failed-policy.png)

![GH-action-failed.png](/images/GH-action-failed.png)