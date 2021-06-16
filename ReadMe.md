# Building Kubernetes network on virtualbox

This is a part of a run through of the creation of a kubernetes cluster from scratch.

# Stack

- Archlinux rolling
- Virtual box 6.x
- Vagrant 2.2.x

# Install
These commands do most of the installation
```bash
make init
make up
make install
```

Reprovisions with

```bash
make provision
```

And clean up with

```bash
make cleanup
```
which will delete the stack and remove the network from virtualbox.


# Post install

## Manager
After installation run on the manager, this is the result of the init:
```bash
sudo kubeadm token create

ahw5ao.uyjl3hehqhvpy1l8
```
You get output from the ansible script for the manager like

```bash
kubeadm join k8s-cluster.phiroict.co.nz:6443 --token qfyvrc.s2ddam3puw9lq5p8 \\",
        "\t--discovery-token-ca-cert-hash sha256:ee5c332d4181c4ba7e4310da1e83376ceb2dd1e8e1d15665354c575f928df680
```

## Node
Now join the cluster for each of the nodes  

```bash
sudo kubeadm join k8s-cluster.phiroict.co.nz:6443 --token qfyvrc.s2ddam3puw9lq5p8 --discovery-token-ca-cert-hash sha256:ee5c332d4181c4ba7e4310da1e83376ceb2dd1e8e1d15665354c575f928df680
```

# Usage

# Manager - Control pane

At the moment we have one control pane (the manager) and four nodes.
On the `https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/` as examples how to test the stack.


Now install the dashboard: 
```bash
wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
mv recommended.yaml kubernetes-dashboard-deployment.yml

kubectl apply -f  kubernetes-dashboard-deployment.yml
```

Now in the master run
```bash
kubectl proxy
```

Install a network manager, Flannel is a good default, do this after the dashboard release as it needs to run on the master and not on the nodes:

```bash
kubectl apply -f kube-flannel.yml

# Check with
watch kubectl get pods --all-namespaces
```


And forward port 8001 to the host from virtualbox 

Now open the dashboard with: 

```bash
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
```

Change the deployment file by set a NodePort or get the one from  `kubernetes/k8s-dashboard.yaml`

# Details

Here technical details about this stack is shown.

## Ansible

## Virtual box configuration with Vagrant


## Usage

Log in to all the nodes.

- Get terminator
- Start four termials
- Log in with
```bash
ssh vagrant@localhost -p 220x # Where x is a element of {0,1,2,3}
```

## Reboot

After all the servers are back, resstart the kubelet by
```bash
sudo systemctl restart kubelet
```


# Training videos

`https://www.youtube.com/watch?v=YXfLAWGTI38`
## Cheat sheet 

`https://kubernetes.io/docs/reference/kubectl/cheatsheet/`
## Setup sites
```text
https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
https://computingforgeeks.com/how-to-install-kubernetes-dashboard-with-nodeport/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#configure-cgroup-driver-used-by-kubelet-on-control-plane-node
https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-token/
```


# Application and routing

Need to have: Kubernetes cluster with one master and four nodes

Create and setup the dashboard:

`https://www.replex.io/blog/how-to-install-access-and-add-heapster-metrics-to-the-kubernetes-dashboard`
In short:

# Create a service account

```bash
kubectl create serviceaccount dashboard-admin-sa
```

# Bind the account to the dashboard

```bash
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
```

# Get the token

```bash
kubectl get secrets
```

# Select the entry

```bash
kubectl describe secret dashboard-admin-sa-token-gkblm
```

# Now get the JWT token (token:) and log in.





Install the prometheus stack by using helm

```bash
sudo snap install helm –classic
```



# Search for a grafana chart

```bash
helm search hub grafana -o json
```

# Get the chart from the json result. Install it and check its installation


```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install mytrucking-monitoring prometheus-community/kube-prometheus-stack
kubectl --namespace default get pods -l "release=mytrucking-monitoring"
```





Setting up an ingress point we install the nginx plugin ingress as decribed here:

`https://kubernetes.github.io/ingress-nginx/deploy/`





When that is done :

`https://kubernetes.io/docs/concepts/services-networking/ingress/`

Create an ingress for a service



Now get the the url to get to the service:


```bash
kubectl describe service/mytrucking-monitoring-grafana
```


# Returns something like
```text
Name:              mytrucking-monitoring-grafana
Namespace:         default
Labels:            app.kubernetes.io/instance=mytrucking-monitoring
                   app.kubernetes.io/managed-by=Helm
                   app.kubernetes.io/name=grafana
                   app.kubernetes.io/version=8.0.1
                   helm.sh/chart=grafana-6.12.1
Annotations:       meta.helm.sh/release-name: mytrucking-monitoring
                   meta.helm.sh/release-namespace: default
Selector:          app.kubernetes.io/instance=mytrucking-monitoring,app.kubernetes.io/name=grafana
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.107.137.163
IPs:               10.107.137.163
Port:              service  80/TCP
TargetPort:        3000/TCP
Endpoints:         10.244.3.7:3000
Session Affinity:  None
Events:            <none>
```


The endpoint is what you use on the master or wherever you forwarded this to.



This assumes the proxy is running (You started that for the dashboard)  