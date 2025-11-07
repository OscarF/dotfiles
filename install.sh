#!/usr/bin/env bash

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

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    echo -e "${BLUE}📦 Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓ Oh My Zsh installed${NC}"
else
    echo -e "${GREEN}✓ Oh My Zsh already installed${NC}"
fi

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo ""
    echo -e "${YELLOW}⚠️  GNU Stow not found. Please install it first:${NC}"
    echo "   brew install stow"
    echo ""
    echo "Then run this script again."
    exit 1
fi

# Stow packages
echo ""
echo -e "${BLUE}🔗 Creating symlinks with GNU Stow...${NC}"

# Remove old symlinks if they exist (from bash setup)
[ -L "$HOME/.bash_profile" ] && rm "$HOME/.bash_profile"
[ -L "$HOME/.gitconfig" ] && rm "$HOME/.gitconfig"
[ -L "$HOME/.gitignore" ] && rm "$HOME/.gitignore"

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

# Summary
echo ""
echo -e "${GREEN}✅ Dotfiles installed successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. Run: ./setup/homebrew    (Install packages from Brewfile)"
echo "  2. Run: ./setup/macos_settings  (Configure macOS settings)"
echo "  3. Run: ./setup/app_settings    (Configure applications)"
echo "  4. Restart your terminal or run: exec zsh"
echo ""
echo "Note: Your old bash config is preserved in the 'link/', 'copy/', and 'source/' directories"
echo "      if you need to reference anything."
