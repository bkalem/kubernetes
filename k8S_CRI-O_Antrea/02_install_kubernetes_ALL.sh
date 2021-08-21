#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
echo "######## [TASK1] sysctl bridge ########"
sudo cat > /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

echo "######## [TASK2] desactivation et off swap ########"
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

echo "######## [TASK3] repository Kubernetes ########"
sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "######## [TASK4] installation Kubernetes ########"
sudo dnf install kubeadm kubelet kubectl tc -y

sudo cat <<EOF >> /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
Environment="KUBELET_EXTRA_ARGS=--feature-gates='AllAlpha=false,RunAsGroup=true' --container-runtime=remote --cgroup-driver=systemd --container-runtime-endpoint='unix:///var/run/crio/crio.sock' --runtime-request-timeout=5m"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"
EOF

echo "######## [TASK5] Cri-o comme CRIs ########"
export CONTAINER_RUNTIME_ENDPOINT='/var/run/crio/crio.sock'
export CGROUPE_DRIVER=systemd

echo "######## [TASK6] start kubelet ########"
sudo systemctl daemon-reload
sudo systemctl enable --now kubelet
#end