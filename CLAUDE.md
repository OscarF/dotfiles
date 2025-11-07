# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Modern macOS dotfiles repository using Zsh, Oh My Zsh, Starship prompt, and GNU Stow for symlink management. Includes modern CLI tools (bat, eza, delta, fzf, ripgrep) and comprehensive macOS system configuration.

## Installation Commands

**Initial Setup (Run in order):**
```bash
./install.sh              # Install dotfiles via GNU Stow
./setup/homebrew          # Install Homebrew + packages from Brewfile
./setup/macos_settings    # Configure macOS system settings
./setup/app_settings      # Configure application-specific settings
```

**Re-installation:**
- Run `./install.sh` to re-stow packages (safe to run multiple times)
- Stow will update symlinks automatically

## Architecture

### GNU Stow Package System

The repository uses GNU Stow for symlink management. Each top-level directory (except `setup/`) is a "stow package":

**zsh/** - Zsh configuration package
- `.zshrc` - Main configuration (ported from bash source/*.sh files)
- `.zshenv` - Environment variables (LC_ALL, LANG, Homebrew, EDITOR)
- `.zshrc.local.example` - Template for machine-specific config

**git/** - Git configuration package
- `.gitconfig` - Git settings, aliases, delta configuration
- `.gitignore` - Global gitignore patterns
- `.git_commit_template` - Structured commit message template

**starship/** - Starship prompt package
- `.config/starship.toml` - Prompt configuration matching old bash prompt style

**apps/** - Application configuration package
- `.config/linearmouse/linearmouse.json` - LinearMouse configuration
- `Library/Application Support/Rectangle/RectangleConfig.json` - Rectangle window manager config

**When you run `stow -t ~ zsh`:**
- Creates `~/.zshrc` → `~/.dotfiles/zsh/.zshrc`
- Creates `~/.zshenv` → `~/.dotfiles/zsh/.zshenv`
- Stow automatically handles nested directories (e.g., `.config/`)

### Zsh Configuration Loading Order

1. `~/.zshenv` - Loaded first (environment variables, Homebrew setup)
2. `~/.zshrc` - Main config (Oh My Zsh, aliases, functions, plugins)
3. `~/.zshrc.local` - Machine-specific (sourced at end of .zshrc, not in git)

### Zsh Configuration Structure (zsh/.zshrc)

The .zshrc is organized into sections:

1. **Oh My Zsh Configuration** - Framework initialization with plugins (git, fzf, direnv)
2. **Zsh Options** - History settings (ported from source/30_history.sh)
3. **Completions** - Zsh completion system + Homebrew completions
4. **Keybindings** - History search (ported from source/10_misc.sh)
5. **Functions** - Custom functions like `cdf()` (ported from source/10_functions.sh)
6. **Aliases** - Navigation, file operations, git (ported from source/30_aliases.sh + 30_gitaliases.sh)
7. **External Plugins** - zsh-autosuggestions, zsh-syntax-highlighting, fzf
8. **Prompt** - Starship initialization
9. **Local Configuration** - Source ~/.zshrc.local if exists

### Installation Script Architecture (install.sh)

Simple script that:
1. Installs Oh My Zsh if not present
2. Checks for stow availability
3. Removes old bash symlinks
4. Runs `stow -R` for each package (zsh, git, starship)
5. Creates `~/.zshrc.local` from template if needed

Much simpler than old bin/dotfiles (no backup system, convention functions, or copy/link logic).

## Key Configuration Files

**zsh/.zshrc** - Main shell configuration
- Oh My Zsh plugins: git, fzf, direnv
- History: 10,000 entries, shared across sessions, ignore duplicates/spaces
- Modern tool aliases: `cat`→bat, `ls`→eza (with fallbacks)
- All original bash aliases preserved: `..`, `...`, `-`, `ll`, `la`, `gl`, `gs`, `gd`, etc.
- Functions: `cdf()` (cd to Finder), `gc()` (git checkout with default)

**zsh/.zshenv** - Environment setup
- Language: LC_ALL=en_US.UTF-8
- Editor: code -w (VS Code with wait flag)
- Homebrew: Evaluated early via `brew shellenv`

**starship/.config/starship.toml** - Prompt configuration
- Format: `[time] (python) [git] [user@host:path]\n[status] $`
- Shows: timestamp, Python virtualenv, git branch/status, exit codes
- Replaces 110 lines of custom bash prompt code
- Uses cyan color scheme matching original prompt

**git/.gitconfig** - Git configuration
- Pager: git-delta (side-by-side, line numbers, syntax highlighting)
- Pull strategy: `--ff-only` (safe, no merge commits)
- Autocorrect: 7ms delay
- Original aliases: lg, sum, wdiff, staged, etc.
- Modern aliases: recent, undo, amend, fixup, main, sync, clean-branches
- Commit template: Enforces type prefixes (feat/fix/docs/etc.)

**Brewfile** - Package manifest
- Core: stow, starship, zsh plugins (autosuggestions, syntax-highlighting, completions)
- Modern CLI: bat, eza, ripgrep, fd, fzf, git-delta
- Dev tools: direnv, git, molten-vk
- Apps: VS Code, Rectangle, Shottr, LinearMouse, Discord, Steam

**setup/homebrew** - Package installer (zsh script)
- Installs/updates Homebrew if missing
- No longer installs bash or changes shell (zsh is macOS default)
- Runs `brew bundle install` with Brewfile
- Links completions via `brew completions link`

**setup/macos_settings** - System preferences (zsh script)
- Keyboard: Fastest repeat rate (KeyRepeat=1)
- Trackpad: Gestures, momentum scroll, tap-to-click
- Dock: Auto-hide, no recents, minimal icons
- Finder: Show extensions, POSIX paths
- Control Center: Menu bar item visibility
- Requires logout/restart for some settings

**setup/app_settings** - Application config (zsh script)
- Optional script for additional app configurations
- Note: LinearMouse and Rectangle are now managed by apps/ stow package
- Currently only contains commented DOTA 2 configuration examples

## Important Constraints

**Platform**: macOS only (Apple Silicon primarily)
- Hardcoded path: `/opt/homebrew/bin/brew` (Apple Silicon)
- Uses macOS-specific commands: `defaults`, `osascript`, `brew`

**Shell**: Zsh 5.8+ (macOS default since Catalina)
- Uses zsh-specific features: `setopt`, `autoload`, `zstyle`
- Oh My Zsh framework required
- NOT compatible with bash without changes

**Machine-Specific Config**:
- `~/.zshrc.local` for private/local settings (not in git)
- Template available: `zsh/.zshrc.local.example`
- Use for: API keys, work-specific paths, experimental features

## Modifying Configuration

**Adding shell features:**
1. Edit `zsh/.zshrc` directly (it's version controlled)
2. For machine-specific: Add to `~/.zshrc.local`
3. Run `exec zsh` to reload
4. Commit changes to git

**Adding packages:**
1. Add to `Brewfile` (e.g., `brew "package-name"` or `cask "app-name"`)
2. Run `./setup/homebrew` to install
3. Configure in appropriate stow package

**Adding new stow package:**
1. Create directory: `mkdir newpackage`
2. Add files with home directory structure: `newpackage/.config/app/config.toml`
3. Add to `install.sh`: `stow -v -R -t ~ newpackage`

## Modern CLI Tool Aliases

**bat** (cat replacement):
- `cat file` - Syntax highlighted, plain style
- `cath file` - With header/line numbers
- Fallback to original cat if not installed

**eza** (ls replacement):
- `ls` - Icons, group directories first
- `ll` - Long format with icons
- `la` - Show hidden files
- `lal` - Long format + hidden
- `lsd` - Only directories
- Fallback to standard ls if not installed

**fzf** (fuzzy finder):
- `Ctrl+R` - Fuzzy history search
- `Ctrl+T` - Fuzzy file finder
- Integrated via Oh My Zsh plugin

**git-delta**:
- Automatically used for git diff/log
- Side-by-side view, line numbers
- Configured in git/.gitconfig

## Git Workflow

**Original aliases (preserved):**
- `gl` = git lg --all (graphical log)
- `gs` = git status
- `gd` = git diff
- `gpr` = git pull --rebase
- `gpu` = git push origin master
- `gco` = git checkout (defaults to master if no arg)

**Modern aliases (added):**
- `git recent` = Show recently checked out branches
- `git undo` = Undo last commit, keep changes
- `git amend` = Amend without editing message
- `git fixup <sha>` = Create fixup commit
- `git main` = Detect and return main/master branch name
- `git sync` = Fetch + rebase on main/master
- `git clean-branches` = Delete merged branches

**Commit template:**
- Opens in VS Code when you run `git commit`
- Enforces structure: `<type>: <subject>`
- Types: feat, fix, refactor, docs, test, chore, perf, style

## Migration Notes (from Bash)

**What was removed:**
- `link/`, `copy/`, `source/`, `bin/` directories (replaced by stow packages)
- Custom 110-line bash prompt (replaced by Starship)
- `path_remove()` function (no longer needed)
- Manual bind commands (Oh My Zsh handles it)

**What was preserved:**
- All aliases and functions (ported to .zshrc)
- Git configuration (enhanced with delta)
- macOS system settings (unchanged)
- Homebrew Brewfile pattern (modernized packages)

**Bash config still available:**
- Old files preserved in `link/`, `copy/`, `source/` for reference
- Can rollback: `git checkout master` + run old `./bin/dotfiles`
