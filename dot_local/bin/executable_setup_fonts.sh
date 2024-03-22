#!/bin/bash
source ./global_fn.sh

echo """$blue   ____          __        _____          ____     
  / __/__  ___  / /____   / ___/__  ___  / _(_)__ _
 / _// _ \/ _ \/ __(_-<  / /__/ _ \/ _ \/ _/ / _ \`/
/_/  \___/_//_/\__/___/  \___/\___/_//_/_//_/\_, / 
                                            /___/
by$red foglar $reset
"""
echo "Install emoji font"
sudo pacman -S noto-fonts-emoji --needed 
echo "$green[*]$blue Download JetBrainsMono Nerd font$reset"
wget --output-document JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip"
mkdir -p ~/.local/share/fonts/
unzip JetBrainsMono.zip -d  ~/.local/share/fonts
fc-cache -vf

