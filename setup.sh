#!/bin/bash
# Copy all settings
# required packages: git

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

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

if [[ $(os) -eq 0 ]]; then
  echo "$green[*]$blue Detected Arch Linux"
  install="paru -S"
  echo "$green[*]$blue Updating repositories"
  sudo pacman -Suy
  echo "$green[*]$blue Adding blackarch repositories"
  curl -O https://blackarch.org/strap.sh
  echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
  chmod +x strap.sh
  sudo ./strap.sh 
  sudo pacman -S paru
  read -r VAR
fi

echo "$green[*]$blue Installing packages"
$install neovim alacritty tmux unzip npm go python3 neofetch exa paru lolcat cmatrix ranger yt-dlp ncdu ripgrep entr jp2a figlet fzf thefuck espeak-ng htop wget tldr autojump tgpt-bin 

# FONTS
echo "$green[*]$blue Download JetBrainsMono Nerd font"
wget --output-document JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
mkdir ~/.local/share/fonts/
unzip JetBrainsMono.zip -d  ~/.local/share/fonts
fc-cache -vf

# OH-MY-POSH
echo "$green[*]$blue Installing oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s
echo "$green[*]$blue Copy oh-my-posh theme"
mkdir ~/.themes
cp .themes/kali.omp.json ~/.themes/

# NEOVIM
echo "$green[*]$blue Cloning NvChad setup"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 2
echo "$red[!] Attention, this action will rewrite your current nvim config!!! Press [Enter] to continue..."
read
echo "$green[*]$blue Copying neovim setup"
cp -r .config/nvim/lua/custom ~/.config/nvim/lua/

# ALACRITTY
echo "$green[*]$blue Cloning alacritty setup file"
mkdir -p ~/.config/alacritty/themes
cp .config/alacritty/alacritty.yml ~/.config/alacritty/
echo "$green[*]$blue Cloning Alacritty themes"
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# TMUX
echo "$green[*]$blue Tmux TPM install"
mkdir -p ~/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "$green[*]$blue Copy tmux config"
if [[ ! -f "/home/foglar/.config/tmux/tmux.conf" ]]; then
  cp .config/tmux/tmux.conf ~/.config/tmux/
else
  echo "$red[!] File ~/.config/tmux/tmux.conf already exist, remove it to setup config."
fi

# NEOFETCH
echo "$green[*]$blue Copy neofetch config"
if [[ ! -f "/home/foglar/.config/neofetch/config.conf" ]]; then
  mkdir ~/.config/neofetch
  cp .config/neofetch/config.conf ~/.config/neofetch/
else
  echo "$red[!] File ~/.config/neofetch/config.conf already exist, remove it to setup config."
fi

# TERMINAL
echo "$blue[?] Would you like to replace your .bashrc file? [y/n]"
read -r ANS
if [[ $ANS=="y" ]]; then
  echo "$green[*]$blue Copy .bashrc"
  cp .bashrc ~/
else
  echo "$red[-]$blue Skip Copy .bashrc"
fi
echo "$blue[?] Would you like to replace your .bash_aliases file [y/n]"
read -r ANS1
if [[ $ANS1 == "y" ]]; then
  echo "$green[*]$blue Copy .bash_aliases"
  cp .bash_aliases ~/
else
  echo "$red[-]$blue Skip Copy .bash_aliases"
fi

echo "$blue[?] To update your tmux config press <CTRL-SPACE>+I"
echo "$blue[?] To install syntax highlighting in neovim run ':TSInstall <language_name>'"
echo "$blue[?] You may have to restart terminal to se changes"
sleep 4

nvim
tmux

echo "Instalation end"
