#!/bin/sh

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

apt update
apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
dpkg-reconfigure --priority=low unattended-upgrades
apt upgrade -y

#usermod -aG sudo $user1
#usermod -aG sudo $user2
#runuser -l $user1 -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
#runuser -l $user2 -c "mkdir ~/.ssh && chmod 700 ~/.ssh"

mkdir ~/.ssh
chmod 700 ~/.ssh
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub
update-grub

sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
echo "   address $ip" >> /etc/network/interfaces
echo "   gateway $gw" >> /etc/network/interfaces
