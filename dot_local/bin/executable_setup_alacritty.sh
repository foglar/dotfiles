#!/bin/bash
source ./global_fn.sh

echo """$blue
   ___   __             _ __  __         _____          ____     
  / _ | / /__ _________(_) /_/ /___ __  / ___/__  ___  / _(_)__ _
 / __ |/ / _ \`/ __/ __/ / __/ __/ // / / /__/ _ \/ _ \/ _/ / _ \`/
/_/ |_/_/\_,_/\__/_/ /_/\__/\__/\_, /  \___/\___/_//_/_//_/\_, / 
                               /___/                      /___/  
by$red foglar $reset
"""

setup_alacritty() 
{
  echo "$green[*]$blue Cloning alacritty setup file$reset"
  mkdir -p ~/.config/alacritty/themes 
  if [[ $(path_exists "../.config/alacritty/alacritty.yml") != "True" ]]; then
    wget --output-document ~/.config/alacritty/alacritty.yml "https://raw.githubusercontent.com/foglar/dotfiles/master/.config/alacritty/alacritty.yml"
  else
    cp ../.config/alacritty/alacritty.yml ~/.config/alacritty/
  fi
  echo "$green[*]$blue Cloning Alacritty themes$reset"
  git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
}

if [[ ! -d "~/.config/alacritty/" ]]; then
  setup_alacritty
else
   echo "$red Warning - config already exists, backup created$reset"
   mv ~/.config/alacritty/ -T ~/.config/alacritty_b/
   setup_alacritty
fi
