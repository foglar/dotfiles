#!/bin/bash

#set -x

if [ ! -f "$HOME/.local/share/chezmoi/private_dot_config/dotfiles/scripts/global.sh" ]; then
    echo "Could not load global.sh, you've done something very bad."
    echo "Try rerunning 'chezmoi update'"
    exit 1
fi

echo "${info_box}Installing dependencies"
sudo pacman -Syu --noconfirm --needed
sudo pacman -S jq git --noconfirm --needed

source "$HOME/.local/share/chezmoi/private_dot_config/dotfiles/scripts/global.sh"
config_file="$HOME/.local/share/chezmoi/private_dot_config/dotfiles/config.json"
scripts_path="$HOME/.local/share/chezmoi/private_dot_config/dotfiles/scripts/"

if [ $(id -u) = 0 ]; then
  echo "Please don't run this script as sudo, it will ask for permission by itself"
  exit 1
fi

#nvchad_setup()
#{
#  if [ -d ~/.config/nvim ]; then
#      echo "${info_box}Removing existing nvim config folder$reset">&2
#      if [ $(check_value "nvchad_overwrite_dir") == "true" ]; then
#        echo "${error_box}Removing NvChad configuration$reset">&2
#        #rm -rf ~/.config/nvim/
#        # Clone NvChad setup
#        git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
#      else
#          ans=$(dialog "${question_box}Would you like to rewrite your nvim config?$reset")>&2
#          if [[ $ans == "true" ]]; then
#            echo "${error_box}Removing previous nvim configuration $reset"
#            #rm -rf ~/.config/nvim
#            # Clone NvChad setup
#            git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
#          else
#            echo "$skip_msg NvChad setup$reset">&2
#          fi
#      fi
#     else
#       git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
#  fi
#}

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
    else
        git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
    fi
elif [ "$install_nvchad" == "false" ]; then
    echo "${skip_msg}NvChad setup$reset"
else
    ans=$(dialog "${question_box}Install neovim NvChad configuration?")
    if [[ $ans == "true" ]]; then
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
        else
            git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
        fi
    fi
fi

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
    scripts_to_execute=($(list_scripts "${scripts_path}"))
    for script in ${scripts_to_execute[@]}; do
        if [[ $(dialog "${question_box}Run script $script?$reset") == "true" && -f "${scripts_path}${script}" ]]; then
            echo "$info_box Executing script $script...$reset"
            chmod +x "${scripts_path}${script}"
            sh "$scripts_path$script"
        else
            echo "${skip_msg} script $script"
        fi
    done
fi
