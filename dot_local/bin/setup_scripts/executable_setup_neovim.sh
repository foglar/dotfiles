#!/bin/bash
source ./global_fn.sh

echo """$blue
   _  __             _         _____          ____     
  / |/ /__ ___ _  __(_)_ _    / ___/__  ___  / _(_)__ _
 /    / -_) _ \ |/ / /  ' \  / /__/ _ \/ _ \/ _/ / _ \`/
/_/|_/\__/\___/___/_/_/_/_/  \___/\___/_//_/_//_/\_, / 
                                                /___/  
by$red foglar $reset
"""

echo "$green[*]$blue Cloning NvChad setup$reset"
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 2
echo "$red[!] Attention, this action will rewrite your current nvim config!!! Press [Enter] to continue...$reset"
read
echo "$green[*]$blue Copying neovim setup$reset"
cp -r ../.config/nvim/lua/custom ~/.config/nvim/lua/
