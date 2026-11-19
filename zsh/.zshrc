# ~/.zshrc - Modern Zsh Configuration

# ==============================================================================
# Oh My Zsh Configuration
# ==============================================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh theme (disabled - using Starship instead)
ZSH_THEME=""

# Plugins
plugins=(
  git          # Git aliases and functions
  fzf          # Fuzzy finder integration
  direnv       # Directory environment loader
)

# Completion paths must be on fpath before Oh My Zsh runs compinit (once, below).
# HOMEBREW_PREFIX is set by `brew shellenv` in ~/.zprofile.
typeset -U fpath  # Drop duplicate entries
fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ==============================================================================
# Zsh Options
# ==============================================================================

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY           # Append to history file (don't overwrite)
setopt HIST_IGNORE_SPACE        # Don't record commands starting with space
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate entries from history
setopt HIST_VERIFY              # Show command with history expansion before running
setopt SHARE_HISTORY            # Share history between all sessions

# Completion options
setopt AUTO_LIST                # Automatically list choices on ambiguous completion
setopt AUTO_MENU                # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD         # Complete from both ends of a word

# ==============================================================================
# Completions
# ==============================================================================

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu selection for completions
zstyle ':completion:*' menu select

# ==============================================================================
# Convenience Functions
# ==============================================================================

# cd into whatever is the forefront Finder window
cdf() {
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}


pull-all-git-repositories-in-directory() {
  local parent="${1:-.}"
  local dirs=()

  for dir in "$parent"/*/; do
    [ -d "$dir/.git" ] || continue
    dirs+=("$dir")
  done

  print "Pulling ${#dirs[@]} repos:"
  printf '  %s\n' "${dirs[@]}"
  print ""

  (
    for dir in "${dirs[@]}"; do
      (
        result=$(git -C "$dir" pull --ff-only 2>&1)
        print "✓ ${dir%/} — $result"
      ) &
    done
    wait
    )
  }


# ==============================================================================
# Aliases
# ==============================================================================

# Navigation aliases (from source/30_aliases.sh)
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# ls aliases - Using eza with fallback to ls
if type eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias lal='eza -la --icons --group-directories-first'
  alias l='eza --icons'
  alias lsd='eza -lD --icons'  # List only directories
else
  # Fallback to standard ls if eza not installed
  alias ls='ls -hFG'
  alias ll='ls -l'
  alias la='ls -A'
  alias lal='ls -Al'
  alias l='ls -CF'
  alias lsd='ls -l | grep "^d"'
fi

# ==============================================================================
# External Plugins
# ==============================================================================

# fzf key bindings come from the Oh My Zsh fzf plugin

# zsh-autosuggestions
if [[ -f $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting (must be loaded last)
if [[ -f $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ==============================================================================
# Prompt (Starship)
# ==============================================================================

# Initialize Starship prompt (replaces 110 line custom bash prompt)
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ==============================================================================
# Git Aliases
# ==============================================================================

# Source git-specific aliases and functions
if [[ -f "$HOME/.zsh_git_aliases" ]]; then
  source "$HOME/.zsh_git_aliases"
fi

# ==============================================================================
# Local Configuration
# ==============================================================================

# Source local configuration file for machine-specific settings
# (replaces the .exports pattern from bash setup)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
