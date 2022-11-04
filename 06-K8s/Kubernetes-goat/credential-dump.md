# Possible credential access tool detected

On the following lab we can see Defender for Cloud analysis of processes running within a container or directly on a Kubernetes node, having detected a possible known credential access tool was running on the container, as identified by the specified process and commandline history item. This tool is often associated with attacker attempts to access credentials

Just create a simple nginx pod

```
kubectl run nginx --image nginx
```

Install git

```
apt-get install -y git
```

clone the minipenguin cred dump tool
```
git clone https://github.com/huntergregal/mimipenguin.git
```

```
cd mimipenguin
```
```
./mimipenguin.sh
```

You will soon detect the use of a malicious tool for credential dumping in Defender for Cloud
![credential-dumping](/images/credential-dump.png)

