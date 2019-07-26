# Preparation all VMs
## prérequis network plugin
ajouter ces 3 lignes dans le fichiers `/etc/sysctl.d/k8s.conf`
```shell
vi /etc/sysctl.d/k8s.conf
>net.bridge.bridge-nf-call-iptables = 1
>>net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
```
```

```
## désactiver le swap
```shell
swapoff -a
yum install kubelet kubeadm kubectl
```
