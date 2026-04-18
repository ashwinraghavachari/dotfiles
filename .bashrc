# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

OS="$(uname -s)"

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

# make less more friendly for non-text input files
[ "$OS" = "Linux" ] && [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# chroot identifier (Debian/Ubuntu)
if [ "$OS" = "Linux" ] && [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# Bash completion
if [ "$OS" = "Darwin" ]; then
    for brew_prefix in /opt/homebrew /usr/local; do
        if [ -f "$brew_prefix/etc/profile.d/bash_completion.sh" ]; then
            . "$brew_prefix/etc/profile.d/bash_completion.sh"
            break
        elif [ -f "$brew_prefix/etc/bash_completion" ]; then
            . "$brew_prefix/etc/bash_completion"
            break
        fi
    done
elif ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Source shared config
[ -f "$HOME/.shellrc" ] && source "$HOME/.shellrc"
