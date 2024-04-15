# My personal dotfiles

- [x] add nice look, colors in terminal and logos
- [x] cleanup after installation
- [x] NVChad should be installed before sync -> add it into other script
- [x] sudo
- [x] pick from 4 categories **minimal.lst basic.lst full.lst** or **custom.lst** (pick for each category)
- [x] fix nvim/NVChad config to load in new NVChad environment
- [x] ask if user wants to run script
- [x] Your own config files
- [x] In block "scripts to run before file sync" remove scripts which are already in config file
- [x] Check if script ran with sudo priviledges or not
- [x] install jq dependency
- [x] create one file with helper functions
- [x] move installation process into after sync file so it wouldn't depend on the files in chezmoi repo, but instead on files in real filetree, only NVChad will stay in first script
- [x] check if global.sh exists
- [x] move part with setup scripts before file sync into run_before_nvchad.sh
- [x] maybe consider installation old way
- [x] error with detecting yay package managers
- [x] use chezmoi templates
- [x] error saving config file
- [x] in list of package lists should be only files with .lst name
- [x] scripts after stage didn't recognize any scripts to run
- [x] check for installed dependencies if they are not installed install them, on the begginging of each script

- [ ] make your decisions on the beggining, no input after, config saved into file, then runned
    - [x] create a script before sync, which will ask user for all settings, saved all what can be done after into json file (you can also use your json to skip questions 
    - [x] then do everything what should be done before sync, and things with prompts, sync files
    - [ ] finally run all things from json (using jq) file) with after script
- [ ] make it more error resistent, so it wouldn't stop, but try to continue
- [ ] wallpapers are big, load them only if user agreed so
- [ ] ask if user wants to install any applications or skip
- [ ] Add configuration for colours of terminal and validation of config file before installation
- [ ] improve error message in the block "run after file sync because it in the user interaction part it will write skipping in any case, should add more checks to differentiate cases, file not exist, file already in list"
- [ ] add more functionalities:
    - [ ] grub theme
    - [ ] bluetooth
    - [ ] printer
    - [ ] add into groups for docker arduino wireshark...
    - [ ] ...
- [ ] move nvchad_setup into one function, no duplicate code
- [ ] add more skip messages so the user knows why something is not showing
- [ ] ask if user wants to run script next time, if no, then edit config.json
- [ ] maybe generate default config.json based on the users input and output_config.json if running for the first time
- [ ] add setup of hyprland with hyprdots option for arch linux and nvidia detection and installation of drivers for it
- [ ] create new naming conventions for package lists for linux distributions, minimal_arch.lst vs. minimal.lst
- [ ] add template to the bashrc, so it would add conda only if user has conda installed
- [ ] remove unnecessary files and dependencies after install
- [ ] create summary of all changes before install
- [ ] detect nvidia and install nvidia drivers, systemd and setup systemd stuff and hyprland if user wants hyprland
- [ ] in arch add icon themes installation

## Credits

- inspired by https://github.com/prasanthrangan/hyprdots Aesthetic, dynamic and minimal dots for Arch hyprland by prasanthrangan
