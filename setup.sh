#!/usr/bin/env bash
set -e

dir="$(cd "$(dirname "$0")" && pwd)"
oldfiles="$dir/old"
OS="$(uname -s)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

cmd_help() {
    echo ""
    echo -e "${BOLD}usage:${NC} ./setup.sh [command]"
    echo ""
    echo "commands:"
    echo "  (none)    full setup — symlink dotfiles, install homebrew, link claude commands"
    echo "  secrets   interactively set API keys in ~/.secrets"
    echo "  help      show this message"
    echo ""
    echo "examples:"
    echo "  ./setup.sh            # new machine setup"
    echo "  ./setup.sh secrets    # add or update secrets"
    echo ""
}

cmd_dotfiles() {
    echo ""
    echo -e "${BOLD}setting up dotfiles ($OS)${NC}"

    files=".vimrc .gitconfig .bashrc .shellrc"
    [ "$OS" = "Darwin" ] && files="$files .bash_profile .zshrc"

    mkdir -p "$oldfiles"
    for file in $files; do
        echo "  linking $file"
        mv ~/$file "$oldfiles/" 2>/dev/null || true
        ln -sf "$dir/$file" ~/$file
    done

    # Homebrew (macOS only)
    if [ "$OS" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
            echo ""
            echo "  homebrew not found — installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "  homebrew already installed"
        fi
    fi

    # Claude Code commands
    if [ -d "$dir/.claude/commands" ]; then
        echo ""
        echo "  linking claude commands"
        mkdir -p ~/.claude/commands
        for file in "$dir/.claude/commands/"*.md; do
            fname=$(basename "$file")
            ln -sf "$file" ~/.claude/commands/"$fname"
        done
    fi

    echo ""
    echo -e "${GREEN}done.${NC} open a new shell to apply changes."
    echo ""

    # Offer to set up secrets
    [ ! -f "$HOME/.secrets" ] && echo -e "${YELLOW}~/.secrets not found.${NC}"
    printf "Set up secrets now? [y/N] "
    local answer
    read -r answer
    echo ""
    [[ "$answer" =~ ^[Yy] ]] && cmd_secrets
}

cmd_secrets() {
    local template="$dir/.secrets.template"
    local secrets="$HOME/.secrets"

    if [ ! -f "$template" ]; then
        echo "error: template not found at $template" >&2
        exit 1
    fi

    touch "$secrets" && chmod 600 "$secrets"

    echo ""
    echo -e "${BOLD}Setting up ~/.secrets${NC}"
    echo "Press Enter to skip a variable or keep its existing value."
    echo ""

    local set_count=0 keep_count=0 skip_count=0 desc=""

    while IFS= read -r line <&3; do
        if [[ "$line" =~ ^#[[:space:]]?(.*) ]]; then
            desc="${BASH_REMATCH[1]}"
            continue
        fi

        if [[ -z "$line" ]]; then
            desc=""
            continue
        fi

        if [[ "$line" =~ ^([A-Z_][A-Z0-9_]*)= ]]; then
            local varname="${BASH_REMATCH[1]}"
            local current
            current=$(grep "^export ${varname}=" "$secrets" 2>/dev/null | cut -d'=' -f2- | sed 's/^"//;s/"$//')

            [ -n "$desc" ] && echo -e "  ${BLUE}${desc}${NC}"

            if [ -n "$current" ]; then
                printf "  %s [currently set, Enter to keep]: " "$varname"
            else
                printf "  %s: " "$varname"
            fi

            local value
            read -rs value
            echo ""

            if [ -n "$value" ]; then
                local tmpfile
                tmpfile=$(mktemp)
                grep -v "^export ${varname}=" "$secrets" > "$tmpfile"
                echo "export ${varname}=\"${value}\"" >> "$tmpfile"
                mv "$tmpfile" "$secrets"
                chmod 600 "$secrets"
                echo -e "  ${GREEN}✓ set${NC}"
                ((set_count++))
            elif [ -n "$current" ]; then
                echo -e "  ${YELLOW}→ kept${NC}"
                ((keep_count++))
            else
                echo -e "  ${YELLOW}↷ skipped${NC}"
                ((skip_count++))
            fi

            echo ""
            desc=""
        fi
    done 3< "$template"

    echo -e "${BOLD}done:${NC} ${set_count} set, ${keep_count} kept, ${skip_count} skipped"
    echo "Open a new shell (or run 'source ~/.secrets') to apply."
    echo ""
}

case "${1:-}" in
    "")        cmd_dotfiles ;;
    secrets)   cmd_secrets ;;
    help|--help|-h) cmd_help ;;
    *)
        echo "unknown command: $1"
        cmd_help
        exit 1
        ;;
esac
