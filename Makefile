init: deinit
	sudo pacman -S --needed ansible packer linux-headers virtualbox-host-dkms sshpass
	sudo /sbin/rcvboxdrv setup
	echo "Create network for virtualbox"
	VBoxManage natnetwork add --netname KubeNetwork --network "192.168.51.0/24" --enable
	-ansible-galaxy collection install community.general
up:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/virtualbox/Vagrantfile vagrant up --parallel
up_arm:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/parallels/Vagrantfile vagrant up --no-parallel
reload_arm:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/parallels/Vagrantfile vagrant reload

status:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/virtualbox/Vagrantfile vagrant status
down:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/virtualbox/Vagrantfile vagrant halt
down_arm:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/parallels/Vagrantfile vagrant halt
destroy_arm:
	cd kubernetes && VAGRANT_VAGRANTFILE=vagrant/parallels/Vagrantfile vagrant destroy -f
master:
	cd kubernetes && vagrant ssh kube-master
provision:
	cd kubernetes && vagrant up --provision
install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant install_management_node.yml
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant install-node.yml
install_arm:
	cd kubernetes/ansible && ansible-playbook -i hosts_parallels.yml --user vagrant install_management_node.yml
	cd kubernetes/ansible && ansible-playbook -i hosts_parallels.yml --user vagrant install-node.yml

enroll_nodes:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant enroll-nodes.yaml
master_components_install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant master_components_install.yml
istio_install:
	cd kubernetes/ansible && ansible-playbook -i hosts.yml --user vagrant master_istio_install.yml
almost_all: init up install join enroll_nodes
all: init up install join enroll_nodes master_components_install istio_install
all_arm: up_arm install_arm join enroll_nodes master_components_install istio_install
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
node:
	cd kubernetes && vagrant ssh kube_node1

join:
	cd kubernetes/ansible && ansible-playbook --connection=local join-enroll-inject.yml
image:
	cd packer/virtualbox/20.04.02 && bash build-virtualbox.sh
	cd packer/virtualbox/20.04.02 && bash build-virtualbox-bare.sh
	-vagrant box remove corevm_gui
	-vagrant box remove corevm_node
	cd packer/builds && vagrant box add corevm_node ubuntu-20.04.virtualbox.box
	cd packer/builds && vagrant box add corevm_gui ubuntu-desktop-20.04.virtualbox.box
image_arm:
	cd packer/parallels && PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/9/Libraries/Python/3.7  packer build -force ubuntu-20.04-arm64.json.pkr.hcl
	cd packer/parallels && PYTHONPATH=/Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions/9/Libraries/Python/3.7  packer build -force ubuntu-20.04-desktop-arm64.json.pkr.hcl
	-vagrant box remove corevm_arm_gui
	-vagrant box remove corevm_arm_node
	cd builds && vagrant box add corevm_arm_node ubuntu-20.04-arm64.parallels.box
	cd builds && vagrant box add corevm_arm_gui ubuntu-20.04-arm64-desktop.parallels.box

check_frontend:
	cd frontend && docker run --rm -i hadolint/hadolint < Dockerfile
check_backend:
	cd backend && docker run --rm -i hadolint/hadolint < Dockerfile
build_frontend: check_frontend
	cd frontend && docker build -t phiroict/k8s-test-frontend:20210829 . && docker push phiroict/k8s-test-frontend:20210829
build_backend: check_backend
	cd backend && docker build -t phiroict/k8s-test-backend:20210829.4 . && docker push phiroict/k8s-test-backend:20210829.4
