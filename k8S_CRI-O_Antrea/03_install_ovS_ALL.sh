#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
echo "######## [TASK1] installing RDO ########"
sudo dnf install -y https://www.rdoproject.org/repos/rdo-release.el8.rpm

echo "######## [TASK2] clean all ########"
sudo dnf clean all

echo "######## [TASK3]installing libibverbs ########"
sudo dnf install -y openvswitch libibverbs

echo "######## [TASK4]enable openvswitch ########"
sudo systemctl enable --now openvswitch
echo "########END########"