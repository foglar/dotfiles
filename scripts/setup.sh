#!/bin/bash
source ./global_fn.sh

echo """                                        
                 0kxxkK.                
               ;:,,,,,,;l               
     .         ;,,,,,,,,,         :     
      ,OX;      ,,,,,,,,.     lKk,      
       .clok0XK   .,,'  .XK0kocc.       
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
   ___           __     __   _               
  / _ | ________/ /    / /  (_)__  __ ____ __
 / __ |/ __/ __/ _ \  / /__/ / _ \/ // /\ \ /
/_/ |_/_/  \__/_//_/ /____/_/_//_/\_,_//_\_\ 
"""
repositories_config()
{
echo "$green[*]$blue Updating repositories$reset"
sudo pacman -Syu
echo "$green[*]$blue Adding blackarch repositories$reset"
curl -O https://blackarch.org/strap.sh 
echo 3f121404fd02216a053f7394b8dab67f105228e3 strap.sh | sha1sum -c 
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syy
echo "$green[*]$blue Install paru - AUR helper$reset"
}

install_pkg() {
echo "$green[*]$blue Installing packages$reset"
./install_pkg.sh
echo "Packages installation completed."
}

repositories_config
install_pkg

sh ./setup_fonts.sh
sh ./setup_oh-my-posh.sh

sh ./setup_tmux.sh
sh ./setup_neovim.sh
sh ./setup_conda.sh

# TERMINAL
echo "$blue[?] Would you like to replace your .bashrc file? [y/n]$reset"
read -r ANS
if [[ $ANS=="y" ]]; then
  echo "$green[*]$blue Copy .bashrc$reset"
  cp ../.bashrc ~/
else
  echo "$red[-]$blue Skip Copy .bashrc$reset"
fi

echo "$blue[?] Would you like to replace your .bash_aliases file [y/n]$reset"
read -r ANS1
if [[ $ANS1 == "y" ]]; then
  echo "$green[*]$blue Copy .bash_aliases$reset"
  cp ../.bash_aliases ~/
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
