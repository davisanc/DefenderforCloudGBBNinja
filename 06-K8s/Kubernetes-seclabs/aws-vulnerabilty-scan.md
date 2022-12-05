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
docker push <aws-accountUD>.dkr.ecr.<aws-region>.amazonaws.com/<aws-ecr-name>:cve-2014-6271
```

In max of 2 hours Defender will show a recommendation to fix the vulnerability findings of your AWS ECR

![AWS ECR Summary reco](/images/aws-ecr-summary.png)

And clicking on the affected resources you see the image details

![AWS ECR Summary reco](/images/aws-ecr-detail.png)

