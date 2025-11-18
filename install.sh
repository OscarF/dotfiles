#!/usr/bin/env zsh

set -e

echo "🚀 Installing Modern Dotfiles (Zsh + Oh My Zsh + Starship)"
echo "=========================================================="

# Change to dotfiles directory
cd "$(dirname "$0")"
DOTFILES_DIR="$(pwd)"

# ==============================================================================
# Prerequisites Validation
# ==============================================================================

echo ""
print -P "%F{blue}🔍 Validating prerequisites...%f"

# Check OS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print -P "%F{red}✗ Error: This setup is for macOS only (detected: $OSTYPE)%f"
    exit 1
fi

# Check for Apple Silicon
ARCH="$(uname -m)"
if [[ "$ARCH" != "arm64" ]]; then
    print -P "%F{red}✗ Error: This setup requires Apple Silicon%f"
    print -P "%F{red}  Detected architecture: $ARCH%f"
    print -P "%F{yellow}  Intel Macs are not supported without modifications%f"
    print -P "%F{yellow}  (Homebrew path is hardcoded to /opt/homebrew)%f"
    exit 1
fi

# Keep track of errors to print
PRE_CHECK_ERRORS=()

# Check required files
if [ ! -f "Brewfile" ]; then
    PRE_CHECK_ERRORS+=("Brewfile not found in $DOTFILES_DIR")
fi

if [ ! -f "zsh/.zshrc.local.example" ]; then
    PRE_CHECK_ERRORS+=("zsh/.zshrc.local.example not found")
fi

if [ ! -f "git/.gitconfig.local.example" ]; then
    PRE_CHECK_ERRORS+=("git/.gitconfig.local.example not found")
fi

if [ ! -f "test.sh" ]; then
    PRE_CHECK_ERRORS+=("test.sh not found (validation will be skipped)")
fi

# Check required directories (stow packages)
for pkg in zsh git starship apps; do
    if [ ! -d "$pkg" ]; then
        PRE_CHECK_ERRORS+=("Required package directory '$pkg/' not found")
    fi
done

# Check write permissions
if [ ! -w "$HOME" ]; then
    PRE_CHECK_ERRORS+=("No write permission to home directory ($HOME)")
fi

