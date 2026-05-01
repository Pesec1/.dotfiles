# zoxide
eval "$(zoxide init --cmd cd zsh)"
#custom export
alias vi=nvim
export PATH="/opt/zig-linux-x86_64-0.14.0:$PATH"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# custom binds
bindkey -v

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh
