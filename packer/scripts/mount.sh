#!/bin/sh

echo "Create partition"
echo -e "n\np\n1\n\n\na\n1\nw" | sudo fdisk /dev/sda

echo "Format partition"
mkfs.ext4 /dev/sda1
sudo rebuildfstab

echo "Mount disk"
mkdir /mnt/sda1
sudo mount -t ext4 /dev/sda1 /mnt/sda1
mount /mnt/sr0

echo "Create directories"
sudo mkdir -p /mnt/sda1/boot/grub
sudo mkdir -p /mnt/sda1/tce/optional

echo "Copy kernel"
sudo cp -p /mnt/sr0/boot/core.gz /mnt/sda1/boot/
sudo cp -p /mnt/sr0/boot/vmlinuz /mnt/sda1/boot/

echo "Install grub"
tce-load -wi grub2-multi liblvm2
sudo /usr/local/sbin/grub-install --boot-directory=/mnt/sda1/boot /dev/sda

echo "Create menu for GRUB"
sudo sh -c 'echo -e "set root=(hd0,msdos1)\nset setup=(hd0)" >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo -e "set default=0\nset timeout=0" >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo menuentry \"Tiny Core\" { >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo  linux /boot/vmlinuz loglevel=3 user=tc console=tty0 console=ttyS0,115200 noembed nomodeset tce=sda1 opt=sda1 home=sda1 restore=sda1 >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo  initrd /boot/core.gz >> /mnt/sda1/boot/grub/grub.cfg'
sudo sh -c 'echo } >> /mnt/sda1/boot/grub/grub.cfg'

echo "Activate serial0"
sudo sh -c 'echo "console=ttyS0,115200" >> /mnt/sda1/boot/cmdline.txt'
sudo sh -c 'echo "enable_uart=1" >> /mnt/sda1/boot/config.txt'
# sudo mkdir /mnt/sda1/etc
# sudo cp /etc/inittab /mnt/sda1/etc/inittab
# sudo sh -c 'echo "ttyS0::respawn:/sbin/getty -L 115200 /dev/ttyS0 vt100" >> /mnt/sda1/etc/inittab'