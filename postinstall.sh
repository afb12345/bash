#!/bin/bash

apt update
apt install unattended-upgrades curl sudo nfs-common gnupg -y
dpkg-reconfigure --priority=low unattended-upgrades
timedatectl set-timezone Europe/Amsterdam
apt upgrade -y
apt dist-upgrade -y
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup
