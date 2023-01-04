#!/bin/sh
echo "##############################################################################"
sudo fdisk -l
echo "##############################################################################"
read -p "end VDA5? " endp
read -p "total sectors " sectors
startn=$((endp+1))
max=$((sectors-1))
sizen=$((max-endp))

echo "START VDA3"
echo $startn
echo "MAX SIZE"
echo $max
echo "SIZE VDA3"
echo $sizen

echo "label: dos
label-id: 0x3b59eaa5
device: /dev/vda
unit: sectors
sector-size: 512

/dev/vda1 : start=        2048, size=      997376, type=83, bootable
/dev/vda2 : start=     1001470, size=    15773698, type=5
/dev/vda3 : start=    $startn, size=    $sizen, type=8e
/dev/vda5 : start=     1001472, size=    15773696, type=8e" >> partition
sudo sfdisk /dev/vda < partition --force
sudo partx -a /dev/vda3 /dev/vda
sudo pvcreate /dev/vda3
sudo vgextend debian-vg /dev/vda3
sudo pvscan
sudo lvextend /dev/debian-vg/root /dev/vda3
sudo resize2fs /dev/debian-vg/root
