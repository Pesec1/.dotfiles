# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"
#custom export
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
alias vi="/opt/nvim-linux-x86_64/bin/nvim"
export PYTHONPATH="/opt/hosting/neolithic-airflow:$PYTHONPATH"
export PATH="/opt/zig-linux-x86_64-0.14.0:$PATH"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#custom alias
alias icat="kitten icat"
alias s="kitten ssh"
alias pact='. .venv/bin/activate'

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# custom binds
bindkey -v

ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

plugins=(git tmux copypath copybuffer)

source $ZSH/oh-my-zsh.sh

# 1) Define the function
_auto_venv() {
  # If we're in a venv that's *not* this folder’s, deactivate it
  if [[ -n $VIRTUAL_ENV && $VIRTUAL_ENV != "$PWD/.venv" ]]; then
    deactivate 2>/dev/null
  fi

  # If there's a .venv here and it's not already active, activate it
  if [[ -d ".venv" && -f ".venv/bin/activate" && $VIRTUAL_ENV != "$PWD/.venv" ]]; then
    echo "Activating $(basename "$PWD")/.venv"
    source "$PWD/.venv/bin/activate"
  fi
}

# 2) Hook it on `cd`—this runs only once when zsh starts
autoload -U add-zsh-hook
add-zsh-hook chpwd _auto_venv

# 3) Also run it right now in case you started in a project dir
_auto_venv
