echo "Create partition"
echo -e "n\np\n1\n\n\na\n1\nw" | sudo fdisk /dev/sda

echo "Format partition"
sudo mkfs.ext4 /dev/sda1
sudo rebuildfstab

echo "Mount disk"
sudo mount -t ext4 /mnt/sda1
sudo mount /mnt/sr0

echo "Create directories"
sudo mkdir -p /mnt/sda1/boot/grub
sudo mkdir -p /mnt/sda1/tce/optional

echo "Copy kernel"
sudo cp -p /mnt/sr0/boot/core.gz /mnt/sda1/boot/
sudo cp -p /mnt/sr0/boot/vmlinuz /mnt/sda1/boot/

echo "Install grub"
tce-load -wi grub2-multi liblvm2
sudo grub-install --boot-directory=/mnt/sda1/boot/ /dev/sda

echo "Create menu for GRUB"
sudo sh -c 'echo menuentry "Tiny Core" { >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo -e "set root=(hd0,0)\nset setup=(hd0)" >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo  linux /boot/vmlinuz com1=9600,8n1 loglevel=3 user=tc console=serial0 noembed nomodeset tce=sda1 opt=sda1 home=sda1 restore=sda1 >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo  initrd /boot/core.gz >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo } >> /mnt/sda1/boot/grub/grub.cfg'