echo "label: dos
label-id: 0x3b59eaa5
device: /dev/vda
unit: sectors
sector-size: 512

/dev/vda1 : start=        2048, size=      997376, type=83, bootable
/dev/vda2 : start=     1001470, size=    15773698, type=5
/dev/vda3 : start=    16775168, size=    16779264, type=8e
/dev/vda5 : start=     1001472, size=    15773696, type=8e" >> partition
sudo sfdisk /dev/vda < partition --force
sudo partx -a /dev/vda3 /dev/vda
sudo pvcreate /dev/vda3
sudo vgextend debian-vg /dev/vda3
sudo pvscan
sudo lvextend /dev/debian-vg/root /dev/vda3
sudo resize2fs /dev/debian-vg/root
