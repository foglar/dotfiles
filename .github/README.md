# ~/dotfiles

## **all my config files in one place**

I      󰣇 


## ./scripts

- ./setup.sh - full arch setup script

```bash
git clone https://github.com/foglar/dotfiles
cd dotfiles
chmod +x setup.sh
./setup.sh
```
When neovim setup is completed, exit neovim and you will have to update tmux with "<CTRL + SPC> + I"    


### ./useful_stuff

- add blackarch repositories
- alacritty - custom config and themes
- neovim - with custom config (NVChad)
- neofetch - with custom config
- custom aliases in .bash_aliases file
- fonts - installs jetbrains_mono font for you
- many other useful/less packages:

neovim alacritty tmux unzip npm go python3 neofetch exa paru lolcat cmatrix ranger yt-dlp ncdu ripgrep entr jp2a figlet fzf thefuck espeak-ng htop wget tldr

to read more about package try `pacman -Ss <package_name>` or to get more info about usage, use `tldr <package_name>`.

## ./file_tree
```bash
~
├──  .bash_aliases
├── 󱆃 .bashrc
├──  .config
│  ├──  alacritty
│  │  └──  alacritty.yml
│  ├──  neofetch
│  │  └──  config.conf
│  ├──  nvim
│  │  └──  lua
│  │     └──  custom
│  │        ├──  chadrc.lua
│  │        ├──  configs
│  │        │  ├──  lspconfig.lua
│  │        │  └──  null-ls.lua
│  │        ├──  init.lua
│  │        ├──  mappings.lua
│  │        └──  plugins.lua
│  └──  tmux
│     └──  tmux.conf
├──  .local
│  ├──  bin
│  │  ├──  sync
│  │  ├──  temp
│  │  └──  today
│  └──  share
│     └──  autojump
│        └──  autojump.txt
├──  .themes
│  ├──  kali-test.omp.json
│  └──  kali.omp.json
├──  default-bg.jpg
└──  setup.sh
```

