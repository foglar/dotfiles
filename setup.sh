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

if [[ $(os) -eq 0 ]]; then
  echo "[*] Detected Arch Linux"
  install="pacman -S"
  echo "[*] Updating repositories"
  sudo pacman -Suy
  echo "[*] Adding blackarch repositories"
  curl -O https://blackarch.org/strap.sh
  echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
  chmod +x strap.sh
  sudo ./strap.sh 
fi

echo "[*] Installing packages"
sudo $install neovim alacritty tmux unzip npm go python3 neofetch exa paru lolcat cmatrix ranger yt-dlp ncdu ripgrep entr jp2a figlet fzf thefuck espeak-ng htop wget tldr
paru -S autojump 

# FONTS
echo "[*] Download JetBrainsMono Nerd font"
wget --output-document JetBrainsMono.zip "https://github.com/ryanoasis/nerd-font  s/releases/download/v3.0.2/JetBrainsMono.zip"
mkdir ~/.local/share/fonts/
unzip JetBrainsMono.zip -d  ~/.local/share/fonts
fc-cache -vf

# OH-MY-POSH
echo "[*] Installing oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s
echo [*] Copy oh-my-posh theme
mkdir ~/.themes
cp .themes/kali.omp.json ~/.themes/

# NEOVIM
echo "[*] Cloning NvChad setup"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 2
echo "[!] Attention, this action will rewrite your current nvim config!!! Press [Enter] to continue..."
read
echo "[*] Copying neovim setup"
cp -r .config/nvim/lua/custom ~/.config/nvim/lua/

# ALACRITTY
echo "[*] Cloning Alacritty themes"
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# TMUX
echo "[*] Tmux TPM install"
mkdir -p ~/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "[*] Copy tmux config"
if [[ ! -f "/home/foglar/.config/tmux/tmux.conf" ]]; then
  cp .config/tmux/tmux.conf ~/.config/tmux/
else
  echo "File ~/.config/tmux/tmux.conf already exist, remove it to setup config."
fi

# NEOFETCH
echo "[*] Copy neofetch config"
if [[ ! -f "/home/foglar/.config/neofetch/config.conf" ]]; then
  mkdir ~/.config/neofetch
  cp .config/neofetch/config.conf ~/.config/neofetch/
else
  echo "File ~/.config/neofetch/config.conf already exist, remove it to setup config."
fi

# TERMINAL
echo "Would you like to replace your .bashrc file? [y/n]"
read -r ANS
if [[ $ANS=="y" ]]; then
  echo "[*] Copy .bashrc"
  cp .bashrc ~/
else
  echo "[-] Skip Copy .bashrc"
fi
echo "Would you like to replace your .bash_aliases file [y/n]"
read -r ANS1
if [[ $ANS1 == "y" ]]; then
  echo "[*] Copy .bash_aliases"
  cp .bash_aliases ~/
else
  echo "[-] Skip Copy .bash_aliases"
fi

echo "[?] To update your tmux config press <CTRL-SPACE>+I"
echo "[?] To install syntax highlighting in neovim run ':TSInstall <language_name>'"
sleep 4

tmux &
nvim
