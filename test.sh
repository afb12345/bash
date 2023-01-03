#!/bin/sh

read -p "key? " key
read -p "user? " user
set test = test
echo test
/usr/sbin/runuser -l $user -c "echo 'ssh-rsa $key' >> /home/$user/.ssh/authorized_keys"
