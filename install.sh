#!/usr/bin/env zsh

set -e

echo "🚀 Installing Modern Dotfiles (Zsh + Oh My Zsh + Starship)"
echo "=========================================================="

# Change to dotfiles directory
cd "$(dirname "$0")"
DOTFILES_DIR="$(pwd)"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo ""
    print -P "%F{blue}📦 Installing Homebrew...%f"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    print -P "%F{green}✓ Homebrew installed%f"
else
    print -P "%F{green}✓ Homebrew already installed%f"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    print -P "%F{blue}📦 Installing Oh My Zsh...%f"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print -P "%F{green}✓ Oh My Zsh installed%f"
else
    print -P "%F{green}✓ Oh My Zsh already installed%f"
fi

# Install GNU Stow if not present
if ! command -v stow &> /dev/null; then
    echo ""
    print -P "%F{blue}📦 Installing GNU Stow...%f"
    brew install stow
    print -P "%F{green}✓ GNU Stow installed%f"
else
    print -P "%F{green}✓ GNU Stow already installed%f"
fi

# Stow packages
echo ""
print -P "%F{blue}🔗 Creating symlinks with GNU Stow...%f"

# Stow the packages
stow -v -R -t ~ zsh
stow -v -R -t ~ git
stow -v -R -t ~ starship
stow -v -R -t ~ apps

print -P "%F{green}✓ Symlinks created%f"

# Create .zshrc.local if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo ""
    print -P "%F{blue}📝 Creating ~/.zshrc.local from template...%f"
    cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
    print -P "%F{green}✓ ~/.zshrc.local created%f"
    print -P "%F{yellow}   Edit this file for machine-specific configuration%f"
else
    print -P "%F{green}✓ ~/.zshrc.local already exists%f"
fi

# Install packages from Brewfile
echo ""
print -P "%F{blue}📦 Installing packages from Brewfile...%f"
print -P "%F{blue}   This may take several minutes...%f"
brew bundle install --file="$DOTFILES_DIR/Brewfile"
print -P "%F{green}✓ All packages installed%f"

# Summary
echo ""
print -P "%F{green}✅ Complete automated setup finished!%f"
echo ""
echo "What was installed:"
echo "  ✓ Homebrew package manager"
echo "  ✓ Oh My Zsh framework"
echo "  ✓ GNU Stow (symlink manager)"
echo "  ✓ All dotfiles (zsh, git, starship, apps)"
echo "  ✓ All packages from Brewfile (bat, eza, delta, fzf, starship, etc.)"
echo ""
echo "Optional next step:"
echo "  • Run: ./setup/macos_settings   (Configure macOS system settings)"
echo ""
echo "To start using your new setup:"
echo "  exec zsh"
echo ""
