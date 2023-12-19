#!/bin/bash

sudo pacman -Syy
sudo pacman -S archlinux-keyring qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat dmidecode ebtables iptables libguestfs --needed

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
systemctl status libvirtd.service libguestfs

echo "Enable line unix_sock_group = 'libvirt' (+-85)"
echo "Enable line unix_sock_rw_perms = '0770' (+- 102)"
sleep 4
echo "Enter to proceed to file"
read -r 
sudoedit /etc/libvirt/libvirtd.conf

sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
sudo systemctl restart libvirtd.service

# CMD to start network for qemu - sudo virsh net-start default
