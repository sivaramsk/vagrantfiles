Sample development environment with Docker, Golang, NodeJS installed along with Eclipse-Theia. 

Installation: vagrant up

Environment: 
 1. Once the machine is up, you need to setup the GOROOT to /usr/local/go/bin and GOPATH to /vagrant_data/projects. 
 2. Eclipse Theio is setup to start as a docker container and port forwared to the host at port number 3333. Once the macine is up, go to 127.0.0.1:3333 in you host machine to go to Eclipse environment.
 
Customization: 
  Docker, Golang and Node are installed through ansible playbook preset under the folder install_scripts. Installation can be customized by modifying the variables under the vars directory like version.
