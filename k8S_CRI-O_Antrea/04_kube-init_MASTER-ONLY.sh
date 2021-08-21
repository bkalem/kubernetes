#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
echo "######## [TASK1] first init cluster ########"
kubeadm init --pod-network-cidr=10.20.0.0/16