# ~/.bashrc
#
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
#custom export
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
export PYTHONPATH="/opt/hosting/neolithic-airflow:$PYTHONPATH"
export PATH="/opt/zig-linux-x86_64-0.14.0:$PATH"

#custom alias
alias icat="kitten icat"
alias s="kitten ssh"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"
