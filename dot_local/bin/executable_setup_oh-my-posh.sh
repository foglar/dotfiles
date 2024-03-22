#!/bin/bash
source ./global_fn.sh

echo """$blue
  ____  __                                __     _____          ____     
 / __ \/ /    __ _  __ __  ___  ___  ___ / /    / ___/__  ___  / _(_)__ _
/ /_/ / _ \  /  ' \/ // / / _ \/ _ \(_-</ _ \  / /__/ _ \/ _ \/ _/ / _ \`/
\____/_//_/ /_/_/_/\_, / / .__/\___/___/_//_/  \___/\___/_//_/_//_/\_, / 
                  /___/ /_/                                       /___/
by$red foglar $reset
"""


echo "$green[*]$blue Installing oh-my-posh$reset"
curl -s https://ohmyposh.dev/install.sh | sudo bash -s
echo "$green[*]$blue Copy oh-my-posh theme$reset"
mkdir -p ~/.themes
cp ../.themes/kali.omp.json ~/.themes/
