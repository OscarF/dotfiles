# ~/.zshenv - Environment variables loaded for all zsh sessions

# Editor configuration
export EDITOR='code -w' # Use VS Code as default editor

# Set PATH, MANPATH, etc., for Homebrew
# This needs to be set early for other tools to find Homebrew packages
# Apple Silicon only
eval "$(/opt/homebrew/bin/brew shellenv)"
