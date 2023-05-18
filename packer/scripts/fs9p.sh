# This is the tricky part. The current root will be mounted on /dev/sda1 but after we reboot
# it will try to mount root during boot using the 9p network filesystem. This means the emulator
# will request all files over the network using XMLHttpRequests from the server. This is great
# because then you only need to provide the client with a saved state (the memory) and the
# session will start instantly and load needed files on the fly. This is fast and it saves bandwidth.
echo "Ensuring root is remounted using 9p after reboot"
mkdir -p /mnt/etc/initcpio/hooks
cat << 'EOF' > /mnt/etc/initcpio/hooks/9p_root
run_hook() {
    mount_handler="mount_9p_root"
}

mount_9p_root() {
    msg ":: mounting '$root' on real root (9p)"
    # Note the host9p. We won't mount /dev/sda1 on root anymore,
    # instead we mount the network filesystem and the emulator will
    # retrieve the files on the fly.
    if ! mount -t 9p host9p "$1"; then
        echo "You are now being dropped into an emergency shell."
        launch_interactive_shell
        msg "Trying to continue (this will most likely fail) ..."
    fi
}
EOF

echo "Adding initcpio build hook for 9p root remount"
mkdir -p /mnt/etc/initcpio/install
cat << 'EOF' > /mnt/etc/initcpio/install/9p_root
#!/bin/bash
build() {
	add_runscript
}
EOF