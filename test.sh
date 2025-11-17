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

print_test "~/.zshrc exists and is a symlink"
if [ -L "$HOME/.zshrc" ] && [ -e "$HOME/.zshrc" ]; then
    pass
else
    fail "~/.zshrc is missing or not a symlink"
fi

print_test "~/.zshenv exists and is a symlink"
if [ -L "$HOME/.zshenv" ] && [ -e "$HOME/.zshenv" ]; then
    pass
else
    fail "~/.zshenv is missing or not a symlink"
fi

print_test "~/.zsh_git_aliases exists and is a symlink"
if [ -L "$HOME/.zsh_git_aliases" ] && [ -e "$HOME/.zsh_git_aliases" ]; then
    pass
else
    fail "~/.zsh_git_aliases is missing or not a symlink"
fi

print_test "~/.gitconfig exists and is a symlink"
if [ -L "$HOME/.gitconfig" ] && [ -e "$HOME/.gitconfig" ]; then
    pass
else
    fail "~/.gitconfig is missing or not a symlink"
fi

print_test "~/.config/starship.toml exists and is a symlink"
if [ -L "$HOME/.config/starship.toml" ] && [ -e "$HOME/.config/starship.toml" ]; then
    pass
else
    fail "~/.config/starship.toml is missing or not a symlink"
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

echo ""

# ==============================================================================
# Test 4: Modern CLI Tools (Optional)
# ==============================================================================
echo "4. Checking modern CLI tools..."

print_test "eza (modern ls) is installed"
if command -v eza &>/dev/null; then
    pass
else
    fail "eza not found (optional)"
fi

print_test "bat (modern cat) is installed"
if command -v bat &>/dev/null; then
    pass
else
    fail "bat not found (optional)"
fi

print_test "fzf (fuzzy finder) is installed"
if command -v fzf &>/dev/null; then
    pass
else
    fail "fzf not found (optional)"
fi

print_test "ripgrep is installed"
if command -v rg &>/dev/null; then
    pass
else
    fail "rg not found (optional)"
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
