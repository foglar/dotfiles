# My personal dotfiles

- [x] add nice look, colors in terminal and logos
- [ ] make it more error resistent, so it wouldn't stop, but try to continue
- [ ] make your decisions on the beggining, no input after, config saved into file, then runned
    - [x] create a script before sync, which will ask user for all settings, saved all what can be done after into json file (you can also use your json to skip questions 
    - [ ] then do everything what should be done before sync, and things with prompts, sync files
    - [ ] finally run all things from json (using jq) file) with after script
- [x] cleanup after installation
- [x] NVChad should be installed before sync -> add it into other script
- [x] sudo
- [ ] pick from 4 categories **minimal.lst basic.lst full.lst** or **custom.lst** (pick for each category)
- [x] fix nvim/NVChad config to load in new NVChad environment
- [ ] wallpapers are big, load them only if user agreed so
- [ ] ask if user wants to run script
- [ ] ask if user wants to install any applications or skip

- [ ] ?Add function value exists
- [ ] Add configuration for colours of terminal and validation of config file before installation
- [x] Your own config files
- [x] In block "scripts to run before file sync" remove scripts which are already in config file
- [ ] Check if script ran with sudo priviledges or not 
- [ ] improve error message in the block "run after file sync becouse it in the user interaction part it will write skipping in any case, should add more checks to differentiate cases, file not exist, file already in list"
- [x] install jq dependency
- [ ] create one file with helper functions
- [ ] move installation process into after sync file so it wouldn't depend on the files in chezmoi repo, but instead on files in real filetree, only NVChad will stay in first script


## Credits

- inspired by https://github.com/prasanthrangan/hyprdots Aesthetic, dynamic and minimal dots for Arch hyprland by prasanthrangan
