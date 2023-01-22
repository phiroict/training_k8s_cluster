KUBE_SYSTEMS=$(prlctl list | grep kubernetes_kube | awk '{print $4}')
for KUBE_SYSTEM in $KUBE_SYSTEMS; do
   echo $(prlctl exec "${KUBE_SYSTEM}" "ip a" | grep eth1 | awk 'BEGIN{FS=" "} {print $(NF-5)}') | awk '{print $2}'
done