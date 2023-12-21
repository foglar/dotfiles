#!/bin/bash
source ./global_fn.sh

echo """$blue
   _  __         ___    __      __     _____          ____     
  / |/ /__ ___  / _/__ / /_____/ /    / ___/__  ___  / _(_)__ _
 /    / -_) _ \/ _/ -_) __/ __/ _ \  / /__/ _ \/ _ \/ _/ / _ \`/
/_/|_/\__/\___/_/ \__/\__/\__/_//_/  \___/\___/_//_/_//_/\_, / 
                                                        /___/
by$red foglar $reset
"""

setup_neofetch()
{
  mkdir ~/.config/neofetch
  if [[ $(path_exists "../.config/neofetch/config.conf") != "True" ]]; then
    $(wget --output-document ~/.config/neofetch/config.conf "https://raw.githubusercontent.com/foglar/dotfiles/master/.config/neofetch/config.conf")
  else 
    cp ../.config/neofetch/config.conf ~/.config/neofetch/
  fi
}

echo "$green[*]$blue Copy neofetch config$reset"
if [[ ! -f "/home/foglar/.config/neofetch/config.conf" ]]; then
  setup_neofetch
else
  echo "$red Warning - config already exists, backup created$reset"
  mv "~/.config/neofetch/config.conf" -T "~/.config/neofetch/config.conf.b"
  setup_neofetch
fi

