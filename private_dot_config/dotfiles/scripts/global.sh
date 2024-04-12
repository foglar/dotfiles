#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

info_box="${green}[*] ${reset}"
question_box="${blue}[?] ${reset}"
error_box="${red}[!] ${reset}"
skip_box="${green}[-] ${reset}"
yes_no="[y/n]"

skip_msg="${skip_box}Skipping..."

config_file="$HOME/.config/dotfiles/config.json"
output_config_file="$HOME/.config/dotfiles/output_config.json"
app_list_dir="$HOME/.config/dotfiles/packages/"
default_app_list_dir="$HOME/.config/dotfiles/packages/default"
app_install_file="$HOME/.local/share/chezmoi/.chezmoidata/packages.yaml"
scripts_path="$HOME/.config/dotfiles/scripts/"

check_value() {
  local param=$1
  local file=${2:-$config_file}
  local value=$(jq -r .$param "$file")
  
  if [[ "${value,,}" = "true" || "${value,,}" = 1 || "${value,,}" = "yes" ]]; then
    echo "true"
  elif [[ "${value,,}" = "false" || "${value,,}" = 0 || "${value,,}" = "no" ]]; then
    echo "false"
  else
    echo "null"
  fi
}

return_value() {
  local param=$1
  local file=${2:-$config_file}
  local value=$(jq -r .$param "$file")
  
  echo ${value}
}

dialog() {
  echo -n "${1} [y/n]: " >&2
   while true; do
    read -r answer
    case $answer in 
  	  [yY] ) echo "true"
        break ;;
      "yes") echo "true"
        break ;;
  	  [nN] ) echo "false"
        break ;;
      "no" ) echo "false"
        break ;;
  	  * ) echo ${2:-"${error_box}Please enter y/n: "}>&2
    esac
  done
}

list_dir() {
    local search_dir=${1:-$app_list_dir}
    local categories=()

    for entry in "$search_dir"/*; do
        filename=$(basename "$entry")
        categories+=("$filename")
    done

    # Print the list
    echo "${categories[@]}"
}

list_scripts() {
    local search_dir="$1"
    local scripts=()

    # List folders containing scripts
    for script in "$search_dir"/setup_*; do
        if [ -f "$script" ]; then
            filename=$(basename "$script")
            scripts+=("$filename")
        fi
    done

    for script in "$search_dir"/executable_setup*; do
        if [ -f "$script" ]; then
            filename=$(basename "$script")
            scripts+=("$filename")
        fi
    done
    # Print the list
    echo "${scripts[@]}"
}


list_lst_scripts() {
    local search_dir="$1"
    local lst_scripts=()

    # List files with .lst extension
    for lst_file in "$search_dir"/*.lst; do
        if [ -f "$lst_file" ]; then
            filename=$(basename "$lst_file")
            lst_scripts+=("$filename")
        fi
    done

    # Print the list
    echo "${lst_scripts[@]}"
}

# Function to check if a value is present in an array
is_in_array() {
    local value="$1"
    shift
    local array=("$@")
    local ans=1
    
    for element in "${array[@]}"; do
        if [[ "$element" == "$value" ]]; then
            ans=0 # Value found in the array
            break 
        fi
    done
    
    echo "$ans"  # Value not found in the array
}

chk_aurh()
{
  if [[ $(pkg_installed yay) == 0 ]]
    then
        aurhlpr="yay"
  elif [[ $(pkg_installed paru) == 0 ]]
    then
        aurhlpr="paru"
  fi
}

aur_available()
{
    local PkgIn=$1
    chk_aurh

    if $aurhlpr -Si $PkgIn &> /dev/null
    then
        #echo "${PkgIn} available in aur repo..."
        return 0
    else
        #echo "aur helper is not installed..."
        return 1
    fi
}

pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi "$PkgIn" &> /dev/null
    then
        #echo "${PkgIn} is already installed..."
        echo 0
    else
        #echo "${PkgIn} is not installed..."
        echo 1
    fi
}

pkg_available()
{
    local PkgIn=$1

    if pacman -Si $PkgIn &> /dev/null
    then
        #echo "${PkgIn} available in arch repo..."
        return 0
    else
        #echo "${PkgIn} not available in arch repo..."
        return 1
    fi
}

is_blackarch_repository() {
    # Check if the BlackArch repository is added to Pacman
    if grep -q "^\[blackarch\]$" /etc/pacman.conf; then
        echo "${info_box}BlackArch repository is succesfully added.">&2
        echo "true"
    else
        echo "${error_box}Fail to add BlackArch repository">&2
        echo "false"
    fi
}

json_to_bash_array() {
    local json="$1"
    # Remove leading and trailing square brackets and quotes
    json="${json#[}"
    json="${json%]}"
    json="${json//\"}"
    json="${json//,/ }"
    echo "$json"
}

