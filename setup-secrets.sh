#!/usr/bin/env bash
# Interactive secrets setup — walks through .secrets.template and writes ~/.secrets

TEMPLATE="$(dirname "$0")/.secrets.template"
SECRETS="$HOME/.secrets"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

if [ ! -f "$TEMPLATE" ]; then
    echo "error: template not found at $TEMPLATE" >&2
    exit 1
fi

touch "$SECRETS" && chmod 600 "$SECRETS"

echo ""
echo -e "${BOLD}Setting up ~/.secrets${NC}"
echo "Press Enter to skip a variable (or keep its existing value)."
echo ""

set_count=0
keep_count=0
skip_count=0
desc=""

while IFS= read -r line; do
    # Accumulate comment as hint for the next variable
    if [[ "$line" =~ ^#[[:space:]]?(.*) ]]; then
        desc="${BASH_REMATCH[1]}"
        continue
    fi

    # Blank line resets description
    if [[ -z "$line" ]]; then
        desc=""
        continue
    fi

    # Variable line (e.g. FOO= or FOO=defaultval)
    if [[ "$line" =~ ^([A-Z_][A-Z0-9_]*)= ]]; then
        varname="${BASH_REMATCH[1]}"

        # Check for existing value in secrets file
        current=$(grep "^export ${varname}=" "$SECRETS" 2>/dev/null | cut -d'=' -f2- | sed 's/^"//;s/"$//')

        [ -n "$desc" ] && echo -e "  ${BLUE}${desc}${NC}"

        if [ -n "$current" ]; then
            printf "  %s [currently set, Enter to keep]: " "$varname"
        else
            printf "  %s: " "$varname"
        fi

        read -rs value
        echo ""

        if [ -n "$value" ]; then
            # Write or replace the value
            tmpfile=$(mktemp)
            grep -v "^export ${varname}=" "$SECRETS" > "$tmpfile"
            echo "export ${varname}=\"${value}\"" >> "$tmpfile"
            mv "$tmpfile" "$SECRETS"
            chmod 600 "$SECRETS"
            echo -e "  ${GREEN}✓ set${NC}"
            ((set_count++))
        elif [ -n "$current" ]; then
            echo -e "  ${YELLOW}→ kept existing${NC}"
            ((keep_count++))
        else
            echo -e "  ${YELLOW}↷ skipped${NC}"
            ((skip_count++))
        fi

        echo ""
        desc=""
    fi
done < "$TEMPLATE"

echo -e "${BOLD}Done:${NC} ${set_count} set, ${keep_count} kept, ${skip_count} skipped"
echo "Open a new shell (or run 'source ~/.secrets') to apply."
echo ""
