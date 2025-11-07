# Modern Dotfiles

**Modern macOS development environment with Zsh, Oh My Zsh, Starship, and modern CLI tools**

Automated configuration for shell, git, and system settings using GNU Stow for symlink management.

## Quick Start

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Install dotfiles (creates symlinks)
./install.sh

# 3. Install packages and applications
./setup/homebrew

# 4. Configure macOS system settings
./setup/macos_settings

# 5. (Optional) Configure additional app settings if needed
# ./setup/app_settings

# 6. Restart your terminal or run
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
│   ├── homebrew           # Install packages
│   ├── macos_settings     # Configure macOS
│   └── app_settings       # Optional app-specific configs
├── Brewfile               # Package manifest
├── install.sh             # Main installer
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
- `cat` - Syntax-highlighted with bat
- `lsd` - List only directories

### Git
- `gl` - Pretty log with graph
- `gs` - Git status
- `gd` - Git diff
- `gco` - Git checkout
- `gpr` - Git pull with rebase
- `gpu` - Git push to origin master
- `git recent` - Show recently used branches
- `git undo` - Undo last commit (keep changes)
- `git amend` - Amend last commit without editing
- `git sync` - Fetch and rebase on main/master

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-stow packages
```

## Uninstalling

```bash
cd ~/.dotfiles
stow -D zsh git starship
rm ~/.zshrc.local
```

## Migration from Bash

If you're migrating from the old bash setup:
- Old configs preserved in `link/`, `copy/`, `source/` directories
- `.bash_profile` replaced by `.zshrc`
- Custom 110-line prompt replaced by Starship (~50 lines)
- All aliases and functions ported to zsh
- `.exports` pattern replaced by `.zshrc.local`

## Requirements

- macOS (tested on Apple Silicon)
- Homebrew
- Git

## Credits

Originally based on [cowboy/dotfiles](https://github.com/cowboy/dotfiles), modernized with:
- Zsh + Oh My Zsh
- GNU Stow for symlink management
- Starship prompt
- Modern CLI tools (bat, eza, delta, fzf, ripgrep)
