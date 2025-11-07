# Ensure languages work
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Source all files in ~/dotfiles/source/
function src() {
  local file
  if [[ "$1" ]]; then
    source "$HOME/.dotfiles/source/$1.sh"
  else
    for file in ~/.dotfiles/source/*; do
      source "$file"
    done
  fi
}

src

# For machine specific things we don't want on github
if [ -f .exports ]; then
  source .exports
fi

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
