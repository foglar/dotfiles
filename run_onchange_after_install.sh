#!/bin/bash

echo "█▀▀ █▀█ █▀▀ █░░ ▄▀█ █▀█"
echo "█▀░ █▄█ █▄█ █▄▄ █▀█ █▀▄"



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

# Define the function
list_scripts() {
    local search_dir="$1"
    local scripts=()

    # List folders containing scripts
    for entry in "$search_dir"/*; do
        if [ -d "$entry" ]; then
            # Iterate over files in each folder
            for script in "$entry"/setup_*; do
                if [ -f "$script" ]; then
                    filename=$(basename "$script")
                    scripts+=("$filename")
                fi
            done
        fi
    done

    # Print the list
    echo "${scripts[@]}"
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

if ! pkg_installed go; then
  echo "installing dependency go..."
  sudo pacman -S go --noconfirm
fi

repositories_config
chk_aurh

if [ -z "$aurhlpr" ]; then
    echo "installing dependency $aurhlpr..."
    $HOME/.local/bin/setup_scripts/install_aur.sh "yay" 2>&1
fi

categories=$(list_dir $HOME/.local/share/packages/)
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

echo "Install emoji font"
fc-cache -vf

scripts_to_execute=($(list_scripts "$HOME/.local/bin/setup_scripts/"))
for script in "${scripts_to_execute[@]}"; do
    execute_script "$script"
done

echo "Installation complete."

read -p "Cleanup after installation [Y/n]: " choice
if [[ !($choice == [nN]) ]]; then
  rm strap.sh
  rm -rf ~/Clone/yay
  rm ~/Clone/.directory
  rmdir Clone
  rm README.md
fi
