#!/bin/bash
source ./global_fn.sh
echo """$blue  _____             __       _   _______  ___   __  _____          ____     
 / ___/__  ___  ___/ /__ _  | | / / __/ |/ / | / / / ___/__  ___  / _(_)__ _
/ /__/ _ \/ _ \/ _  / _ \`/  | |/ / _//    /| |/ / / /__/ _ \/ _ \/ _/ / _ \`/
\___/\___/_//_/\_,_/\_,_/   |___/___/_/|_/ |___/  \___/\___/_//_/_//_/\_, / 
                                                                     /___/  
by$red foglar $reset
"""

paru -S wget --needed
wget "https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh"
chmod +x Anaconda3-2023.09-0-Linux-x86_64.sh
./Anaconda3-2023.09-0-Linux-x86_64.sh
