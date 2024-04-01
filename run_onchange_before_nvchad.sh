#!/bin/bash

#set -x

echo "${info_box}Installing dependencies"
sudo pacman -Syu --noconfirm --needed
sudo pacman -S jq --noconfirm --needed

source "$HOME/.local/share/chezmoi/dot_local/bin/setup_scripts/global.sh" 

config_file="$HOME/.local/share/chezmoi/dot_local/bin/setup_scripts/config.json"

nvchad_setup() 
{
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

echo "$green█▀▀ █▀█ █▀▀ █░░ ▄▀█ █▀█ ▀ █▀   █▀▄ █▀█ ▀█▀ █▀"
echo "█▀░ █▄█ █▄█ █▄▄ █▀█ █▀▄ ░ ▄█   █▄▀ █▄█ ░█░ ▄█$reset"
echo ""

# Skip installation
skip_installation=$(check_value "skip_script")
if [ "$skip_installation" == "true" ]; then
  echo "${error_box}Skipping script (if you don't expect this behaviour, edit your config file in ~/.config/scripts/config.json)$reset"
  exit 1
fi

# NvChad Setup
install_nvchad=$(check_value "nvchad")
if [ "$install_nvchad" == "true" ]; then
  echo "${info_box}NvChad setup$reset"
  nvchad_setup
elif [ "$install_nvchad" == "false" ]; then
  echo "${skip_msg}NvChad setup$reset"
else
  ans=$(dialog "${question_box}Install neovim NvChad configuration?")
  if [[ $ans == "true" ]]; then
    nvchad_setup
  fi
fi
