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

# Airtable script update
alias update_airtable='git stash && git fetch origin master:master && gr master && git stash pop && ./update_airtable.sh'

