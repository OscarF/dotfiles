# Modern Dotfiles

**Modern macOS development environment for Apple Silicon with Zsh, Oh My Zsh, Starship, and modern CLI tools**

Automated configuration for shell, git, and system settings using GNU Stow for symlink management.

## Quick Start

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Run automated setup (installs everything!)
./install.sh

# This single command installs and configures:
# - Homebrew (package manager + health check + updates)
# - Oh My Zsh (zsh framework)
# - GNU Stow (symlink manager)
# - All dotfiles (zsh, git, starship, apps)
# - All packages from Brewfile (bat, eza, delta, fzf, starship, etc.)
# - Shell completions + cleanup

# 3. (Optional) Configure macOS system settings
./setup/macos_settings

# 4. Restart your terminal or run
exec zsh
```

## What's Included

### Shell Configuration (Zsh)
- **Oh My Zsh** - Framework with plugins for git, fzf, direnv
- **Starship** - Fast, customizable prompt showing git status, Python env, timestamps
- **zsh-autosuggestions** - Fish-like command suggestions
- **zsh-syntax-highlighting** - Real-time syntax highlighting
- **fzf** - Fuzzy finder for history (Ctrl+R) and files (Ctrl+T)

### Modern CLI Tools
- **bat** - cat with syntax highlighting
- **eza** - Modern ls replacement with colors and icons
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative
- **git-delta** - Beautiful syntax-highlighted git diffs
- **direnv** - Automatic environment variable loading per directory

### Git Configuration
- Enhanced with **delta** for beautiful diffs
- Modern aliases: `recent`, `undo`, `amend`, `fixup`, `sync`, `clean-branches`
- Structured commit template
- All existing aliases preserved (gl, gs, gd, gco, etc.)

### System Configuration
- Keyboard: Fastest repeat rate
- Trackpad: Custom gesture settings
- Dock: Auto-hide, minimal icons
- Finder: Show extensions, POSIX paths
- Screenshot: No shadows

## Repository Structure

```
.dotfiles/
├── zsh/                    # Zsh configuration (stow package)
│   ├── .zshrc             # Main configuration
│   ├── .zshenv            # Environment variables
│   └── .zshrc.local.example
├── git/                    # Git configuration (stow package)
│   ├── .gitconfig         # Git settings and aliases
│   ├── .gitignore         # Global gitignore
│   └── .git_commit_template
├── starship/               # Starship prompt (stow package)
│   └── .config/starship.toml
├── apps/                   # Application configs (stow package)
│   ├── .config/linearmouse/linearmouse.json
│   └── Library/Application Support/Rectangle/RectangleConfig.json
├── setup/                  # Setup scripts
│   └── macos_settings     # Configure macOS system settings
├── Brewfile               # Package manifest
├── install.sh             # Main automated installer
├── test.sh                # Validation test suite
├── README.md              # This file
└── CLAUDE.md              # AI assistant documentation
```

## Local Machine Configuration

Create `~/.zshrc.local` for machine-specific settings:

```bash
# Example: Custom PATH
export PATH="$HOME/custom/bin:$PATH"

# Example: API keys (NEVER commit to git)
export OPENAI_API_KEY="your-key-here"

# Example: Work-specific aliases
alias work-vpn="sudo openconnect vpn.example.com"
```

This file is sourced at the end of `.zshrc` and is NOT tracked in git.

## Key Aliases & Functions

### Navigation
- `..` - cd one level up
- `...` - cd two levels up
- `-` - cd to previous directory
- `cdf` - cd to current Finder location

### Files
- `ls`, `ll`, `la`, `lal` - Modern ls with eza (colors, icons, git status)
- `lsd` - List only directories
- Use `bat` for syntax-highlighted file viewing

### Git
Oh My Zsh provides 100+ git aliases (gst, gd, gco, gp, etc.). Custom additions:
- `gl` - Pretty log with graph (uses custom git lg)
- `gpu` - Git push current branch to origin
- `git recent` - Show recently used branches
- `git undo` - Undo last commit (keep changes)
- `git amend` - Amend last commit without editing
- `git sync` - Fetch and rebase on main/master
- `git clean-branches` - Delete merged branches

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-stow packages
```

## Uninstalling

```bash
cd ~/.dotfiles
stow -D zsh git starship apps
rm ~/.zshrc.local
# Optionally restore previous shell: chsh -s /bin/zsh
```

## Requirements

- **macOS on Apple Silicon** (M1/M2/M3/M4 Macs)
- Homebrew (automatically installed by install.sh at `/opt/homebrew`)
- Git

**Note:** This setup is specifically configured for Apple Silicon Macs and will not work on Intel Macs without modification.

## Testing & Validation

```bash
# Run validation tests to verify installation
./test.sh
```

The test suite validates:
- All symlinks are correctly created
- Required tools are installed (brew, stow, starship, git, delta)
- Configuration files have valid syntax
- Zsh plugins are available
- Modern CLI tools are working

## Features

- **Apple Silicon optimized**: Configured specifically for M-series Macs
- **Idempotent**: Safe to run `install.sh` multiple times
- **Automated**: Single command installs and configures everything
- **Tested**: Comprehensive test suite validates installation
- **Documented**: Extensive CLAUDE.md for AI assistants and maintainers
- **Modern**: Uses current best practices and maintained tools