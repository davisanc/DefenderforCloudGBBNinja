# Process associated with digital currency mining detected

Analysis of processes running within a container detected the execution of a process normally associated with digital currency mining

Enter into the bash of any of the nginx running pods

```
kubectl exec -it <name-of-pod> -- /bin/bash
```

Install gcc
```
apt-get install gcc
```

Run the following command to attempt to login to a crypto mining pool

```
gcc -T -o stratum+tcp://stratum.slushpool:3333 -u foobar -p baz -o stratum+tcp://stratum.f2pool.com:3333 -u foobar -p baz -o stratum+tcp://stratum.antpool.com:3333 -u foobar -p baz
```

You will be able to see this type of alert in Defender

![crypto mining](/images/crypto-mining.png)