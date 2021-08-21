#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
echo "######## [TASK1] overlay netfilter ########"
# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

echo "######## [TASK2] sysctl bridge ########"

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

echo "######## [TASK3] install CRI-O ########"

sudo dnf install -y curl jq tar
sudo wget -O /tmp/crio-get-script.sh https://raw.githubusercontent.com/cri-o/cri-o/master/scripts/get
sudo bash /tmp/crio-get-script.sh

echo "######## [TASK4] start CRI-O ########"
sudo systemctl daemon-reload
sudo systemctl enable --now crio 
#end