#!/bin/bash

#set -x

config_file="$HOME/.local/bin/setup_scripts/config.json"
output_config_file="$HOME/.local/bin/setup_scripts/"
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

nvchad_setup() {
  if [ -d ~/.config/nvim ]; then
      echo "${info_box}Removing existing nvim config folder$reset"
      if [ $(check_value "nvchad_overwrite_dir") == "true" ]; then
        echo "${error_box}Removing NvChad configuration$reset"
        #rm -rf ~/.config/nvim/
        # Clone NvChad setup
        git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
      else
          ans=$(dialog "${question_box}Would you like to rewrite your nvim config?$reset")
          if [[ $ans == "true" ]]; then
            echo "${error_box}Removing previous nvim configuration $reset"
            #rm -rf ~/.config/nvim
            # Clone NvChad setup
            git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
          else
            echo "$skip_msg NvChad setup$reset"
          fi
      fi
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


#---START---#

echo "$green█▀▀ █▀█ █▀▀ █░░ ▄▀█ █▀█ ▀ █▀   █▀▄ █▀█ ▀█▀ █▀"
echo "█▀░ █▄█ █▄█ █▄▄ █▀█ █▀▄ ░ ▄█   █▄▀ █▄█ ░█░ ▄█$reset"
echo ""

# Skip installation
skip_installation=$(check_value "skip_script")
if [ "$skip_installation" == "true" ]; then
  echo "${error_box}Skipping script (if you don't expect this behaviour, edit your config file in ~/.config/scripts/config.json)$reset"
  exit 1
fi

# ?Add function value exists
# Add configuration for colours of terminal and validation of config file before installation
# Your own config files
# In block "scripts to run before file sync" remove scripts which are already in config file
# Check if script ran with sudo priviledges or not 
# improve error message in the block "run after file sync becouse it in the user interaction part it will write skipping in any case, should add more checks to differentiate cases, file not exist, file already in list"

# Blackarch repository setup
echo "${info_box}Setup blackarch repository"
blackarch_repository_config=$(return_value "blackarch_repo")
if [ "$blackarch_repository_config" == "null" ]; then
  blackarch_repository_config=$(dialog "${question_box}Add blackarch repo: $reset")
fi
echo "${info_box}Blackarch repository: ${blackarch_repository_config}"

# Applications to install setup
echo "${info_box}Setup applications category"
applications_to_install_config=$(return_value "category")
if [[ "$applications_to_install_config" != "minimal" && "$applications_to_install_config" != "base" && "$applications_to_install_config" != "full" && "$applications_to_install_config" != "custom" ]]; then
  echo "$blue"
  select category in minimal base full custom; do
    echo "$reset"
    case "$REPLY" in
      1) echo "${info_box}Picked category Minimal$reset" ; break ;;
      2) echo "${info_box}Picked category Base$reset" ; break ;;
      3) echo "${info_box}Picked category Full$reset"; break ;;
      4) echo "${info_box}Picked category Custom$reset"; break ;;
      *) echo "${error_box}Enter number 1-4:"
    esac
  done
  applications_to_install_config=$category
fi
echo "${info_box}Application category: ${applications_to_install_config}"
if [[ "$applications_to_install_config" == "custom" && $(return_value "categories_to_install") != "null" ]]; then
  json_data=$(return_value "categories_to_install")
  categories_to_install_config=$(json_to_bash_array "$json_data")
  read -r -a categories_to_install_config <<< "$categories_to_install_config"
elif [[ "$applications_to_install_config" == "custom" && $(return_value "categories_to_install") == "null" ]]; then
  categories=$(list_dir)
  categories_to_install_config=()
  for category_file in ${categories[@]}; do
    ans=$(dialog "${question_box}Install packages from $category_file?$reset")
      if [[ $ans == "true" ]]; then
        categories_to_install_config+=("$category_file")
      fi
  done
fi

# Which scripts to execute
echo "${info_box}Setup scripts"
# Before

