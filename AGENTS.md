# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Modern macOS dotfiles repository using Zsh, Oh My Zsh, Starship prompt, and GNU Stow for symlink management. Includes modern CLI tools (bat, eza, delta, fzf, ripgrep) and comprehensive macOS system configuration.

## Installation Commands

**Complete Automated Setup:**
```bash
./install.sh              # One command installs EVERYTHING
./test.sh                 # (Optional) Validate installation
./setup/macos_settings    # (Optional) Configure macOS system settings
```

**What install.sh does:**
1. Validates prerequisites (Brewfile exists)
2. Installs Homebrew (with health check + update)
3. Installs Oh My Zsh
4. Installs GNU Stow
5. Stows all packages (zsh, git, starship, apps) with validation
6. Creates ~/.zshrc.local from template
7. Installs all Brewfile packages
8. Links shell completions + cleanup
9. Runs test.sh validation suite automatically

**What test.sh does:**
- Validates all expected symlinks exist (~/.zshrc, ~/.gitconfig, etc.)
- Checks required tools are installed (brew, stow, starship, git, delta)
- Verifies configuration files load without errors
- Tests Oh My Zsh and plugins are available
- Checks modern CLI tools (eza, bat, fzf, ripgrep)
- Returns exit code 0 on success, 1 on failure

