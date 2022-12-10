#!/bin/bash


sudo tee /etc/hosts <<EOF >/dev/null
127.0.0.1 localhost
127.0.1.1 vagrant

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
192.168.100.10 master
192.168.100.20 worker-1
192.168.100.30 worker-2
192.168.100.40 client
EOF

sudo apt -y update && install -y sshpass clustershell
ssh-keygen /home/vagrant/.ssh/id_rsa -t rsa -N ''

sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no vagrant@client
sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no vagrant@master
sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no vagrant@worker-1
sshpass -p "vagrant" ssh-copy-id -f -o StrictHostKeyChecking=no vagrant@worker-2

cat << 'EOF' | sudo tee /etc/clustershell/groups.d/local.cfg >/dev/null
all: client,master,worker-1,worker-2
cl: client
dn: master,worker-1,worker-2
m: master
w: worker-1,worker-2
EOF

clush -g all -c /etc/hosts --dest /tmp/hosts
clush -g all "sudo cp /tmp/hosts /etc/hosts"

clush -g all "sudo apt install -y chrony"
sudo cp -a /etc/chrony/chrony.conf /etc/chrony/chrony.conf.org
sudo sed -i 's/^/# /g' /etc/chrony/chrony.conf
echo "pool ntp.nict.jp iburst" | sudo tee -a /etc/chrony/chrony.conf
clush -g all -c /etc/chrony/chrony.conf --dest /tmp/chrony.conf
clush -g all "sudo cp /tmp/chrony.conf /etc/chrony.conf"
clush -g all "sudo systemctl restart chrony"