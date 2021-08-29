Install istio 

```bash
yay -S istio
```

Start minikube 

```bash
minikube start --memory=32g --cpu=8
```

Initialize 

```bash
istioctl install --set profile=demo -y
```

Set the default namespace up to use istio

```bash
kubectl label namespace default istio-injection=enabled
```

After creation of the gateway list the gateway 

```bash
kubectl get svc istio-ingressgateway -n istio-system
```

On minikube export the network: 

```bash
minikub tunnel
```

And then list the service ips: 

```bash
kubectl get svc
```


Run repeated calls by

```bash
for ((i=1;i<=10000;i++)); do   curl -v --header "Connection: keep-alive" "http://10.104.220.161:5000"; done

```



Z2sr8Q7TrfQ8zXnM