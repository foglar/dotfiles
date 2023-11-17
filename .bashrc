#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# All aliases stored here
source ~/.bash_aliases

# Tmux
# If not running interactively, do not do anything
[[ $- != *i* ]] && return
# Otherwise start tmux
[[ -z "$TMUX" ]] && exec tmux

eval "$(oh-my-posh init bash --config /home/foglar/.themes/kali.omp.json)"
. /usr/share/autojump/autojump.bash

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/foglar/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/foglar/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/foglar/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/foglar/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# PATH
PATH=$PATH:~/.local/bin/
eval "$(thefuck --alias)"