# Report errors if any
if [ ${#PRE_CHECK_ERRORS[@]} -gt 0 ]; then
    print -P "%F{red}✗ Prerequisites validation failed:%f"
    echo ""
    for error in "${PRE_CHECK_ERRORS[@]}"; do
        print -P "%F{red}  • $error%f"
    done
    echo ""
    print -P "%F{red}Please fix the above issues and try again.%f"
    exit 1
fi

print -P "%F{green}✓ All prerequisites validated%f"

# ==============================================================================
# Installation
# ==============================================================================

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo ""
    print -P "%F{blue}📦 Installing Homebrew...%f"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add homebrew to PATH for current session (Apple Silicon)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print -P "%F{green}✓ Homebrew installed%f"
else
    print -P "%F{green}✓ Homebrew already installed%f"
fi

# Update Homebrew and verify health
echo ""
print -P "%F{blue}🔍 Checking Homebrew health...%f"
brew doctor || true  # Show warnings but don't exit on them
brew update
print -P "%F{green}✓ Homebrew updated%f"

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ""
    print -P "%F{blue}📦 Installing Oh My Zsh...%f"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print -P "%F{green}✓ Oh My Zsh installed%f"

    # Remove OMZ-created .zshrc so stow can create our custom symlink
    rm -f "$HOME/.zshrc"
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

# Stow each package with error checking
# Using a loop to reduce repetition while maintaining clear error messages
for pkg in zsh git starship apps; do
    if ! stow -v -R -t ~ "$pkg"; then
        print -P "%F{red}✗ Error: Failed to stow $pkg package%f"
        exit 1
    fi
done

# Validate that key symlinks were created
if [ ! -L "$HOME/.zshrc" ]; then
    print -P "%F{red}✗ Error: ~/.zshrc symlink was not created%f"
    exit 1
fi

if [ ! -L "$HOME/.gitconfig" ]; then
    print -P "%F{red}✗ Error: ~/.gitconfig symlink was not created%f"
    exit 1
fi

print -P "%F{green}✓ Symlinks created and validated%f"

# Create .zshrc.local if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo ""
    print -P "%F{blue}📝 Creating ~/.zshrc.local from template...%f"
    cp "zsh/.zshrc.local.example" "$HOME/.zshrc.local"
    print -P "%F{green}✓ ~/.zshrc.local created%f"
    print -P "%F{yellow}   Edit this file for machine-specific configuration%f"
else
    print -P "%F{green}✓ ~/.zshrc.local already exists%f"
fi

# Create .gitconfig.local if it doesn't exist
if [ ! -f "$HOME/.gitconfig.local" ]; then
    echo ""
    print -P "%F{blue}📝 Creating ~/.gitconfig.local from template...%f"
    cp "git/.gitconfig.local.example" "$HOME/.gitconfig.local"
    print -P "%F{green}✓ ~/.gitconfig.local created%f"
    print -P "%F{yellow}   Edit this file for git user identity and machine-specific settings%f"
else
    print -P "%F{green}✓ ~/.gitconfig.local already exists%f"
fi

# Install packages from Brewfile
echo ""
print -P "%F{blue}📦 Installing packages from Brewfile...%f"
print -P "%F{blue}   This may take several minutes...%f"
brew bundle install --file="Brewfile"
print -P "%F{green}✓ All packages installed%f"

# Link shell completions and cleanup
brew completions link
print -P "%F{blue}🧹 Cleaning up...%f"
brew cleanup
print -P "%F{green}✓ Cleanup complete%f"

# Set Homebrew zsh as default shell
echo ""
print -P "%F{blue}🐚 Setting Homebrew zsh as default shell...%f"

# Homebrew zsh path (Apple Silicon)
HOMEBREW_ZSH="/opt/homebrew/bin/zsh"

if [[ ! -f "$HOMEBREW_ZSH" ]]; then
    print -P "%F{red}✗ Error: Could not find Homebrew zsh at $HOMEBREW_ZSH%f"
    print -P "%F{red}  This dotfiles setup requires Apple Silicon Mac%f"
    exit 1
fi

# Add Homebrew zsh to /etc/shells if not present
if ! grep -q "^$HOMEBREW_ZSH$" /etc/shells; then
    print -P "%F{blue}   Adding $HOMEBREW_ZSH to /etc/shells (requires sudo)...%f"
    echo "$HOMEBREW_ZSH" | sudo tee -a /etc/shells > /dev/null
    print -P "%F{green}✓ Added to /etc/shells%f"
else
    print -P "%F{green}✓ Already in /etc/shells%f"
fi

# Change default shell if not already set
if [[ "$SHELL" != "$HOMEBREW_ZSH" ]]; then
    print -P "%F{blue}   Changing default shell to $HOMEBREW_ZSH (requires password)...%f"
    chsh -s "$HOMEBREW_ZSH"
    print -P "%F{green}✓ Default shell changed to Homebrew zsh%f"
    print -P "%F{yellow}   Note: Restart your terminal for this to take effect%f"
else
    print -P "%F{green}✓ Default shell already set to Homebrew zsh%f"
fi

# Run validation tests
echo ""
print -P "%F{blue}🧪 Running validation tests...%f"
if [ -f "$DOTFILES_DIR/test.sh" ]; then
    if "$DOTFILES_DIR/test.sh"; then
        print -P "%F{green}✓ All validation tests passed%f"
    else
        print -P "%F{yellow}⚠ Some validation tests failed (see above)%f"
        print -P "%F{yellow}  Installation completed but may have issues%f"
    fi
else
    print -P "%F{yellow}⚠ test.sh not found, skipping validation%f"
fi

# Summary
echo ""
print -P "%F{green}✅ Complete automated setup finished!%f"
echo ""
echo "What was installed:"
echo "  ✓ Homebrew package manager"
echo "  ✓ Latest Homebrew zsh (5.9) set as default shell"
echo "  ✓ Oh My Zsh framework"
echo "  ✓ GNU Stow (symlink manager)"
echo "  ✓ All dotfiles (zsh, git, starship, apps)"
echo "  ✓ All packages from Brewfile (bat, eza, delta, fzf, starship, etc.)"
echo ""
echo "Configuration files created:"
echo "  • ~/.zshrc.local      (Machine-specific shell settings)"
echo "  • ~/.gitconfig.local  (Git user identity and private config)"
echo ""
echo "Optional next steps:"
echo "  • Edit ~/.gitconfig.local       (Add your git user.name and user.email)"
echo "  • Run: ./test.sh                (Validate installation)"
echo "  • Run: ./setup/macos_settings   (Configure macOS system settings)"
echo ""
print -P "%F{cyan}📝 Configure Terminal Font for Nerd Font symbols:%f"
echo "  1. Open Terminal → Settings → Profiles → Text"
echo "  2. Click 'Change...' under Font"
echo "  3. Search for 'JetBrainsMono Nerd Font'"
echo "  4. Select it"
echo ""
echo "  For iTerm2: Preferences → Profiles → Text → Font"
echo "  For VS Code: Add to settings.json:"
echo ""
echo "To start using your new setup:"
echo "  exec zsh"
echo ""
