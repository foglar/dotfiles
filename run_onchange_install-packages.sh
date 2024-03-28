#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

pkg_installed() {
    local PkgIn=$1

    if pacman -Qi "$PkgIn" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

pkg_available() {
    local PkgIn=$1

    if pacman -Si "$PkgIn" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

chk_aurh() {
    if pkg_installed yay; then
        aurhlpr="yay"
    elif pkg_installed paru; then
        aurhlpr="paru"
    fi
}

aur_available() {
    local PkgIn=$1
    chk_aurh

    if "$aurhlpr" -Si "$PkgIn" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

if ! pkg_installed git; then
    echo "installing dependency git..."
    sudo pacman -S git
fi

chk_aurh

if [ -z "$aurhlpr" ]; then
    echo "installing dependency $aurhlpr..."
    install_aur.sh "yay" 2>&1
fi

install_category() {
    category="$1"
    echo "Installing packages from $category..."
    while IFS= read -r pkg; do
        if [ -n "$pkg" ]; then
            if pkg_installed "$pkg"; then
                echo "skipping $pkg..."
            elif pkg_available "$pkg"; then
                echo "queueing $pkg from arch repo..."
                pkg_arch+=" $pkg"
            elif aur_available "$pkg"; then
                echo "queueing $pkg from aur..."
                pkg_aur+=" $pkg"
            else
                echo "error: unknown package $pkg..."
            fi
        fi
    done < <(cut -d '#' -f 1 "$category")

    if [ -n "$pkg_arch" ]; then
        echo "installing $pkg_arch from arch repo..."
        sudo pacman "${use_default}" -S $pkg_arch
    fi

    if [ -n "$pkg_aur" ]; then
        echo "installing $pkg_aur from aur..."
        "$aurhlpr" "${use_default}" -S $pkg_aur
    fi
}

install_list="${1:-$HOME/.local/share/packages/term-tools.lst}"

while read -r category; do
    if [ -f "$category" ]; then
        read -p "Do you want to install packages from $category? (y/n): " answer
        if [ "$answer" = "y" ]; then
            install_category "$category"
        fi
    fi
done <<<"games.lst
hacking.lst
hyprland.lst
internet.lst
nvidia.lst
other.lst
programming.lst
term-tools.lst
tools-apps.lst"

echo "Installation complete."

