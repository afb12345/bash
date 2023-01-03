sudo fdisk /dev/vda
n
default p
default 3
default
default
t
3
8e
w
sudo pvcreate /dev/vda3
sudo vgextend debian-vg /dev/vda3
sudo pvscan
sudo lvextend /dev/debian-vg/root /dev/vda3
sudo resize2fs /dev/debian-vg/root
