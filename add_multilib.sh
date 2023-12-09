#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run the script as root or using sudo."
    exit 1
fi

# Check if multilib is already enabled
if grep -q "\[multilib\]" /etc/pacman.conf && ! grep -q "^#.*\[multilib\]" /etc/pacman.conf; then
    echo "Multilib repository is already enabled."
    exit 0
fi

# Backup the original pacman.conf file
cp /etc/pacman.conf /etc/pacman.conf.bak

# Uncomment multilib repository if present
sed -i '/^\s*#.*\[multilib\]/s/^#//' /etc/pacman.conf

echo "Multilib repository enabled. Please update your package databases using 'pacman -Sy'."