**Re-installation:**
- Run `./install.sh` again - it's idempotent and safe to run multiple times
- Checks before installing (won't reinstall if already present)
- Validates installation with test suite at the end

## Architecture

### GNU Stow Package System

The repository uses GNU Stow for symlink management. Each top-level directory (except `setup/`) is a "stow package":

**zsh/** - Zsh configuration package
- `.zshrc` - Main configuration
- `.zshenv` - Environment variables (Homebrew path for Apple Silicon, EDITOR)
- `.zsh_git_aliases` - Git-specific aliases and functions (sourced by .zshrc)
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
3. `~/.zsh_git_aliases` - Git aliases and functions (sourced by .zshrc)
4. `~/.zshrc.local` - Machine-specific (sourced at end of .zshrc, not in git)

### Zsh Configuration Structure (zsh/.zshrc)

The .zshrc is organized into sections:

1. **Oh My Zsh Configuration** - Framework initialization with plugins (git, fzf, direnv)
2. **Zsh Options** - History settings (10k entries, share history, ignore duplicates)
3. **Completions** - Zsh completion system + Homebrew completions
4. **Functions** - Custom functions like `cdf()` (cd to Finder window)
5. **Aliases** - Navigation (`.., ...`) and ls/eza aliases
6. **External Plugins** - zsh-autosuggestions, zsh-syntax-highlighting, fzf
7. **Prompt** - Starship initialization
8. **Git Aliases** - Source ~/.zsh_git_aliases (custom git shortcuts)
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
- Oh My Zsh plugins: git (provides 100+ aliases like `gst`, `gd`, `gco`), fzf, direnv
- History: 10,000 entries, shared across sessions, ignore duplicates/spaces
- Modern tool aliases: `ls`→eza (with fallback to standard ls)
- Navigation aliases: `..`, `...`, `-`, `ll`, `la`, `lal`, `lsd`
- Functions: `cdf()` (cd to Finder window)
- Sources: ~/.zsh_git_aliases and ~/.zshrc.local

**zsh/.zsh_git_aliases** - Custom git shortcuts
- `gl` - Uses custom `git lg` from .gitconfig (graphical log)
- `gpu` - Push current branch to origin
- Note: Most git aliases come from Oh My Zsh git plugin

**zsh/.zshenv** - Environment setup
- Editor: code -w (VS Code with wait flag)
- Homebrew: Hardcoded `/opt/homebrew/bin/brew` (Apple Silicon only)

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

**install.sh** - Complete automated installer (zsh script, 237 lines)
- Single command setup for everything
- Uses zsh-native colors (`print -P` with prompt expansion)
- Installs: Homebrew, Oh My Zsh, Stow, packages
- Maintains: brew doctor, update, completions link, cleanup
- Idempotent: safe to run multiple times
- Sets DOTFILES_DIR variable for safety (resolves to absolute path)

**setup/macos_settings** - System preferences (zsh script)
- Keyboard: Fastest repeat rate (KeyRepeat=1)
- Trackpad: Gestures, momentum scroll, tap-to-click
- Dock: Auto-hide, no recents, minimal icons
- Finder: Show extensions, POSIX paths
- Control Center: Menu bar item visibility
- Requires logout/restart for some settings

## Important Constraints

**Platform**: macOS on Apple Silicon only (M1/M2/M3/M4)
- Hardcoded Homebrew path: `/opt/homebrew/bin/brew` (Apple Silicon)
- Uses macOS-specific commands: `defaults`, `osascript`, `brew`
- Will NOT work on Intel Macs without modification

**Shell**: Zsh 5.8+ (macOS default since Catalina)
- Uses zsh-specific features: `setopt`, `autoload`, `zstyle`
- Oh My Zsh framework required
- NOT compatible with bash without changes

**Machine-Specific Config**:
- `~/.zshrc.local` for private/local settings (not in git)
- Template available: `zsh/.zshrc.local.example`
- Use for: API keys, work-specific paths, experimental features

## Quality & Testing

**Test Suite (test.sh):**
- Validates symlinks, tools, and configuration loading
- Run manually: `./test.sh`
- Auto-runs at end of `install.sh`
- Exit code 0 = success, 1 = failure

**Pre-commit Hook:**
- Automatically runs shellcheck on staged shell scripts
- Located: `.git/hooks/pre-commit`
- Checks: `*.sh`, `*.zsh`, `*.bash`, and `setup/*` files
- Skip with: `git commit --no-verify`
- Install shellcheck: `brew install shellcheck`

**Code Quality:**
- All shell scripts follow shellcheck recommendations
- Pre-commit hook prevents committing scripts with issues
- test.sh validates installation integrity

## Modifying Configuration

**Adding shell features:**
1. Edit `zsh/.zshrc` directly (it's version controlled)
2. For machine-specific: Add to `~/.zshrc.local`
3. Run `exec zsh` to reload
4. Commit changes to git

**Adding packages:**
1. Add to `Brewfile` (e.g., `brew "package-name"` or `cask "app-name"`)
2. Run `brew bundle install` or re-run `./install.sh`
3. Configure in appropriate stow package
4. Run `./test.sh` to validate

**Adding new stow package:**
1. Create directory: `mkdir newpackage`
2. Add files with home directory structure: `newpackage/.config/app/config.toml`
3. Add to `install.sh`: `stow -v -R -t ~ newpackage`
4. Update `test.sh` to validate new symlinks

## Modern CLI Tool Aliases

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

**Oh My Zsh git plugin provides 100+ aliases including:**
- `gst` = git status
- `gd` = git diff
- `gco` = git checkout
- `gp` = git push
- `gl` = git pull
- `gru` = git remote update
- Full list: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git

**Custom aliases (in ~/.zsh_git_aliases):**
- `gl` = git lg --all (overrides OMZ, uses custom graphical log from .gitconfig)
- `gpu` = git push origin current-branch (shorter than OMZ's ggpush)

**Git config aliases (in ~/.gitconfig):**
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
- Custom git aliases (replaced by Oh My Zsh git plugin)
- History prefix-search keybindings (standard arrow keys + Ctrl+R fzf)
- cat→bat override (use `bat` command directly)
- Deprecated `brew cask` alias
- Utility aliases (`bar`)

**What was preserved:**
- Navigation aliases (`.., ...`) and functions (`cdf`)
- ls→eza aliases (with fallback)
- History configuration (10k entries, shared, no duplicates)
- Git configuration in .gitconfig (enhanced with delta)
- macOS system settings (unchanged)
- Homebrew Brewfile pattern (modernized packages)

**Rollback to bash:**
- Old bash configuration is available in git history (pre-migration commits)
- Use `git log --all --oneline | grep -i bash` to find historical commits
