# Kubernetes clusters should not grant CAPSYSADMIN security capabilities

CAP_SYS_ADMIN allows to perform a range of system administration operations, privileged ones that cannot be performed by a normal user

This capability is default by default in a Kubernetes cluster, unless explicity enabled in the pod definition file 

We will use this Pod definition file to allow bind this permission in one of our pods

```

apiVersion: v1
kind: Pod
metadata:
  name: nginx-cap-sys-admin
spec:
  containers:
  - name: nginx-cap-sys-admin
    image: nginx
    securityContext:
      capabilities:
        add: ["SYS_ADMIN"]
```

This bevaviour is very similar to running a container with privileged mode

As there is a built-in policy definition to monitor this operation, you will find a specific recommendation that flags the use of containers with this capability. You may also want to enforce this policy in Deny mode


![cap_sys_admin pod](/images/cap_sys_admin.png)

