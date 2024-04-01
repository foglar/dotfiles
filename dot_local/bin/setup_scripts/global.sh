#!/bin/bash

config_file="$HOME/.local/bin/setup_scripts/config.json"
output_config_file="$HOME/.local/bin/setup_scripts/output_config.json"
app_list_dir="$HOME/.local/share/packages/"
scripts_path="$HOME/.local/bin/setup_scripts/"

red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)
reset=$(tput sgr0)

info_box="$green[*] $reset"
question_box="$blue[?] $reset"
error_box="$red[!] $reset"
skip_box="$green[-] $reset"

skip_msg="${skip_box}Skipping..."

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
  echo "${1} [y/n]: " >&2
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

    # Print the list
    echo "${scripts[@]}"
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

pkg_installed()
{
    local PkgIn=$1

    if pacman -Qi $PkgIn &> /dev/null
    then
        #echo "${PkgIn} is already installed..."
        return 0
    else
        #echo "${PkgIn} is not installed..."
        return 1
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

json_to_bash_array() {
    local json="$1"
    # Remove leading and trailing square brackets and quotes
    json="${json#[}"
    json="${json%]}"
    json="${json//\"}"
    json="${json//,/ }"
    echo "$json"
}

