# Preparation all VMs
## prérequis network plugin
ajouter ces 3 lignes dans le fichiers `/etc/sysctl.d/k8s.conf`
```shell
vi /etc/sysctl.d/k8s.conf
```
>net.bridge.bridge-nf-call-iptables = 1  
>net.bridge.bridge-nf-call-ip6tables = 1  
>net.ipv4.ip_forward = 1  

## désactiver le swap
désactiver le swap et commenter la ligne dans `/etc/fstab`
```shell
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

## préparer la résolutation des FQDN ( k8s master et worker )
ajouter les adresses IPs et FQDN pour la résolution local `/etc/hosts`
```shell
vi /etc/hosts
```
>192.168.249.132		k8s-master			k8s-master.formini.dz  
>192.168.249.133		k8s-worker-node-1	k8s-worker-node-1.formini.dz  
>192.168.249.134		k8s-worker-node-2	k8s-worker-node-2.formini.dz  

## ajouter le repository de kubernetes
créer le fichier repository pour kubernetes
```shell
vi /etc/yum.repos.d/kubernetes.repo
```
>[kubernetes]  
>name=Kubernetes  
>baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64  
>enabled=1  
>gpgcheck=0  

#Déploiement du master Kubernetes
## on master
### installation des packages kubernetes
```shell
yum install kubelet kubeadm kubectl
```
### start & enable kubelet
```shell
systemctl enable kubelet && systemctl start kubelet
```
### initiation du master k8s
vous pouvez choisir un réseau de pod qui arrange votre architecture
```shell
kubeadm init --pod-network-cidr=10.244.0.0/16
```
veuillez récupérer le token pour la jonction des worker ultérieurement 
>Then you can join any number of worker nodes by running the following on each as root:  
>  
>kubeadm join 192.168.249.132:6443 --token z0bhwc.nw3fkfz0q6g5xrq0 \  
>    --discovery-token-ca-cert-hash sha256:e3f1bd2f3536118fca1f2af754b62e794b3485b8b1365d714510308526372158  

