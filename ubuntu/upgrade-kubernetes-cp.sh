#!/bin/bash
# in CP node
sudo apt-cache madison kubeadm
cat /etc/apt/sources.list.d/kubernetes.list

KUBE_VERSION="v1.26"
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/ /" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

cat /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update -y

sudo apt-mark unhold kubeadm

sudo apt-get install -y kubeadm=1.26.1-1.1

sudo apt-mark hold kubeadm

sudo kubeadm version

kubectl drain cp --ignore-daemonsets

sudo kubeadm upgrade plan

sudo kubeadm upgrade apply v1.26.1

kubectl get node

sudo apt-mark unhold kubelet kubectl

sudo apt-get install -y kubelet=1.26.1-1.1 kubectl=1.26.1-1.1

sudo apt-mark hold kubelet kubectl

sudo systemctl daemon-reload

sudo systemctl restart kubelet

kubectl uncordon cp

kubectl get node
