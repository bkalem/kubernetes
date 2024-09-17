#!/bin/bash
# in WORKER node

KUBE_VERSION="v1.26"
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/ /" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

cat /etc/apt/sources.list.d/kubernetes.list

sudo apt-mark unhold kubeadm

sudo apt-get update -y


sudo apt-get install -y kubeadm=1.26.1-1.1

sudo apt-mark hold kubeadm

# in CP node 
kubectl drain worker --ignore-daemonsets
 
# in WORKER node
sudo kubeadm upgrade node

sudo apt-mark unhold kubelet kubectl

sudo apt-get install -y kubelet=1.26.1-1.1 kubectl=1.26.1-1.1

sudo apt-mark hold kubelet kubectl

sudo systemctl daemon-reload

sudo systemctl restart kubelet

# in CP node 
kubectl get node

kubectl uncordon worker

kubectl get nodes
