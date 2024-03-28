#!/bin/bash
source ./global_fn.sh
echo """$blue  _____             __       _   _______  ___   __  _____          ____     
 / ___/__  ___  ___/ /__ _  | | / / __/ |/ / | / / / ___/__  ___  / _(_)__ _
/ /__/ _ \/ _ \/ _  / _ \`/  | |/ / _//    /| |/ / / /__/ _ \/ _ \/ _/ / _ \`/
\___/\___/_//_/\_,_/\_,_/   |___/___/_/|_/ |___/  \___/\___/_//_/_//_/\_, / 
                                                                     /___/  
by$red foglar $reset
"""

get_anaconda_download_link() {
    html_content=$(curl -s "https://www.anaconda.com/download/")
    download_url=$(echo "$html_content" | grep -oE "let linLink = '([^']*)';" | sed "s/let linLink = '//; s/'//")
    echo "$download_url"
}

paru -S curl --needed
download_url=$(get_anaconda_download_link)
curl -o Anaconda3-Linux-x86_64.sh "$download_url"
chmod +x Anaconda3-Linux-x86_64.sh
./Anaconda3-2023.09-0-Linux-x86_64.sh
