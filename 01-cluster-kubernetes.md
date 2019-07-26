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

d
