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
enroll_nodes:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant enroll-nodes.yaml
master_components_install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant master_components_install.yml
istio_install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant master_istio_install.yml
almost_all: init up install join enroll_nodes
all: init up install join enroll_nodes master_components_install istio_install
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
join:
	cd kubernetes/ansible && ansible-playbook --connection=local join-enroll-inject.yml
image:
	cd packer/virtualbox/20.04.02 && bash build-virtualbox.sh
	cd packer/virtualbox/20.04.02 && bash build-virtualbox-bare.sh
	vagrant box remove corevm_gui
	vagrant box remove corevm_node
	cd packer/builds && vagrant box add corevm_node ubuntu-20.04-gui.virtualbox.box
	cd packer/builds && vagrant box add corevm_gui ubuntu-desktop-20.04.virtualbox.box