# Preparation all VMs
## renommer les hostnames des VMs
```shell
hostnamectl set-hostname k8s-master.formini.dz
hostnamectl set-hostname k8s-worker-node-1.formini.dz
hostnamectl set-hostname k8s-worker-node-2.formini.dz
hostnamectl set-hostname k8s-worker-node-3.formini.dz
hostnamectl set-hostname k8s-worker-node-4.formini.dz
```
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
>192.168.249.132		k8s-master			    k8s-master.formini.dz  
>192.168.249.133		k8s-worker-node-1	  k8s-worker-node-1.formini.dz  
>192.168.249.134		k8s-worker-node-2	  k8s-worker-node-2.formini.dz  
>192.168.249.135		k8s-worker-node-3	  k8s-worker-node-3.formini.dz  
>192.168.249.136		k8s-worker-node-4	  k8s-worker-node-4.formini.dz  

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

# Déploiement du cluster Kubernetes
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

### pour exploiter l'API kubernetes par votre simple utilisateur 
>mkdir -p $HOME/.kube  
>cp -i /etc/kubernetes/admin.conf $HOME/.kube/config  
>chown $(id -u):$(id -g) $HOME/.kube/config  

Ceci vous fera éviter d'exporter la variable `export KUBECONFIG=/etc/kubernetes/admin.conf` à chaque ouverture de session
### préparer le réseau flannel
mettre en place un réseau [flannel](https://coreos.com/flannel/docs/latest/?source=post_page---------------------------) pour les pods
```shell
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
```
### verifier l'état du master k8s
```shell
kubectl get nodes
```

#Déploiement des worker nodes Kubernetes
## on worker
### installation des packages kubernetes
```shell
yum install kubelet kubeadm kubectl
```
### start & enable kubelet
```shell
systemctl enable kubelet && systemctl start kubelet
```
### joindre les worker nodes to master k8s
***si vous n'avez pas garder le token générer lors de l'initiation du master, la commande `kubeadm token create --print-join-command` vous permez de récupérer le toket***
```shell
>kubeadm join 192.168.249.132:6443 --token z0bhwc.nw3fkfz0q6g5xrq0 \  
>    --discovery-token-ca-cert-hash sha256:e3f1bd2f3536118fca1f2af754b62e794b3485b8b1365d714510308526372158  
```
puis verifier l'état de notre cluster
>[root@k8s-master ~]# export KUBECONFIG=/etc/kubernetes/admin.conf  
>[root@k8s-master ~]#  
>[root@k8s-master ~]# kubectl get nodes  
>NAME                              STATUS     ROLES    AGE     VERSION  
>k8s-master.formini.dz             Ready      master   2d22h   v1.15.1  
>k8s-worker-node-1.formini.dz      Ready      worker   2d15h   v1.15.1  
>k8s-worker-node-2.formini.dz      Ready      worker   2d15h   v1.15.1  
>k8s-worker-node-3.formini.dz      Ready      worker   2d1h    v1.15.1  
>k8s-worker-node-4.formini.dz      Ready      worker   46h     v1.15.1  

---------------------------------------
[kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/?source=post_page---------------------------)
