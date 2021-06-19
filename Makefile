init: deinit
	echo "Create network for virtualbox"
	VBoxManage natnetwork add --netname KubeNetwork --network "192.168.51.0/24" --enable
	ansible-galaxy collection install community.general
up:
	cd kubernetes && vagrant up --parallel
status:
	cd kubernetes && vagrant status
down:
	cd kubernetes && vagrant halt
master:
	cd kubernetes && vagrant ssh kube_master
provision:
	cd kubernetes && vagrant up --provision
install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant install_management_node.yml
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant install-node.yml
all: init up install
destroy:
	cd kubernetes && vagrant destroy -f
deinit:
	-VBoxManage natnetwork remove --netname KubeNetwork
cleanup: destroy deinit
bounce_stack: cleanup all
reload:
	cd kubernetes && vagrant reload
master_connect:
	cd kubernetes && vagrant ssh kube_master