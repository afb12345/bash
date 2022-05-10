#!/bin/bash

apt update
apt install unattended-upgrades curl sudo nfs-common gnupg -y
dpkg-reconfigure --priority=low unattended-upgrades
timedatectl set-timezone Europe/Amsterdam
apt upgrade -y
apt dist-upgrade -y
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
cp /etc/default/grub /etc/default/grub_backup
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
echo "GRUB_HIDDEN_TIMEOUT_QUIET=true" >> /etc/default/grub
update-grub
