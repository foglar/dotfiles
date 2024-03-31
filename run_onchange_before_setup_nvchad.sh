#!/bin/bash
echo "$green[*]$blue Cloning NvChad setup$reset"

if [ -d ~/.config/nvim ]; then
    echo "$green[*]$blue Removing existing nvim config folder$reset"
    read -p "Would you like to rewrite your nvim config? [N/y]: " answer
    if [[ !($answer == [yY]) ]]; then
      rm -rf ~/.config/nvim
    fi
fi

# Clone NvChad setup
git clone https://github.com/NvChad/starter ~/.config/nvim --depth 2
