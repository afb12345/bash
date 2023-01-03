#!/bin/sh

read -p "IP/sn? " ip
echo $ip

sudo apt update
sudo apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
sudo apt upgrade -y

mkdir ~/.ssh
chmod 700 ~/.ssh
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
sudo cp /etc/default/grub /etc/default/grub_backup
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub

sudo sed -i 's/   address 10.10.1.10/   address $ip/' /etc/network/interfaces
