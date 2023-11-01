#!/bin/bash
# Copy all settings
# required packages: git

echo """   __  ___       ___           __     __   _
  /  |/  /_ __  / _ | ________/ /    / /  (_)__  __ ____ __
 / /|_/ / // / / __ |/ __/ __/ _ \\  / /__/ / _ \\/ // /\\ \\ /
/_/  /_/\\_, / /_/ |_/_/  \\__/_//_/ /____/_/_//_/\\_,_//_\\_\\
       /___/
"""
# Determine users distro
os ()
{
  os=$(hostnamectl | grep 'Operating System:')
  if [[ $os == "Operating System: Arch Linux" ]]; then
    return "0"
  elif [[ $os == "Operating System: Kali GNU/Linux Rolling" ]]; then
    return "1"
  fi
}

if [[ $os == 0 ]]; then
  echo "[*] Detected Arch Linux"
  install = "pacman -S"
  sudo pacman -Suy
  echo "[*] Adding blackarch repositories"
  curl -O https://blackarch.org/strap.sh
  echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
  chmod +x strap.sh
  sudo ./strap.sh 
fi

if [[ $(os) -eq 1 ]]; then
  echo "[*] Detected Debian"
  sudo apt update && sudo apt upgrade -y
  install="apt-get"
fi

echo "[*] Installing packages"
sudo $install neovim alacritty tmux unzip npm go python3 neofetch exa paru

echo "[*] Installing oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s

echo "[*] Cloning NvChad setup"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 2

echo "[*] Cloning Alacritty themes"
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

echo "[!] Attention, this action will rewrite your current nvim config!!!"
read
echo "[*] Copying neovim setup"
cp -r .config/nvim/lua/custom ~/.config/nvim/lua/

echo "Would you like to replace your .bashrc file? [y/n]"
read -r ANS
if [[ $ANS=="y" ]]; then
  echo "[*] Copy .bashrc"
  cp .bashrc ~/
else
  echo "[-] Skip Copy .bashrc"
fi
read -r ANS1
if [[ $ANS1 == "y" ]]; then
  echo "[*] Copy .bash_aliases"
  cp .bash_aliases ~/
else
  echo "[-] Skip Copy .bash_aliases"
fi

echo [*] Copy tmux config
cp .config/tmux/tmux.conf ~/.config/tmux/
echo [*] Copy oh-my-posh theme
mkdir ~/.themes
cp .themes/kali.omp.json ~/.themes/
echo "[*] Copy neofetch config"
cp .config/neofetch/config.conf ~/.config/neofetch/

echo "[?] To update your tmux config press <CTRL-SPACE>+I"
echo "[?] To install syntax highlighting in neovim run ':TSInstall <language_name>'"
sleep 2

nvim
tmux
