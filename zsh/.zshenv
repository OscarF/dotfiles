# ~/.zshenv - Environment variables loaded for all zsh sessions
# Ported from bash .bash_profile

# Ensure languages work correctly
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Editor configuration (from source/30_editor.sh)
export EDITOR='code -w'

# Set PATH, MANPATH, etc., for Homebrew
# This needs to be set early for other tools to find Homebrew packages
eval "$(/opt/homebrew/bin/brew shellenv)"
