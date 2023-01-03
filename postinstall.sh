#!/bin/sh

read -p "IP/sn? " ip
echo $ip
read -p "GW? " gw
echo $gw
read -p "user? " user
echo $user
read -p "key? " key
#set key = "AAAAB3NzaC1yc2EAAAADAQABAAACAQCmxbfBGmYTfAXUgoSjZXjCr6WZ1a5D3EegyDntCN5U47HX0o3AHqD/JB0sPVP2wQoqP9ZaTgD9xVURP1to44mCBqOK2FcdDcpgU5jk5u3JTrFNFAS41nCWvH5QFBENwi3iwjPB5g8bDh0pvjhff/ad2/jN5+zjkIkpV1TzDSiLMco3SUiZcCcVwUg0qSTUqmfuIDezGp/i6CuDx/QiRP6LsdblGzg6BN0Z6JtWherGsnHbBY3qXA21A0QoEu4afqJI+l5CBlgk//HL2VPjfhKiIuaTRSSeOEHshXQVjMdLmLWJ7v/tL+BFSP0/6OFeD6f367W0Wu0o/UKqG+GtbeHn4myegPhq7YAjU0TlFW4U1G7/phOqD8F56k0eVNqpbjVVGhE/PBG1LIkPv7oWXME3vJvWtfVHY8cINd0PEUL2DfDKaxnx8oApKsv0nFQUYVKqmuxM5c9nNagWALNVe9sbqVxrZmf/ebJdhXGnAiKn4TRF6NDKSq3YWoCugQgFRlVKYa8DRkTHretQdQXekBcowQQKxyuNQt20Uq9Q6fZXs62+YKYsRDBk85cdkOYUyff/KeN6rHxuWW/MBNIkyjXpIpsID7prA+lmBFEuVCt/acqeZNTajB4FU7hxSnWEmVP9FIM4z+vNv5YR9Q4WBZCAqJdUWz5ZqOsIFcCQb33ZcQ=="

apt update
apt install unattended-upgrades curl wget sudo nfs-common gnupg nano -y
/usr/sbin/dpkg-reconfigure --priority=low unattended-upgrades
apt upgrade -y

/usr/sbin/runuser -l $user -c "mkdir ~/.ssh && chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "chmod 700 ~/.ssh"
/usr/sbin/runuser -l $user -c "echo 'ssh-rsa $key' >> ~/.ssh/authorized_keys"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
/usr/sbin/update-grub

sed -i 's/inet dhcp/inet static/' /etc/network/interfaces
echo "   address $ip" >> /etc/network/interfaces
echo "   gateway $gw" >> /etc/network/interfaces
