#!/bin/bash
source ./global_fn.sh

echo """$blue
 ______                  _____          ____     
/_  __/_ _  __ ____ __  / ___/__  ___  / _(_)__ _
 / / /  ' \/ // /\ \ / / /__/ _ \/ _ \/ _/ / _ \`/
/_/ /_/_/_/\_,_//_\_\  \___/\___/_//_/_//_/\_, / 
                                          /___/  
by$red foglar $reset
"""

echo "$green[*]$blue Tmux TPM install$reset"
mkdir -p ~/.config/tmux/plugins/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "$green[*]$blue Copy tmux config$reset"
if [[ ! -f "/home/foglar/.config/tmux/tmux.conf" ]]; then
  cp ../.config/tmux/tmux.conf ~/.config/tmux/
else
  mv ~/.config/tmux/tmux.conf -T ~/.config/tmux/tmux.conf.b
  echo "$red[!] File ~/.config/tmux/tmux.conf already exist, it was copied$reset"
fi

