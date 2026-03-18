dir=$(pwd)
oldfiles=$(pwd)/old
OS="$(uname -s)"

mkdir -p $oldfiles

# --- Dotfiles ---
echo "setting up dotfiles ($OS)"

files=".vimrc .gitconfig .bashrc .bash_aliases"

# .bash_profile is only used on macOS (login shells)
[ "$OS" = "Darwin" ] && files="$files .bash_profile"

echo "moving old files to $oldfiles"

for file in $files; do
    echo "  setting up $file"
    mv ~/$file $oldfiles/ 2>/dev/null
    ln -sf $dir/$file ~/$file
done

# --- Homebrew (macOS only) ---
if [ "$OS" = "Darwin" ]; then
    if ! command -v brew &>/dev/null; then
        echo "homebrew not found — installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "homebrew already installed"
    fi
fi

# --- Claude Code commands ---
if [ -d "$dir/.claude/commands" ]; then
    echo "setting up claude commands"
    mkdir -p ~/.claude/commands
    for file in $dir/.claude/commands/*.md; do
        fname=$(basename $file)
        echo "  linking claude command: $fname"
        ln -sf $file ~/.claude/commands/$fname
    done
fi
