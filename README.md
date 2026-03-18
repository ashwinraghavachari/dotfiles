# dotfiles

Personal configuration for bash, vim, and git. Works on macOS and Linux.

## Setup

Clone the repo and run the setup script from inside it:

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./setup.sh
```

This will:
- Back up any existing config files to `./old/`
- Symlink dotfiles into `~`
- Install Homebrew if it's missing (macOS only)
- Symlink Claude Code commands into `~/.claude/commands/`

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

On macOS, install [Homebrew](https://brew.sh) first — `setup.sh` will do this automatically if it's missing.

### Vim plugins

The `.vimrc` is configured for [Syntastic](https://github.com/vim-syntastic/syntastic) for syntax checking. Install it with your preferred plugin manager (e.g. [vim-plug](https://github.com/junegunn/vim-plug)):

```vim
Plug 'vim-syntastic/syntastic'
```

Syntastic calls out to language-specific linters. Install whichever you use:

| Language | Linters | macOS | Linux |
|----------|---------|-------|-------|
| Python | pylint, flake8, pylama | `pip install pylint flake8 pylama` | same |
| C/C++ | clang | `brew install llvm` | `apt install clang` |

### Claude Code commands

The `.claude/commands/` directory contains slash commands for Claude Code:

| Command | What it does |
|---------|--------------|
| `/standup` | Summarizes recent git commits into a standup update |
| `/explain <target>` | Explains how a file, function, or concept works |
| `/review` | Reviews staged/unstaged changes before committing |

Requires the [Claude Code CLI](https://claude.ai/code). `setup.sh` symlinks these into `~/.claude/commands/` automatically.

---

## What's included

| File | Purpose |
|------|---------|
| `.bashrc` | Shell config — history, prompt, colors, completion, aliases |
| `.bash_aliases` | Git, Docker, and project-specific aliases |
| `.bash_profile` | macOS login shell entrypoint — inits Homebrew, sources `.bashrc` |
| `.gitconfig` | Git user settings, rebase-on-pull, LFS, vim as editor |
| `.vimrc` | Vim settings — indentation, search, Syntastic, persistent undo |
| `.claude/commands/` | Claude Code slash commands |
