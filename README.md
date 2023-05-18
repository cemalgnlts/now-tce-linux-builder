# v86-tce-linux-builder

This repo contains scripts to create an [Tiny Core Linux](http://tinycorelinux.net/) image for use with [v86](https://github.com/copy/v86/).

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
qemu-system-x86_64 -hda output/tcelinux.img -curses
```

## Manual Start
```bash
qemu-img create output/tcelinux 100M
sudo qemu-system-x86_64 -drive file=output/tcelinux,format=raw -cdrom /root/.cache/packer/e762d3f9c7a9ff32334a9c36632f68d4ec21fa15.iso -curses
```