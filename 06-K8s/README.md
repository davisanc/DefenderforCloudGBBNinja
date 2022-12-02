# Kubernetes Security Labs, based on Defender for Cloud Containers Plan

The purpose of this repo is to support a Proof of Concept on Defender for Cloud for containers and Kubernetes security

Some of this labs are based on the Kubernetes Goat and we have also added further use cases to demonstrate some of the Defender detections for containers and kubernetes

The labs will showcase the 3 main principles of Defender for Containers: Hardening, Vulnerability Management and Threat Detection

You can easily reproduce these labs for Azure Kuberntes Service environment or for a non-azure cluster like AWS EKS. We are working to show how you can test vulnerability scanning for AWS ECR

## Getting Set Up

1.	Get access to a build machine with AZ, AWS CLI and kubectl installed. Your build machine needs to use a kubeconfig file that refers to your kubernetes cluster in scope
    For Azure, you can instruct kubectl to connect to your AKS cluster with:

        ```
        az aks get-credentials --resource-group <myResourceGroup> --name <myAKSCluster> --admin
        ```

    For AWS, use this command:

        ```
        aws eks update-kubeconfig --region <your-aws-region> --name <your-EKS-cluster>
        ```

2.  Set up the Kubernetes goat in your existing Kubernetes cluster. Some of the labs will use the scenarios described here https://madhuakula.com/kubernetes-goat/
3.	Go to the kubernetes-seclabs section and follow the labs
