#!/usr/bin/env zsh

set -e

echo "🚀 Installing Modern Dotfiles (Zsh + Oh My Zsh + Starship)"
echo "=========================================================="

# Change to dotfiles directory
cd "$(dirname "$0")"
DOTFILES_DIR="$(pwd)"

# Colors for output
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo ""
    echo -e "${BLUE}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add homebrew to PATH for current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo -e "${GREEN}✓ Homebrew installed${NC}"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    echo -e "${BLUE}📦 Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓ Oh My Zsh installed${NC}"
else
    echo -e "${GREEN}✓ Oh My Zsh already installed${NC}"
fi

# Install GNU Stow if not present
if ! command -v stow &> /dev/null; then
    echo ""
    echo -e "${BLUE}📦 Installing GNU Stow...${NC}"
    brew install stow
    echo -e "${GREEN}✓ GNU Stow installed${NC}"
else
    echo -e "${GREEN}✓ GNU Stow already installed${NC}"
fi

# Stow packages
echo ""
echo -e "${BLUE}🔗 Creating symlinks with GNU Stow...${NC}"

# Stow the packages
stow -v -R -t ~ zsh
stow -v -R -t ~ git
stow -v -R -t ~ starship
stow -v -R -t ~ apps

echo -e "${GREEN}✓ Symlinks created${NC}"

# Create .zshrc.local if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo ""
    echo -e "${BLUE}📝 Creating ~/.zshrc.local from template...${NC}"
    cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
    echo -e "${GREEN}✓ ~/.zshrc.local created${NC}"
    echo -e "${YELLOW}   Edit this file for machine-specific configuration${NC}"
else
    echo -e "${GREEN}✓ ~/.zshrc.local already exists${NC}"
fi

# Install packages from Brewfile
echo ""
echo -e "${BLUE}📦 Installing packages from Brewfile...${NC}"
echo -e "${BLUE}   This may take several minutes...${NC}"
brew bundle install --file="$DOTFILES_DIR/Brewfile"
echo -e "${GREEN}✓ All packages installed${NC}"

# Summary
echo ""
echo -e "${GREEN}✅ Complete automated setup finished!${NC}"
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
