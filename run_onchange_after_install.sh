#!/bin/bash

#echo "█▀▀ █▀█ █▀▀ █░░ ▄▀█ █▀█"
#echo "█▀░ █▄█ █▄█ █▄▄ █▀█ █▀▄"

source ~/.bashrc

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

repositories_config()
{
    echo "$green[*]$blue Updating repositories$reset"
    echo "$green[*]$blue Adding blackarch repositories$reset"
    curl -O https://blackarch.org/strap.sh 
    echo 26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh | sha1sum -c 
    chmod +x strap.sh
    sudo ./strap.sh
    sudo pacman -Syyu --noconfirm
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
    echo "$green[*]$blue Installing packages from $category$reset"
    while IFS= read -r pkg; do
        if [ -n "$pkg" ]; then
            if pkg_installed "$pkg"; then
                echo "$green[*]$blue skipping $pkg..."
            elif pkg_available "$pkg"; then
                echo "$green[*]$blue queueing $pkg from arch repo..."
                pkg_arch+=" $pkg"
            elif aur_available "$pkg"; then
                echo "$blue[*]$green queueing $pkg from aur..."
                pkg_aur+=" $pkg"
            else
                echo "$red[!] error: unknown package $pkg..."
            fi
        fi
    done < <(cut -d '#' -f 1 "$category")


    if [ -n "$pkg_arch" ]; then
        echo "$green[*]$blue installing $pkg_arch from arch repo..."
        sudo pacman -S $pkg_arch --noconfirm
    fi

    if [ -n "$pkg_aur" ]; then
        echo "$green[*]$blue installing $pkg_aur from aur..."
        "$aurhlpr" "${use_default}" -S $pkg_aur --noconfirm
    fi
}

list_dir() {
    local search_dir=$1
    local categories=()

    for entry in "$search_dir"/*; do
        filename=$(basename "$entry")
        categories+=("$filename")
    done

    # Print the list
    echo "${categories[@]}"
}

list_scripts() {
    local search_dir="$1"
    local scripts=()

    # List folders containing scripts
    for script in "$search_dir"/setup_*; do
        if [ -f "$script" ]; then
            filename=$(basename "$script")
            scripts+=("$filename")
        fi
    done

    # Print the list
    echo "${scripts[@]}"
}

execute_script() {
    local script_name="$1"
    read -p "$blue[?] Execute $script_name? [Y/n]: " choice
    if [[ !($choice == [Nn]) ]]; then
        echo "$green[*]$blue Executing $script_name...$reset"
        "$HOME/.local/bin/setup_scripts/$script_name"
    else
        echo "$green[-] Skipping $script_name..."
    fi
}

if ! pkg_installed git; then
    echo "$green[*]$blue Installing dependency git...$reset"
    sudo pacman -S git --noconfirm
fi

if ! pkg_installed go; then
    echo "$green[*]$blue Installing dependency go...$reset"
    sudo pacman -S go --noconfirm
fi

repositories_config
chk_aurh

if [ -z "$aurhlpr" ]; then
    echo "$red[!] Installing dependency $aurhlpr...$reset"
    $HOME/.local/bin/setup_scripts/install_aur.sh "yay" 2>&1
fi

categories=$(list_dir $HOME/.local/share/packages/)
for category_file in ${categories[@]}; do
    read -p "$blue[?] Install packages from $category_file? [Y/n]: " category_choice
    if [[ !($category_choice == [nN]) ]]; then
        install_category "$HOME/.local/share/packages/$category_file"
    fi
done

echo "$green[*]$blue Install emoji font$reset"
fc-cache -vf

read -p "$blue[?] Install TMUX TPM plugin? [Y/n]: " choice
if [[ !($choice == [nN]) ]]; then
    echo "$green[*]$blue Tmux TPM install$reset"
    mkdir -p ~/.config/tmux/plugins/
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "$green[-] Skipping..."
fi

scripts_to_execute=($(list_scripts "$HOME/.local/bin/setup_scripts/"))
for script in ${scripts_to_execute[@]}; do
    execute_script "$script"
done

echo "$green[*]$blue Installation complete.$reset"

read -p "[?] Cleanup after installation [Y/n]: " choice
if [[ !($choice == [nN]) ]]; then
    current_dir=$(pwd)
    echo "$red[!] Cleaning up...$reset"
    rm $current_dir/strap.sh
    rm -rf ~/Clone/yay
    rm ~/Clone/.directory
    rmdir ~/Clone
    rm ~/README.md
fi
