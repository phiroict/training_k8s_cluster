# Install istio and argocd.  

## Install components

### Istio and minikube

Install the local app in Arch linux, assumes you have the kvm hypervisor installed.  
```bash
yay -S istio minikube
```
### Install argocd

```bash
yay -S argocd
```

Install the kubernetes set

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Create loadbalancer and export the ports 

```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
or port forwarding: 

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Now get the secret for login 

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Get the server ips (for instance):
```text
kubectl get services -n argocd

# Take the one for the argocd-server
argocd-server           ClusterIP   *10.109.77.114*   <none>        80/TCP,443/TCP               125m
```

Then logon by (for instance)
```bash
argocd login 10.109.77.114
```


More info at: 
```bash
https://argoproj.github.io/argo-cd/getting_started/
```

## Kubernetes
Start minikube , note you need a lot of memory and cpu power to run istio, the defaults (2 GiB and 2 vCPUs) are not enough.
If you have an existing minikube instance with a smaller resource setting you need to destroy it and then recreated it.
```bash
minikube delete 
```
And then start it (again)
```bash
minikube start --memory=32g --cpu=8
```

Initialize istio 

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




Linking the resources 
Istio Gateway
```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: frontend-gateway
  namespace: default
spec:
  selector:
    app: k8s-frontend
  servers:
  - port:
      number: 5000
      name: http-frontend
      protocol: HTTP
    hosts:
    - istio.default.phiroict.co.nz
```
The selector selects (spec.selector.app) to the **nodes** not the services.

Virtual Service link to the gateway: 

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: frontend
spec:
  hosts:
  - istio.default.phiroict.co.nz
  gateways:
  - default/frontend-gateway
  http:
  - match:
    - uri:
        exact: /
    route:
    - destination:
        host: frontend
        port:
          number: 5000
```
The gateways point to the gateway. 