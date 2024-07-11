# Best setup script for Linux

## Installation

Currently is script working on Arch, but in future will be added support for other linux distros.
I am not responsible for any damage caused by the script. **Run it at your own risk.**

### Arch

Install `chezmoi` and `git` on your linux distribution.

```bash
sudo pacman -S chezmoi git
```

Then you should clone the repository with chezmoi

```bash
chezmoi init foglar --apply --depth 1
```

You probably have to run script twice, there will be error:

```error
chezmoi: .gitconfig: template: dot_gitconfig.tmpl:2:12: executing "dot_gitconfig.tmpl" at <.email>: map has no entry for key "email"
```

Just run again:

```bash
chezmoi init foglar --apply --depth 1
```

This issue will be soon removed.

## My personal dotfiles

- [ ] Add configuration for colours of terminal and validation of config file before installation
- [ ] Look of the logo like in Omakub
- [ ] bluetooth
- [ ] printer
- [ ] add into groups for docker arduino wireshark...
- [ ] add more skip messages so the user knows why something is not showing
- [ ] ask if user wants to run script next time, if no, then edit config.json
- [ ] maybe generate default config.json based on the users input and output_config.json if running for the first time
- [ ] add setup of hyprland with hyprdots option for arch linux and nvidia detection and installation of drivers for it
- [ ] create new naming conventions for package lists for linux distributions, minimal_arch.lst vs. minimal.lst
- [ ] add template to the bashrc, so it would add conda only if user has conda installed
- [ ] in arch add icon themes installation
- [ ] turn off the bell
- [ ] setup buttons in logind
- [ ] paru BottomUp settings
- [x] Fix conda install script
- [x] Save all files to temp directory
- [ ] sudo systemctl start docker.service
- [ ] sudo systemctl enable docker.service
- [ ] sudo usermod -aG docker $USER
- [ ] hyprpm and setup plugins
- [ ] install monaspace font
- [ ] test multiple desktops and custom category applications
- [ ] kind of wrapper script for this script
    - [x] ask for email into .gitignore
    - [ ] simple installation
    - [x] wallpapers
    - [ ] Setup wallpapers + external repositories to synchronize
- [ ] create separated scripts for KDE, GNOME and Hyprland setup
    - [ ] install apps specific to desktop (kdeconnect only for kde, if GNOME gsconnect)
- [ ] config file forget and add some example one to other directory, create it on run
- [ ] add gum spinner more places
- [ ] add sddm enable for other desktops than KDE
- [x] change desktop selection to select only one

## Issues

- [x] warthunder launcher nesting
- [x] sddm theme name after untar
- [ ] fix custom application list
- [ ] global functions install gum
- [ ] nvidia
- [ ] chezmoiexternal move everything inside script
- [ ] sddm theme if kde should be catpuccine if hyprland chili, else nothing

## Theming features

- [ ] bat theme catpuccin compile
- [ ] btop config catpuccin setup
- [ ] add grub theme catpuccin
- [ ] tty <https://github.com/catppuccin/tty>

## Credits

inspired by:

- <https://github.com/prasanthrangan/hyprdots> *Aesthetic, dynamic and minimal dots for Arch hyprland* by prasanthrangan
- <https://omakub.org> *Opinionated Ubuntu Setup* by basecamp