# Config
echo "${info_box}Scripts to run ${red}before${reset} file sync"
scripts_to_run_before_config=$(return_value "scripts_before")
if [[ $scripts_to_run_before_config != "null" ]]; then
  scripts_to_run_before_config=$(json_to_bash_array "$scripts_to_run_before_config")
  for script in ${scripts_to_run_before_config[@]}; do
    if [ -f "${scripts_path}${script}" ]; then
      echo "${info_box}Executing script ${scripts_path}${script}"
      chmod +x "${scripts_path}${script}"
      sh "${scripts_path}/${script}"
    else
      echo "${error_box}Script not detected in ~/.local/bin/setup_scripts/ move it into this directory."
    fi
  done
fi

# Interactive user
if [[ $(check_value "scripts_before_dialog") == "true" || $(check_value "scripts_before_dialog") == "null" ]]; then
  scripts_to_execute=($(list_scripts "$HOME/.local/bin/setup_scripts/"))
  for script in ${scripts_to_execute[@]}; do
    if [[ $(dialog "${question_box}Run script $script?$reset") == "true" && -f "${scripts_path}${script_name}" ]]; then
      echo "$info_box Executing script $script...$reset"
      chmod +x "${scripts_path}${script_name}"
      sh "$scripts_path$script_name"
    else
      echo "${skip_msg} script $script"
    fi
  done
fi

# After

# Config
echo "${info_box}Scripts to run ${red}after${reset} file sync"
scripts_to_run_after_config=$(return_value "scripts_after")
scripts_to_run_after_checked=()
if [[ $scripts_to_run_after_config != "null" ]]; then
  scripts_to_run_after_config=$(json_to_bash_array "$scripts_to_run_after_config")
  for script in ${scripts_to_run_after_config[@]}; do
    result=$(is_in_array "${script}" "${scripts_to_run_after_checked[@]}")
    if [[ $result -eq 1 && -f "${scripts_path}${script}" ]]; then
      echo "${info_box}Running script$red ${script}$reset after file sync$reset"
      scripts_to_run_after_checked+=("$script")
    else
      echo "${error_box}Script $script is already in list of run scripts"
    fi
  done
fi

# User
if [[ $(check_value "scripts_after_dialog") == "true" || $(check_value "scripts_after_dialog") == "null" ]]; then
  scripts_to_execute=($(list_scripts "$HOME/.local/bin/setup_scripts/"))
  scripts_to_execute_checked=()
  for script in ${scripts_to_execute[@]}; do
      result=$(is_in_array "${script}" "${scripts_to_run_after_checked[@]}")
      if [[ $(dialog "${question_box}Run script $script after file sync?$reset") == "true" && -f "${scripts_path}${script_name}" && $result -eq 1 ]]; then
        scripts_to_run_after_checked+=("$script")
        echo "${info_box}Running script $script after file sync"
      else
        echo "${skip_msg} $script"
      fi
  done  
fi

# Save configuration
echo "${info_box}Saving configuration"
if [[ "$applications_to_install_config" == "custom" ]]; then
  json=$(jq -n \
    --arg blackarch_repo "$blackarch_repository_config" \
    --arg category "$applications_to_install_config" \
    --argjson categories_to_install_config "$(printf '%s\n' "${categories_to_install_config[@]}" | jq -R . | jq -s .)" \
    --argjson scripts_after "$(printf '%s\n' "${scripts_to_run_after_checked[@]}" | jq -R . | jq -s .)" \
    '{"blackarch_repo": $blackarch_repo, "category": $category, "categories_to_install": $categories_to_install_config, "scripts_after": $scripts_after}' \
    > output.json)
else
  json=$(jq -n \
    --arg blackarch_repo "$blackarch_repository_config" \
    --arg category "$applications_to_install_config" \
    --argjson scripts_after "$(printf '%s\n' "${scripts_to_run_after_checked[@]}" | jq -R . | jq -s .)" \
    '{"blackarch_repo": $blackarch_repo, "category": $category, "scripts_after": $scripts_after}' \
    > $output_config_file)
fi


# NvChad Setup
install_nvchad=$(check_value "nvchad")
if [ "$install_nvchad" == "true" ]; then
  echo "${info_box}NvChad setup$reset"
  nvchad_setup
elif [ "$install_nvchad" == "false" ]; then
  echo "${skip_msg}NvChad setup$reset"
else
  ans=$(dialog "${question_box} Install neovim NvChad configuration?")
  if [[ $ans == "true" ]]; then
    nvchad_setup
  fi
fi

