# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="theunraveler"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

plugins=(git z)

source $ZSH/oh-my-zsh.sh

# User configuration
alias vim="nvim"
alias gs="git status"
alias grc="git rebase --continue"

# Add some extra stuff to PATH
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.bin

# Add some stuff to PYTHONPATH
export PYTHONPATH=$PYTHONPATH:~/Documents/orbitalMechanics

source ~/.gnc_env

# SSH connection prompt with OneDark yellow
function ssh_server_info() {
    if [[ -n $SSH_CONNECTION ]]; then
        echo "%F{#E5C07B}[%n@$(hostname)]%f "
    fi
}

# Show only current directory with OneDark blue
PROMPT='$(ssh_server_info)%F{#61AFEF}%1~%f %F{#ABB2BF}❯%f '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
