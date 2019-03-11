#!/usr/bin/env bash

sudo add-apt-repository -y ppa:vbernat/haproxy-1.8

sudo apt-get update
sudo apt-get -y install nfs-kernel-server
sudo apt-get install -y haproxy
sudo apt-get install -y libopenmpi-dev #mpi
sudo apt-get install -y openmpi-bin #mpi
sudo apt-get install -y sshpass

sudo mkdir -p /export/shared
sudo mkdir /shared
sudo chmod 777 /{export,shared} && sudo chmod 777 /export/*
sudo mount --bind /shared /export/shared
echo "/export/shared *(rw,fsid=0,insecure,no_subtree_check,async)" >> /etc/exports

sudo bash -c "cat /vagrant/confHAProxy > /etc/haproxy/haproxy.cfg"

sudo  sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo -e "\n\n\n" | ssh-keygen -t rsa

sudo service nfs-kernel-server restart
sudo service haproxy restart
sudo service sshd restart
