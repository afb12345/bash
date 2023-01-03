#!/bin/bash

#echo "Username 1?"
#read user1
#echo "Username 2?"
#read user2

#adduser $user1
#adduser $user2

echo "IP?"
read $ip
echo "Gateway?"
read $gw

sudo apt update
sudo apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
sudo apt upgrade -y

#usermod -aG sudo $user1
#usermod -aG sudo $user2
#runuser -l $user1 -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
#runuser -l $user2 -c "mkdir ~/.ssh && chmod 700 ~/.ssh"

mkdir ~/.ssh
chmod 700 ~/.ssh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
sudo cp /etc/default/grub /etc/default/grub_backup
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub
sudo update-grub

sudo sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
sudo echo "   address $ip" >> /etc/network/interfaces
sudo echo "   gateway $gw" >> /etc/network/interfaces
