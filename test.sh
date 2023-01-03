#!/bin/sh

read -p "key? " key
/usr/sbin/runuser -l $user -c "echo 'ssh-rsa $key' >> ~/.ssh/test"
