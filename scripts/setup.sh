#!/bin/bash
# Copy all settings
# required packages: git

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)
echo """                   ,.                   
                  '::,                  
     .          ll;,,;lc          :     
      ,OX;       ',,,,.       lKk,      
       .clok0XK  '    ' .XK0kocc.       
          'ccccl;      :lcccccc         
         .olccccc      ccccccc          
           :cccccl    lccccc:           
            ccccclk00xccccc:            
             :cccccccccccc;             
              :cccccccccc;              
               ;ccccl ;c;               
                :ccccldc                
                 ;cccc:                 
                  :ccc                  
                   :c                   
                                        
                                        """
echo """   ___           __     __   _               
  / _ | ________/ /    / /  (_)__  __ ____ __
 / __ |/ __/ __/ _ \  / /__/ / _ \/ // /\ \ /
/_/ |_/_/  \__/_//_/ /____/_/_//_/\_,_//_\_\ 
"""
read -r VAR
# ADDING REPOSITORIES
echo "$green[*]$blue Updating repositories$reset"
sudo pacman -Syu
echo "$green[*]$blue Adding blackarch repositories$reset"
curl -O https://blackarch.org/strap.sh 
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syy
echo "$green[*]$blue Install paru - AUR helper$reset"
sudo pacman -S paru

# PACKAGES
echo "$green[*]$blue Installing packages$reset"

# Install packages from the file

echo "Packages installation completed."

# FONTS
echo "$green[*]$blue Download JetBrainsMono Nerd font$reset"
wget --output-document JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
mkdir ~/.local/share/fonts/
unzip JetBrainsMono.zip -d  ~/.local/share/fonts
fc-cache -vf

# OH-MY-POSH
echo "$green[*]$blue Installing oh-my-posh$reset"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s
echo "$green[*]$blue Copy oh-my-posh theme$reset"
mkdir ~/.themes
cp .themes/kali.omp.json ~/.themes/

# NEOVIM
echo "$green[*]$blue Cloning NvChad setup$reset"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 2
echo "$red[!] Attention, this action will rewrite your current nvim config!!! Press [Enter] to continue...$reset"
read
echo "$green[*]$blue Copying neovim setup$reset"
cp -r .config/nvim/lua/custom ~/.config/nvim/lua/

# # ALACRITTY
# echo "$green[*]$blue Cloning alacritty setup file$reset"
# mkdir -p ~/.config/alacritty/themes
# cp .config/alacritty/alacritty.yml ~/.config/alacritty/
# echo "$green[*]$blue Cloning Alacritty themes$reset"
# git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# TMUX
echo "$green[*]$blue Tmux TPM install$reset"
mkdir -p ~/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "$green[*]$blue Copy tmux config$reset"
if [[ ! -f "/home/foglar/.config/tmux/tmux.conf" ]]; then
  cp .config/tmux/tmux.conf ~/.config/tmux/
else
  mv ~/.config/tmux/tmux.conf -T ~/.config/tmux/tmux.conf.b
  echo "$red[!] File ~/.config/tmux/tmux.conf already exist, it was copied$reset"
fi

# # NEOFETCH
# echo "$green[*]$blue Copy neofetch config$reset"
# if [[ ! -f "/home/foglar/.config/neofetch/config.conf" ]]; then
#   mkdir ~/.config/neofetch
#   cp .config/neofetch/config.conf ~/.config/neofetch/
# else
#   echo "$red[!] File ~/.config/neofetch/config.conf already exist, remove it to setup config.$reset"
# fi

# CONDA
wget "https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh"
chmod +x Anaconda3-2023.09-0-Linux-x86_64.sh
./Anaconda3-2023.09-0-Linux-x86_64.sh

# TERMINAL
echo "$blue[?] Would you like to replace your .bashrc file? [y/n]$reset"
read -r ANS
if [[ $ANS=="y" ]]; then
  echo "$green[*]$blue Copy .bashrc$reset"
  cp .bashrc ~/
else
  echo "$red[-]$blue Skip Copy .bashrc$reset"
fi
echo "$blue[?] Would you like to replace your .bash_aliases file [y/n]$reset"
read -r ANS1
if [[ $ANS1 == "y" ]]; then
  echo "$green[*]$blue Copy .bash_aliases$reset"
  cp .bash_aliases ~/
else
  echo "$red[-]$blue Skip Copy .bash_aliases$reset"
fi

echo "$blue[?] To update your tmux config press <CTRL-SPACE>+I"
echo "$blue[?] To install syntax highlighting in neovim run ':TSInstall <language_name>'"
echo "$blue[?] You may have to restart terminal to se changes$reset"
sleep 4

nvim
tmux

echo "Instalation end$reset"
