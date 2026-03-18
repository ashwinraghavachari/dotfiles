# macOS Terminal opens login shells, so .bash_profile is sourced instead of .bashrc.
# Delegate everything to .bashrc to keep one source of truth.

# Initialize Homebrew (must come first so brew-installed tools are on PATH)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
