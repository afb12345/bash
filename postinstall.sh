#!/bin/sh

read -p "IP/sn? " ip
echo $ip

apt update
apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
dpkg-reconfigure --priority=low unattended-upgrades
apt upgrade -y

/usr/sbin/runuser -l gfy -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
/usr/sbin/runuser -l gfy -c "chmod 700 ~/.ssh"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
update-grub

sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
echo "   address $ip" >> /etc/network/interfaces
echo "   gateway 10.10.0.1" >> /etc/network/interfaces
