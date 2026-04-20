#!/usr/bin/env bash
set -e

dir="$(cd "$(dirname "$0")" && pwd)"
oldfiles="$dir/old"
OS="$(uname -s)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

TEMPLATE="$dir/.secrets.template"
SECRETS="$HOME/.secrets"

# --- Help ---

cmd_help() {
    echo ""
    echo -e "${BOLD}usage:${NC} ./setup.sh [command]"
    echo ""
    echo "commands:"
    echo "  (none)         full setup — symlink dotfiles, install homebrew, link claude rules/commands"
    echo "  brew           install packages from Brewfile"
    echo "  claude         link claude rules and commands into ~/.claude"
    echo "  secrets        manage API keys in ~/.secrets"
    echo "  help           show this message"
    echo ""
    echo "secrets subcommands:"
    echo "  secrets add    add a new secret to the template and set its value"
    echo "  secrets set    walk through all template secrets and set values"
    echo "  secrets list   show which secrets are set vs missing"
    echo "  secrets remove remove a secret from the template and ~/.secrets"
    echo ""
    echo "examples:"
    echo "  ./setup.sh                  # new machine setup"
    echo "  ./setup.sh brew             # install packages from Brewfile"
    echo "  ./setup.sh claude           # link claude rules and commands"
    echo "  ./setup.sh secrets set      # set values for all secrets in the template"
    echo "  ./setup.sh secrets add      # add a new secret"
    echo "  ./setup.sh secrets list     # see what's configured"
    echo "  ./setup.sh secrets remove   # remove a secret"
    echo ""
}

cmd_secrets_help() {
    echo ""
    echo -e "${BOLD}usage:${NC} ./setup.sh secrets <subcommand>"
    echo ""
    echo "subcommands:"
    echo "  add     add a new secret to the template and set its value"
    echo "  set     walk through all template secrets and set values"
    echo "  list    show which secrets are set vs missing"
    echo "  remove  remove a secret from the template and ~/.secrets"
    echo ""
}

# --- Claude ---

cmd_claude() {
    echo ""
    echo -e "${BOLD}linking claude rules and commands${NC}"

    if [ -d "$dir/.claude/rules" ]; then
        echo "  linking rules"
        mkdir -p ~/.claude/rules
        for file in "$dir/.claude/rules/"*.md; do
            fname=$(basename "$file")
            ln -sf "$file" ~/.claude/rules/"$fname"
            echo "    → $fname"
        done
    fi

    if [ -d "$dir/.claude/commands" ]; then
        echo "  linking commands"
        mkdir -p ~/.claude/commands
        for file in "$dir/.claude/commands/"*.md; do
            fname=$(basename "$file")
            ln -sf "$file" ~/.claude/commands/"$fname"
            echo "    → $fname"
        done
    fi

    echo ""
    echo -e "${GREEN}done.${NC}"
    echo ""
}

# --- Dotfiles ---

