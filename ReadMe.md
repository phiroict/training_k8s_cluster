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

Install a network manager, Calico is a good default:

```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Check with
watch kubectl get pods --all-namespaces
```

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
