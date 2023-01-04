#!/bin/sh

read -p "hostname? " hostname
echo $hostname
read -p "IP/sn? " ip
echo $ip
read -p "GW?    " gw
echo $gw
read -p "user?    " user
echo $user
read -p "ssh port?    " port
echo $port
read -p "public key?    " key
echo "RESIZE DISK NOW"
read -p "Ready to go?    " nowhere

### UPDATE & DEFAULT PACKAGES ###
apt update
apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
/usr/sbin/dpkg-reconfigure --priority=low unattended-upgrades
apt upgrade -y

### QUICK GRUB ###
cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo /usr/sbin/update-grub

### CHANGE IP, SUBNET AND HOSTNAME ###
sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
echo "   address $ip" >> /etc/network/interfaces
echo "   gateway $gw" >> /etc/network/interfaces
hostnamectl set-hostname $hostname
echo "127.0.1.1       $hostname.lan   $hostname" >> /etc/hosts

### MAKE SUPERUSER AND GRANT PUB KEY ###
sudo usermod -aG sudo $user
/usr/sbin/runuser -l $user -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "echo 'ssh-rsa $key' >> /home/$user/.ssh/authorized_keys"

### SECURE SSH ###
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
echo "Port $port" >> /etc/ssh/sshd_config &&
echo "AddressFamily inet" >> /etc/ssh/sshd_config &&
sed -i -n '/PermitRootLogin yes/!p' /etc/ssh/sshd_config &&
echo "PermitRootLogin no" >> /etc/ssh/sshd_config &&
sed -i -n '/PasswordAuthentication yes/!p' /etc/ssh/sshd_config &&
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
systemctl restart sshd

### ASK FOR DISK DETAILS ###
echo "##############################################################################"
sudo fdisk -l
echo "##############################################################################"
read -p "end of VDA5?    " endp
read -p "total sectors?    " sectors
startn=$((endp+1))
max=$((sectors-1))
sizen=$((max-endp))

### CREATE NEW LVM ###
echo "label: dos
label-id: 0x3b59eaa5
device: /dev/vda
unit: sectors
sector-size: 512
/dev/vda1 : start=        2048, size=      997376, type=83, bootable
/dev/vda2 : start=     1001470, size=    7385090, type=5
/dev/vda3 : start=    $startn, size=    $sizen, type=8e
/dev/vda5 : start=     1001472, size=    7385088, type=8e" >> partition
sudo sfdisk /dev/vda < partition --force
rm partition
sudo partx -a /dev/vda3 /dev/vda
sudo pvcreate /dev/vda3
sudo vgextend debian-vg /dev/vda3
sudo pvscan
sudo lvextend /dev/debian-vg/root /dev/vda3
sudo resize2fs /dev/debian-vg/root

### DONE ###
read -p "Ready to reboot?    " nowhere
sudo reboot
