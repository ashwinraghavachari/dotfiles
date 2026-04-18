# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt APPENDHISTORY

# Completion
autoload -Uz compinit && compinit

# Source shared config
[ -f "$HOME/.shellrc" ] && source "$HOME/.shellrc"
