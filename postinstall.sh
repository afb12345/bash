#!/bin/sh

read -p "IP/sn? " ip
echo $ip
read -p "GW? " gw
echo $gw
read -p "user? " user
echo $user

apt update
apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
/usr/sbin/dpkg-reconfigure --priority=low unattended-upgrades
apt upgrade -y

/usr/sbin/runuser -l $user -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "chmod 700 ~/.ssh"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
/usr/sbin/update-grub

sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
echo "   address $ip" >> /etc/network/interfaces
echo "   gateway $gw" >> /etc/network/interfaces