cmd_dotfiles() {
    echo ""
    echo -e "${BOLD}setting up dotfiles ($OS)${NC}"

    files=".vimrc .gitconfig .gitignore_global .bashrc .shellrc"
    [ "$OS" = "Darwin" ] && files="$files .bash_profile .zshrc"

    mkdir -p "$oldfiles"
    for file in $files; do
        echo "  linking $file"
        mv ~/$file "$oldfiles/" 2>/dev/null || true
        ln -sf "$dir/$file" ~/$file
    done

    if [ "$OS" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
            echo ""
            echo "  homebrew not found — installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "  homebrew already installed"
        fi
    fi

    cmd_claude

    # SSH config bootstrap
    if [ ! -f "$HOME/.ssh/config" ] && [ -f "$dir/.ssh/config.template" ]; then
        mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
        cp "$dir/.ssh/config.template" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
        echo "  created ~/.ssh/config from template — fill in your hosts"
    fi

    echo ""
    echo -e "${GREEN}done.${NC} open a new shell to apply changes."
    echo ""

    printf "Install Homebrew packages from Brewfile? [y/N] "
    local answer
    read -r answer
    echo ""
    [[ "$answer" =~ ^[Yy] ]] && cmd_brew

    [ ! -f "$SECRETS" ] && echo -e "${YELLOW}~/.secrets not found.${NC}"
    printf "Set up secrets now? [y/N] "
    read -r answer
    echo ""
    [[ "$answer" =~ ^[Yy] ]] && cmd_secrets_set
}

# --- Brew ---

cmd_brew() {
    if [ ! -f "$dir/Brewfile" ]; then
        echo "error: Brewfile not found at $dir/Brewfile" >&2
        exit 1
    fi
    echo ""
    echo -e "${BOLD}Installing Homebrew packages${NC}"
    brew bundle --file="$dir/Brewfile"
    echo ""
}

# --- Secrets: add (new secret) ---

cmd_secrets_add() {
    echo ""
    echo -e "${BOLD}Add a new secret${NC}"
    echo ""

    printf "  Variable name (e.g. GITHUB_TOKEN): "
    local varname
    read -r varname

    if [[ ! "$varname" =~ ^[A-Z_][A-Z0-9_]*$ ]]; then
        echo -e "  ${RED}error:${NC} variable names must be uppercase letters, digits, and underscores." >&2
        return 1
    fi

    if grep -q "^${varname}=" "$TEMPLATE" 2>/dev/null; then
        echo -e "  ${YELLOW}$varname already exists in template.${NC} Use './setup.sh secrets set' to update its value."
        return 0
    fi

    printf "  Hint (where to get this key, shown during setup): "
    local hint
    read -r hint

    printf "  Value (hidden, Enter to skip): "
    local value
    read -rs value
    echo ""
    echo ""

    # Append to template
    { [ -n "$hint" ] && printf "\n# %s\n%s=\n" "$hint" "$varname" || printf "\n%s=\n" "$varname"; } >> "$TEMPLATE"

    # Write value to ~/.secrets if provided
    if [ -n "$value" ]; then
        touch "$SECRETS" && chmod 600 "$SECRETS"
        local tmpfile
        tmpfile=$(mktemp)
        grep -v "^export ${varname}=" "$SECRETS" > "$tmpfile" || true
        echo "export ${varname}=\"${value}\"" >> "$tmpfile"
        mv "$tmpfile" "$SECRETS"
        chmod 600 "$SECRETS"
        echo -e "  ${GREEN}✓ $varname added to template and set in ~/.secrets${NC}"
    else
        echo -e "  ${YELLOW}↷ $varname added to template (no value set — run './setup.sh secrets set' to set it)${NC}"
    fi
    echo ""
}

# --- Secrets: set (walk through template) ---

cmd_secrets_set() {
    if [ ! -f "$TEMPLATE" ]; then
        echo "error: template not found at $TEMPLATE" >&2
        exit 1
    fi

    touch "$SECRETS" && chmod 600 "$SECRETS"

    echo ""
    echo -e "${BOLD}Configuring ~/.secrets${NC}"
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
            current=$(grep "^export ${varname}=" "$SECRETS" 2>/dev/null | cut -d'=' -f2- | sed 's/^"//;s/"$//')

            [ -n "$desc" ] && echo -e "  ${BLUE}${desc}${NC}"

            if [ -n "$current" ]; then
                echo -e "  ${varname}  ${YELLOW}[currently set]${NC}"
                printf "  new value (Enter to keep): "
            else
                printf "  %s: " "$varname"
            fi

            local value
            read -rs value
            echo ""

            if [ -n "$value" ]; then
                local tmpfile
                tmpfile=$(mktemp)
                grep -v "^export ${varname}=" "$SECRETS" > "$tmpfile" || true
                echo "export ${varname}=\"${value}\"" >> "$tmpfile"
                mv "$tmpfile" "$SECRETS"
                chmod 600 "$SECRETS"
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
    done 3< "$TEMPLATE"

    echo -e "${BOLD}done:${NC} ${set_count} set, ${keep_count} kept, ${skip_count} skipped"
    echo "Open a new shell (or run 'source ~/.secrets') to apply."
    echo ""
}

# --- Secrets: list ---

cmd_secrets_list() {
    if [ ! -f "$TEMPLATE" ]; then
        echo "error: template not found at $TEMPLATE" >&2
        exit 1
    fi

    # Source secrets so we check actual env state, not just file format
    [ -f "$SECRETS" ] && source "$SECRETS"

    echo ""
    echo -e "${BOLD}Secrets status${NC}"
    echo ""

    local set_count=0 missing_count=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^([A-Z_][A-Z0-9_]*)= ]]; then
            local varname="${BASH_REMATCH[1]}"
            if [ -n "${!varname}" ]; then
                echo -e "  ${GREEN}✓${NC}  $varname"
                ((set_count++))
            else
                echo -e "  ${RED}✗${NC}  $varname"
                ((missing_count++))
            fi
        fi
    done < "$TEMPLATE"

    echo ""
    echo "  ${set_count} set, ${missing_count} missing"
    [ "$missing_count" -gt 0 ] && echo "  run: ./setup.sh secrets set"
    echo ""
}

