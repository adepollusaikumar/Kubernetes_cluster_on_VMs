#!/bin/bash

provision_server() {
        SERVER_NAME=$1
        version="v1.18.5"
        echo -e  "\e[40;38;5;82mI'm $SERVER_NAME  \e[0m\n"
        sudo apt-get update -q
        echo -e  "\e[40;38;5;82mInstalling docker on  $SERVER_NAME  \e[0m\n"
        sudo apt-get install docker.io curl socat conntrack -y -q 
        docker --version
        sudo systemctl enable docker
        sudo systemctl status docker
        echo -e  "\e[40;38;5;82mStarting docker   \e[0m\n"
        sudo systemctl start docker
        echo -e  "\e[40;38;5;82mIntalling Kubernetes on $SERVER_NAME  \e[0m\n" 
        sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install -y kubeadm kubelet kubectl
        sudo swapoff --all
        if  [ $SERVER_NAME == "master" ]; then
                                    echo -e  "\e[40;38;5;99m     * Master configuration . \e[0m"
                                    systemctl enable kubelet
                                    systemctl start kubelet
                                    kubeadm version
                                    masterhost=`grep 10.0.6 /etc/hosts|grep master|awk '{print $1}'`
                                    kubeadm init   --apiserver-advertise-address=$masterhost --pod-network-cidr=10.244.0.0/16>>/vagrant/kubeadm_master_log.log
                                    mkdir -p $HOME/.kube
                                    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
                                    sudo chown $(id -u):$(id -g) $HOME/.kube/config                                 
                                    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
                                    tail -2 /vagrant/kubeadm_master_log.log|tr '\n' ' '|awk '{print  $1" "$2" "$3" "$4" "$5" "$7" "$8" "}'>/vagrant/master             
        else       
                                    echo -e  "\e[40;38;5;99m     * Worker configuration . \e[0m"
                                
                                    bash /vagrant/master
                      
              echo "############## $SERVER_NAME provision completed ###############################################################"
                      
                                     
                                                                  fi 
                   }


provision_server $1
