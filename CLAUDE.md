# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository based on the cowboy/dotfiles framework. It automates shell configuration, system setup, and application installation for a consistent development environment.

## Installation Commands

**Initial Setup (Run in order):**
```bash
./bin/dotfiles              # Copy/symlink dotfiles to home directory
./setup/homebrew            # Install Homebrew, Bash 4, and packages from Brewfile
./setup/macos_settings      # Configure macOS system settings
./setup/app_settings        # Configure application-specific settings
```

**Re-run Installation:**
- `./bin/dotfiles` safely backs up existing files to `.dotfiles/backups/YYYY_MM_DD-HH_MM_SS/`
- Press `X` within 5 seconds when prompted to skip file operations

## Architecture

### File Organization Pattern

The repository uses a convention-based system where directory names determine behavior:

**copy/** - Files copied to `~/` (e.g., `.gitconfig`, `.gitignore`)
- Uses `cmp` to detect if source and destination differ
- Backs up existing files before copying

**link/** - Files symlinked to `~/` (e.g., `.bash_profile`)
- Creates relative symlinks using `ln -sf`
- Backs up existing files before linking

**source/** - Shell configuration loaded by `.bash_profile`
- Files loaded alphabetically (use numeric prefixes to control order)
- Naming convention: `[priority]_[name].sh`
  - `10_*` = Core utilities and functions
  - `20_*` = Package managers and completions
  - `30_*` = User-facing features (aliases, prompt, git)

**setup/** - System and application setup scripts
- Executed manually, not automatically loaded
- Contains platform-specific configuration

**bin/** - Executable utilities added to PATH

### Source File Loading

`.bash_profile` loads all files from `source/` via the `src()` function:
```bash
for file in ~/.dotfiles/source/*; do
  source "$file"
done
```

Files are sourced in alphabetical order, so numeric prefixes control dependencies.

### Installation Script Architecture (bin/dotfiles)

The installation uses a pattern-based dispatch system:

1. **Convention Functions**: For each directory (`copy`, `link`), the script calls:
   - `{action}_header()` - Display section header
   - `{action}_test()` - Check if operation needed (returns skip reason)
   - `{action}_do()` - Perform the operation

2. **do_stuff()**: Generic handler that iterates files and calls convention functions

3. **Backup System**: Before overwriting, files are moved to timestamped backup directories

## Key Configuration Files

**copy/.gitconfig** - Git configuration
- Editor: VS Code with `-w` (wait) flag
- Pull strategy: `--ff-only` (safe, no merge commits)
- Autocorrect: 7ms delay before executing typo corrections
- Custom aliases: `lg` (graphical log), `sum` (summary log), `wdiff` (word diff)

**link/.bash_profile** - Shell entry point
- Sources `.exports` for machine-specific config (not in repo)
- Initializes Homebrew environment via `eval "$(/opt/homebrew/bin/brew shellenv)"`

**source/30_prompt.sh** - Advanced Bash prompt
- Uses `PROMPT_COMMAND` to rebuild PS1 on each command
- Displays: Python virtualenv, git branch/status, user@host:path, timestamp, exit code
- Color-codes by context (SSH=green, root=magenta, normal=cyan)
- Uses `trap ... DEBUG` to track command execution

**source/30_history.sh** - History configuration
- 10,000 entry history with ISO timestamps
- `HISTCONTROL=ignorespace:erasedups` removes duplicates
- `shopt -s histappend` preserves history across sessions

**setup/homebrew** - Package installation
- Installs/updates Homebrew if missing
- Installs Bash 4 and bash-completion@2
- Changes default shell to Homebrew-installed Bash
- Runs `brew bundle install` with setup/Brewfile

**setup/macos_settings** - System preferences
- Sets fastest keyboard repeat rate (KeyRepeat=1)
- Configures trackpad gestures and mouse sensitivity
- Customizes Dock (auto-hide, no recents, removes all icons)
- Sets Finder to show POSIX paths and file extensions
- Requires logout/restart for some settings to take effect

## Important Constraints

**Platform**: macOS only
- Hardcoded paths assume Apple Silicon (`/opt/homebrew`)
- Uses macOS-specific commands (`defaults`, `osascript`, `chsh`)

**Shell**: Bash 4+ required
- Uses bash-specific features: `PROMPT_COMMAND`, `BASH_COMMAND`, `shopt`
- Arrays, `[[ ]]` conditionals, process substitution
- NOT compatible with sh or zsh without modification

**Machine-Specific Config**:
- `.bash_profile` sources `~/.exports` (not in repo) for private/local settings
- Use this file for API keys, local paths, etc.

## Modifying Shell Configuration

When adding new shell features:

1. Create file in `source/` with appropriate prefix:
   - `10_*` for core functions/utilities needed by other files
   - `20_*` for third-party integrations (completions, tools)
   - `30_*` for user-facing aliases/functions/prompts

2. Use the `src()` function to reload: `src` or `src 30_aliases` (reload single file)

3. Convention functions in `bin/dotfiles`:
   - Test functions should `echo` a skip reason or return silently
   - Do functions should call `e_success` for user feedback

## Git Workflow

Custom git aliases defined in copy/.gitconfig and source/30_gitaliases.sh:
- `gl` = git log with custom formatting
- `gs` = git status
- `gd` = git diff
- `gpr` = git pull with rebase
- `gp` = git push
- `gpu` = git push -u origin HEAD
- `gru` = git remote update
- `gco` = git checkout
