init:
	echo "Create network for virtualbox"
	VBoxManage natnetwork add --netname KubeNetwork --network "192.168.51.0/24" --enable
up:
	cd kubernetes && vagrant up
provision:
	cd kubernetes && vagrant up --provision