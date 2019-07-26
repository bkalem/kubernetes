# Preparation all VMs
## prérequis network plugin
```shell
vi /etc/sysctl.d/k8s.conf
```
```shell
swapoff -a
yum install kubelet kubeadm kubectl
```
