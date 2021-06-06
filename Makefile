init:
	echo "Create network for virtualbox"
	VBoxManage natnetwork add --netname KubeNetwork --network "192.168.51.0/24" --enable
up:
	cd kubernetes && vagrant up --parallel
provision:
	cd kubernetes && vagrant up --provision
install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant --ask-pass install_management_node.yml
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant --ask-pass install-node.yml
destroy:
	cd kubernetes && vagrant destroy -f