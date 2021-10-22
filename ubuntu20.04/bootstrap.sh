#!/bin/bash
# Bootstrap machine

ensure_netplan_apply() {
    # First node up assign dhcp IP for eth1, not base on netplan yml
    sleep 5
    sudo netplan apply
}

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

resolve_dns() {
    step "===== Create symlink to /run/systemd/resolve/resolv.conf ====="
    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

install_docker() {
    step "===== Installing docker ====="
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo chmod 777 /var/run/docker.sock
    # Add vagrant to docker group
    sudo groupadd docker
    sudo gpasswd -a vagrant docker
    sudo usermod -aG docker $USER
    # Setup docker daemon host
    # Read more about docker daemon https://docs.docker.com/engine/reference/commandline/dockerd/
    # sed -i 's/ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/192.168.121.210/g' /lib/systemd/system/docker.service
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

install_openssh() {
    step "===== Installing openssh ====="
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y openssh-server
    sudo systemctl enable ssh
}

install_tools() {
    sudo apt install -y python-pip
    sudo apt install -y default-jre
	pip install kafka --user
	pip install kafka-python --user
}

setup_root_login() {
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    sudo echo "root:rootroot" | chpasswd
}

setup_code_server() {
	echo "Setting up Code server"
	curl -fsSL https://code-server.dev/install.sh | sh
	sudo systemctl enable --now code-server@$USER
}

install_golang() {
	echo "Install Golang Version 1.17.2"
	wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz -o /tmp/go1.17.2.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
	echo "PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

}

install_rust() {
	echo "Installing Rust"
	sudo su vagrant
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	echo "PATH=$PATH:~/.cargo/bin" >> ~/.bashrc
	exit
}

setup_welcome_msg() {
    sudo apt -y install cowsay
    version=$(cat /etc/os-release |grep VERSION= | cut -d'=' -f2 | sed 's/"//g')
    sudo echo -e "\necho \"Welcome to Vagrant Ubuntu Server ${version}\" | cowsay\n" >> /home/vagrant/.bashrc
    sudo ln -s /usr/games/cowsay /usr/local/bin/cowsay
}

main() {
    ensure_netplan_apply
    resolve_dns
    install_openssh
    setup_root_login
    #setup_welcome_msg
    install_docker
    install_rust
    install_golang
    setup_code_server
}

main