# --- Secrets: remove ---

cmd_secrets_remove() {
    if [ ! -f "$TEMPLATE" ]; then
        echo "error: template not found at $TEMPLATE" >&2
        exit 1
    fi

    local vars=()
    while IFS= read -r line; do
        [[ "$line" =~ ^([A-Z_][A-Z0-9_]*)= ]] && vars+=("${BASH_REMATCH[1]}")
    done < "$TEMPLATE"

    if [ ${#vars[@]} -eq 0 ]; then
        echo "no secrets defined in template."
        return
    fi

    echo ""
    echo -e "${BOLD}Select a secret to remove:${NC}"
    echo ""
    for i in "${!vars[@]}"; do
        local varname="${vars[$i]}"
        if grep -q "^export ${varname}=" "$SECRETS" 2>/dev/null; then
            echo -e "  $((i+1)))  $varname  ${YELLOW}(set)${NC}"
        else
            echo "  $((i+1)))  $varname"
        fi
    done
    echo ""

    printf "Enter number (or Enter to cancel): "
    local choice
    read -r choice
    echo ""

    if [[ -z "$choice" ]]; then
        echo "cancelled."
        return
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#vars[@]} ]; then
        echo -e "${RED}error:${NC} invalid selection." >&2
        return 1
    fi

    local varname="${vars[$((choice-1))]}"

    printf "Remove %s from template and ~/.secrets? [y/N] " "$varname"
    local confirm
    read -r confirm
    echo ""

    if [[ ! "$confirm" =~ ^[Yy] ]]; then
        echo "cancelled."
        return
    fi

    # Remove from ~/.secrets
    if grep -q "^export ${varname}=" "$SECRETS" 2>/dev/null; then
        local tmpfile
        tmpfile=$(mktemp)
        grep -v "^export ${varname}=" "$SECRETS" > "$tmpfile" || true
        mv "$tmpfile" "$SECRETS"
        chmod 600 "$SECRETS"
    fi

    # Remove var line and its immediately preceding comment from template
    local var_line comment_line tmpfile
    var_line=$(grep -n "^${varname}=" "$TEMPLATE" | cut -d: -f1)
    tmpfile=$(mktemp)
    if [ -n "$var_line" ]; then
        local above
        above=$(sed -n "$((var_line-1))p" "$TEMPLATE")
        [[ "$above" =~ ^# ]] && comment_line=$((var_line-1)) || comment_line=$var_line
        sed "${comment_line},${var_line}d" "$TEMPLATE" > "$tmpfile"
        mv "$tmpfile" "$TEMPLATE"
    fi

    echo -e "${GREEN}✓${NC} removed $varname"
    echo ""
}

# --- Dispatch ---

case "${1:-}" in
    "")        cmd_dotfiles ;;
    brew)      cmd_brew ;;
    claude)    cmd_claude ;;
    secrets)
        case "${2:-}" in
            add)    cmd_secrets_add ;;
            set)    cmd_secrets_set ;;
            list)   cmd_secrets_list ;;
            remove) cmd_secrets_remove ;;
            ""|help) cmd_secrets_help ;;
            *)
                echo "unknown secrets subcommand: $2"
                cmd_secrets_help
                exit 1
                ;;
        esac
        ;;
    help|--help|-h) cmd_help ;;
    *)
        echo "unknown command: $1"
        cmd_help
        exit 1
        ;;
esac
