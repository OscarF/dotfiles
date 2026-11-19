#!/usr/bin/env zsh

# Test suite for dotfiles installation
# Validates that all components are correctly installed and configured

set -e

FAILED=0
PASSED=0

print_test() {
    print -n "  Testing: $1... "
}

pass() {
    print -P "%F{green}✓%f"
    ((PASSED++)) || true
}

fail() {
    print -P "%F{red}✗%f"
    if [ -n "$1" ]; then
        print -P "    %F{red}Error: $1%f"
    fi
    ((FAILED++)) || true
}

echo "🧪 Running dotfiles validation tests"
echo "======================================"
echo ""

# ==============================================================================
# Test 1: Symlinks
# ==============================================================================
echo "1. Checking symlinks..."

links=(
    .zshrc
    .zshenv
    .zprofile
    .gitconfig
    .config/git/ignore
    .config/starship.toml
    .config/linearmouse/linearmouse.json
)
for link in "${links[@]}"; do
    print_test "~/$link exists and is a symlink"
    if [ -L "$HOME/$link" ] && [ -e "$HOME/$link" ]; then
        pass
    else
        fail "~/$link is missing or not a symlink (re-run ./install.sh)"
    fi
done

print_test "App settings watcher is loaded"
if launchctl print "gui/$(id -u)/local.dotfiles.app-settings" &>/dev/null; then
    pass
else
    fail "LaunchAgent not loaded (run: setup/app_settings install-watcher)"
fi

echo ""

# ==============================================================================
# Test 2: Required Tools
# ==============================================================================
echo "2. Checking required tools..."

print_test "Homebrew is installed"
if command -v brew &>/dev/null; then
    pass
else
    fail "brew not found in PATH"
fi

print_test "GNU Stow is installed"
if command -v stow &>/dev/null; then
    pass
else
    fail "stow not found in PATH"
fi

print_test "Starship is installed"
if command -v starship &>/dev/null; then
    pass
else
    fail "starship not found in PATH"
fi

print_test "Git is installed"
if command -v git &>/dev/null; then
    pass
else
    fail "git not found in PATH"
fi

print_test "Git delta is installed"
if command -v delta &>/dev/null; then
    pass
else
    fail "delta not found in PATH"
fi

echo ""

# ==============================================================================
# Test 3: Configuration Loading
# ==============================================================================
echo "3. Checking configuration files..."

print_test "~/.zshrc syntax is valid"
if zsh -n "$HOME/.zshrc" 2>/dev/null; then
    pass
else
    fail "~/.zshrc has syntax errors"
fi

print_test "Oh My Zsh is installed"
if [ -d "$HOME/.oh-my-zsh" ]; then
    pass
else
    fail "~/.oh-my-zsh directory not found"
fi

print_test "zsh-autosuggestions is available"
AUTOSUGGESTIONS_PATH="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [ -f "$AUTOSUGGESTIONS_PATH" ]; then
    pass
else
    fail "zsh-autosuggestions not found at $AUTOSUGGESTIONS_PATH"
fi

print_test "zsh-syntax-highlighting is available"
HIGHLIGHTING_PATH="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ -f "$HIGHLIGHTING_PATH" ]; then
    pass
else
    fail "zsh-syntax-highlighting not found at $HIGHLIGHTING_PATH"
fi

print_test "Homebrew share dir is not group-writable (OMZ compaudit)"
if [ -z "$(find "$(brew --prefix)/share" -maxdepth 0 -perm -g+w)" ]; then
    pass
else
    fail "run: chmod go-w \"\$(brew --prefix)/share\""
fi

echo ""

# ==============================================================================
# Test 4: CLI Tools
# ==============================================================================
echo "4. Checking CLI tools from the Brewfile..."

print_test "eza (used by the ls aliases) is installed"
if command -v eza &>/dev/null; then
    pass
else
    fail "eza not found (run: brew bundle install --file=Brewfile)"
fi

print_test "bat (modern cat) is installed"
if command -v bat &>/dev/null; then
    pass
else
    fail "bat not found (run: brew bundle install --file=Brewfile)"
fi

print_test "fzf (fuzzy finder) is installed"
if command -v fzf &>/dev/null; then
    pass
else
    fail "fzf not found (run: brew bundle install --file=Brewfile)"
fi

print_test "ripgrep is installed"
if command -v rg &>/dev/null; then
    pass
else
    fail "rg not found (run: brew bundle install --file=Brewfile)"
fi

echo ""

# ==============================================================================
# Summary
# ==============================================================================
echo "======================================"
print -P "Results: %F{green}${PASSED} passed%f, %F{red}${FAILED} failed%f"
echo ""

if [ $FAILED -eq 0 ]; then
    print -P "%F{green}✅ All tests passed!%f"
    exit 0
else
    print -P "%F{red}❌ Some tests failed. Please review the output above.%f"
    exit 1
fi
