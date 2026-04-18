# dotfiles

Personal configuration for bash, zsh, vim, and git. Works on macOS and Linux.

---

## New machine setup

```bash
git clone https://github.com/ashwinraghavachari/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script will walk you through everything step by step. After it completes:

- [ ] Fill in `~/.secrets` with API keys (`./setup.sh secrets set`)
- [ ] Add machine-specific shell config to `~/.zshrc.local` (PATH additions, SDK inits, tool completions)
- [ ] Fill in `~/.ssh/config` with your hosts (template copied to `~/.ssh/config` by setup)
- [ ] Install App Store apps manually (these can't be scripted)
- [ ] Set up SSH keys (`ssh-keygen -t ed25519 -C "your@email.com"`) and add to GitHub

---

## Commands

```bash
./setup.sh                  # full setup
./setup.sh brew             # install packages from Brewfile
./setup.sh secrets set      # set API key values interactively
./setup.sh secrets add      # add a new secret to track
./setup.sh secrets list     # check what's configured
./setup.sh secrets remove   # remove a secret
./setup.sh help             # show all commands
```

---

## What's included

| File | Purpose |
|------|---------|
| `.bashrc` | Bash-specific config — history, prompt, completion |
| `.zshrc` | Zsh-specific config — history, completion; sources `.shellrc` |
| `.shellrc` | Cross-shell config — aliases, functions, sources `~/.secrets` |
| `.bash_profile` | macOS login shell entrypoint — inits Homebrew, sources `.bashrc` |
| `.gitconfig` | Git settings — rebase-on-pull, LFS, global ignore, vim editor |
| `.gitignore_global` | Global gitignore — `.DS_Store`, editor files, secrets, build artifacts |
| `.vimrc` | Vim settings — indentation, search, Syntastic, persistent undo |
| `.secrets.template` | Manifest of required API keys (copy becomes `~/.secrets`) |
| `.ssh/config.template` | SSH config template (copy becomes `~/.ssh/config`) |
| `Brewfile` | Homebrew packages (`brew bundle` installs everything) |
| `setup.sh` | Bootstrap script |
| `.claude/commands/` | Claude Code slash commands |

### Not in repo (machine-specific)

| File | Purpose |
|------|---------|
| `~/.secrets` | Actual API key values |
| `~/.zshrc.local` | Machine-specific shell config (PATH, SDK inits, completions) |
| `~/.ssh/config` | SSH host config (filled in from template) |
| `~/.gitconfig.work` | Work identity for `[includeIf]` (see `.gitconfig` comments) |

---

## Dependencies

### Core (required)

| Tool | macOS | Linux (Debian/Ubuntu) |
|------|-------|-----------------------|
| bash | built-in | built-in |
| git | `brew install git` | `apt install git` |
| git-lfs | `brew install git-lfs` | `apt install git-lfs` |
| vim | `brew install vim` | `apt install vim` |
| bash-completion | `brew install bash-completion@2` | `apt install bash-completion` |
| curl | built-in | `apt install curl` |

On macOS, install [Homebrew](https://brew.sh) first — `setup.sh` will do this automatically if missing. Then run `./setup.sh brew` to install everything from the Brewfile.

### Claude Code commands

The `.claude/commands/` directory contains slash commands for Claude Code. `setup.sh` symlinks these into `~/.claude/commands/` automatically.

Requires the [Claude Code CLI](https://claude.ai/code).
