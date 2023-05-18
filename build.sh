#!/bin/sh

SRC=packer
TARGET=output

rm $packer/packer.log

# build the boxfile from the iso
(cd $SRC && sudo PACKER_LOG=1 PACKER_LOG_PATH="./packer.log" packer build -force template.json)

# test if there is a boxfile where we expected it
if [ ! -f $SRC/output-qemu/tcelinux ]; then
    echo "Looks like something went wrong building the image, maybe try again?"
    exit 1
fi;

# Move the image to the target dir
sudo mv $SRC/output-qemu/tcelinux $TARGET/tcelinux.img