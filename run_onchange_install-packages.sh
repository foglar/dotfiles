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
echo 26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh | sha1sum -c 
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syyu --noconfirm
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
     done < <(cut -d '#' -f 1 "$category")


    if [ -n "$pkg_arch" ]; then
        echo "installing $pkg_arch from arch repo..."
        sudo pacman -S $pkg_arch --noconfirm
    fi

    if [ -n "$pkg_aur" ]; then
        echo "installing $pkg_aur from aur..."
        "$aurhlpr" "${use_default}" -S $pkg_aur
    fi
}

execute_script() {
    local script_name="$1"
    read -p "Execute $script_name? [Y/n]: " choice
    if [[ !($choice == [Nn]) ]]; then
        echo "Executing $script_name..."
        "$HOME/.local/bin/setup_scripts/$script_name"
    else
        echo "Skipping $script_name..."
    fi
}

if ! pkg_installed git; then
    echo "installing dependency git..."
    sudo pacman -S git --noconfirm
fi

repositories_config
chk_aurh

if [ -z "$aurhlpr" ]; then
    echo "installing dependency $aurhlpr..."
    $HOME/.local/bin/setup_scripts/install_aur.sh "yay" 2>&1
fi

# List of category files
categories=(games.lst hyprland.lst nvidia.lst programming.lst tools-apps.lst hacking.lst internet.lst other.lst term-tools.lst)

echo "$green[*]$blue Cloning NvChad setup$reset"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 2

# Prompt the user for each category file
for category_file in "${categories[@]}"; do
    read -p "Install packages from $category_file? [Y/n]: " category_choice
    if [[ !($category_choice == [nN]) ]]; then
        install_category "$HOME/.local/share/packages/$category_file"
    fi
done

read -p "Install TMUX TPM plugin? [Y/n]: " choice
if [[ !($choice == [nN]) ]]; then
  echo "$green[*]$blue Tmux TPM install$reset"
  mkdir -p ~/.config/tmux/plugins/
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

scripts_to_execute=(setup_conda.sh setup_qemu.sh setup_fonts.sh)

# Execute each script with confirmation
for script in "${scripts_to_execute[@]}"; do
    execute_script "$script"
done

echo "Installation complete."

