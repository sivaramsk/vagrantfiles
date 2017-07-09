#!/bin/bash                                                                     
                                                                                
# Install and setup go-lang                                                     
add-apt-repository -y ppa:longsleep/golang-backports                            
                                                                                
# Install docker-ce                                                             
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -    
                                                                                
apt-key fingerprint 0EBFCD88                                                    
                                                                                
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"                                                                      
apt-get update                                                                  
apt-get install -y apt-transport-https ca-certificates curl software-properties-common docker-ce golang-go                                          
