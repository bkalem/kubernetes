#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "

echo "###############################"
echo "Tested on Kubernetes cluster v1.16.2"
echo "Jan 8, 2021, 7:31:49 AM"
echo "###############################"

# create a backup folder
mkdir /tmp/backup/

# backup all old certificat and private key and move it to /tmp/backup/
cd /etc/kubernetes/pki/
mv {apiserver.crt,apiserver-etcd-client.key,apiserver-kubelet-client.crt,front-proxy-ca.crt,front-proxy-client.crt,front-proxy-client.key,front-proxy-ca.key,apiserver-kubelet-client.key,apiserver.key,apiserver-etcd-client.crt} /tmp/backup/

# re-generate all certificate
kubeadm init phase certs all --apiserver-advertise-address 172.20.10.110
sleep 1

# backup all old configuration files and move it to /tmp/backup/
cd /etc/kubernetes/
mv {admin.conf,controller-manager.conf,kubelet.conf,scheduler.conf} /tmp/backup/
mv $HOME/.kube/config /tmp/backup/

# re-generate all configuration files
kubeadm init phase kubeconfig all
sleep 1

# re-generate all configuration files
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

# coundown of 30seconds before reboot sa-k8s-master
for i in {30..01}
do
tput cup 10 $l
echo -n "sa-k8s-master will reboot in $i"
sleep 1
done
echo 

# reboot sa-k8s-master
reboot
