# v86-tce-linux-builder

This repo contains scripts to create an [Tiny Core Linux](http://tinycorelinux.net/) image for use with [now](https://github.com/cemalgnlts/now/).

This repo contains a customized version of the following repo: [cemalgnlts/v86-tce-linux-builder](https://github.com/cemalgnlts/v86-tce-linux-builder/)

## Requirements

You need to have installed:

1. packer
2. qemu-system-x86

## Build

```bash
./build.sh
```

## Test
```bash
qemu-system-x86_64 --enable-kvm -nographic -serial mon:stdio -drive file=output/tcelinux.img,format=raw
```

## Manual Start
```bash
qemu-img create output/tcelinux 250M
sudo qemu-system-x86_64 -drive file=output/tcelinux.img,format=raw -cdrom /root/.cache/packer/e762d3f9c7a9ff32334a9c36632f68d4ec21fa15.iso -enable-kvm -curses
```

Influenced by these resources for the installation:
- https://github.com/ognivo777/packer.TinyCoreLinux/blob/master/TinyCoreLinux.json
- https://github.com/paulera/setup-tinycore-scripts/blob/master/tinycore-install