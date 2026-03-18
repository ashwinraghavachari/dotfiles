alias l='ls -lah'

alias gl='git log --graph --pretty='\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias gs='git status'
alias gcm='git commit -m'
alias gp='git pull --rebase'
alias gk='git checkout'
alias gkb='git checkout -b'
alias gr='git rebase'
alias gb='git branch'

alias dps='docker ps'
alias drm='docker rm -f'
alias di='docker images'

# Applied specific
alias ddst='./dev/containers/dev/start.sh'
alias ddin='./dev/containers/dev/into.sh'
alias ddrm='./dev/containers/dev/remove.sh'

# Adopt a Claude Code command into dotfiles and replace it with a symlink.
# Usage: adopt-claude-command <filename.md>
adopt-claude-command() {
    local fname="$1"
    local src="$HOME/.claude/commands/$fname"
    local dest="$HOME/dotfiles/.claude/commands/$fname"

    [ -z "$fname" ] && { echo "usage: adopt-claude-command <filename.md>"; return 1; }
    [ ! -f "$src" ] && { echo "not found: $src"; return 1; }

    if [ -L "$src" ]; then
        echo "$fname is already a symlink — already in dotfiles"
        return 0
    fi

    mv "$src" "$dest" && ln -sf "$dest" "$src"
    echo "adopted $fname → $dest"
}

