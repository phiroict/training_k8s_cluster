KUBE_SYSTEMS=$(prlctl list | grep kubernetes_kube | awk '{print $4}')
for KUBE_SYSTEM in $KUBE_SYSTEMS; do
   echo $KUBE_SYSTEM
done