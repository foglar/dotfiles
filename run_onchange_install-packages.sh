#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

repositories_config()
{
echo "$green[*]$blue Updating repositories$reset"
echo "$green[*]$blue Adding blackarch repositories$reset"
curl -O https://blackarch.org/strap.sh 
echo 3f121404fd02216a053f7394b8dab67f105228e3 strap.sh | sha1sum -c 
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syyu
echo "$green[*]$blue Install paru - AUR helper$reset"
}

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

install_category() {
    local category="$1"
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
    done 

    if [ -n "$pkg_arch" ]; then
        echo "installing $pkg_arch from arch repo..."
        sudo pacman "${use_default}" -S $pkg_arch
    fi

    if [ -n "$pkg_aur" ]; then
        echo "installing $pkg_aur from aur..."
        "$aurhlpr" "${use_default}" -S $pkg_aur
    fi
}


if ! pkg_installed git; then
    echo "installing dependency git..."
    sudo pacman -S git
fi

repositories_config
chk_aurh

if [ -z "$aurhlpr" ]; then
    echo "installing dependency $aurhlpr..."
    /home/foglar/.local/bin/setup_scripts/install_aur.sh "yay" 2>&1
fi

install_list="${1:-$HOME/.local/share/packages/term-tools.lst}"

install_category $install_list

echo "Installation complete."

