echo "Clear installed packages"
rm -f /tmp/tce/onboot.lst
rm -rf /tmp/tce/optional/*

#########################

echo "Node installing"
tce-load -wi node

time node --version
time node --version

#########################

echo "Save installed packages"
sudo mv /tmp/tce/onboot.lst /mnt/sda1/tce/
sudo mv /tmp/tce/optional/* /mnt/sda1/tce/optional/