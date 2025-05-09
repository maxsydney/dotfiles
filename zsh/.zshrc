# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="theunraveler"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

source $ZSH/oh-my-zsh.sh

# User configuration
alias vim="nvim"
alias gs="git status"

# Add some extra stuff to PATH
export PATH=$PATH:/home/max/.local/bin
export PATH=$PATH:/home/max/.bin

# Add some stuff to PYTHONPATH
export PYTHONPATH=$PYTHONPATH:/home/max/Documents/orbitalMechanics

#Virtualenvwrapper settings:
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv
source ~/.local/bin/virtualenvwrapper.sh
eval "$(direnv hook zsh)"

# OneDark colors
typeset -A ONEDARK=(
    red     "196;77;67"    # #C44343
    green   "152;195;121"  # #98C379
    yellow  "229;192;123"  # #E5C07B
    blue    "97;175;239"   # #61AFEF
    purple  "198;120;221"  # #C678DD
    cyan    "86;182;194"   # #56B6C2
    white   "171;178;191"  # #ABB2BF
)

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
