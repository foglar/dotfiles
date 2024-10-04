get_anaconda_download_link() {
    html_content=$(curl -s "https://www.anaconda.com/download/success")
    download_url=$(echo "$html_content" | grep -oE "let linLink = '([^']*)';" | sed "s/let linLink = '//; s/'//")
    echo "$download_url"
}

paru -S curl --needed
download_url=$(get_anaconda_download_link)
download_url=${download_url::-1}
curl -o Anaconda3-Linux-x86_64.sh "$download_url"
chmod +x Anaconda3-Linux-x86_64.sh
sh ./Anaconda3-Linux-x86_64.sh
