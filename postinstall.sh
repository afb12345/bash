#!/bin/sh
read -p "hostname? " hostname
echo $hostname
read -p "IP/sn? " ip
echo $ip
read -p "GW? " gw
echo $gw
read -p "user? " user
echo $user
read -p "ssh port? " port
echo $port
read -p "public key? " key

apt update
apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
/usr/sbin/dpkg-reconfigure --priority=low unattended-upgrades
apt upgrade -y

cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo /usr/sbin/update-grub

sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
echo "   address $ip" >> /etc/network/interfaces
echo "   gateway $gw" >> /etc/network/interfaces

hostnamectl set-hostname $hostname
sed -i 's/debian/$hostname/' /etc/hosts

sudo usermod -aG sudo $user

/usr/sbin/runuser -l $user -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "echo 'ssh-rsa $key' >> /home/$user/.ssh/authorized_keys"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
echo "Port $port" >> /etc/ssh/sshd_config &&
echo "AddressFamily inet" >> /etc/ssh/sshd_config &&
sed -i -n '/PermitRootLogin yes/!p' /etc/ssh/sshd_config &&
echo "PermitRootLogin no" >> /etc/ssh/sshd_config &&
sed -i -n '/PasswordAuthentication yes/!p' /etc/ssh/sshd_config &&
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
systemctl restart sshd
