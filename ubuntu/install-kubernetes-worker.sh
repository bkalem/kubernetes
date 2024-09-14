#!/bin/bash
# update 2024-09-15
# WORKER node

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt install curl apt-transport-https vim git wget gnupg2 software-properties-common lsb-release ca-certificates uidmap -y

sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

cat << EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# install containerd

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y && sudo apt-get install containerd.io -y

containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -e 's/SystemdCgroup = false/SystemdCgroup = true/g' -i /etc/containerd/config.toml

sudo systemctl restart containerd

# install kubernetes v1.25 
KUBE_VERSION="v1.25"

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

sudo apt-get update -y

# don't install latest version, in the next LAB we will upgrade kubernetes 
# sudo apt-get install -y kubeadm kubelet kubectl 

# check available version in the repository
# sudo apt-cache madison kubeadm kubelet kubectl

sudo apt-get install -y kubeadm=1.25.1-1.1 kubelet=1.25.1-1.1 kubectl=1.25.1-1.1

sudo apt-mark hold kubelet kubeadm kubectl

## in CP node 
# ip address show ens192 | grep inet
# sudo kubeadm token list
# sudo kubeadm token create
#
## remember this xxxTOKENxxx
#
# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/ˆ.* //'
#
## remember this xxxSSL_THUMBxxx
#

## in WORKER node 
# sudo vim /etc/hosts 
# __IP_CP_NODE__  k8scp

## in WORKER node 
## join the cluster by using this command 
# sudo kubeadm join --token xxxTOKENxxx k8scp:6443 --discovery-token-ca-cert-hash sha256:xxxSSL_THUMBxxx

## wait until successfully in worker 
## in CP node 
# kubectl get nodes 
# kubectl get pods --all-namespaces
