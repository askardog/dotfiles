#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Installing dotfiles for askardog ==="

# Symlink .zshrc
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    echo "Linking .zshrc..."
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

# Symlink .gitconfig
if [ -f "$DOTFILES_DIR/.gitconfig" ]; then
    echo "Linking .gitconfig..."
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
fi

# Setup Claude configuration
echo "Setting up Claude configuration..."
mkdir -p "$HOME/.claude"
if [ -f "$DOTFILES_DIR/.claude/CLAUDE.md" ]; then
    ln -sf "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
fi

# Install Graphite CLI
if ! command -v gt &> /dev/null; then
    echo "Installing Graphite CLI..."
    npm install -g @withgraphite/graphite-cli
    echo "Graphite installed! Run 'gt auth' to authenticate."
else
    echo "Graphite already installed."
fi

# Install vibe-kanban
if ! command -v vibe-kanban &> /dev/null; then
    echo "Installing vibe-kanban..."
    npm install -g vibe-kanban
else
    echo "vibe-kanban already installed."
fi

echo "=== Dotfiles installation complete! ==="
echo ""
echo "Post-install steps:"
echo "  1. Run 'gt auth' to authenticate Graphite"
echo "  2. Restart your shell or run 'source ~/.zshrc'"
