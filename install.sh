#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
VIBE_KANBAN_PORT=8042

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

# Setup vibe-kanban as a background service
echo "Setting up vibe-kanban service..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/log"

# Create the service script
cat > "$HOME/.local/bin/vibe-kanban-service.sh" << 'SCRIPT'
#!/bin/bash
# vibe-kanban background service script

VIBE_KANBAN_PORT=${VIBE_KANBAN_PORT:-8042}
VIBE_KANBAN_HOST=${VIBE_KANBAN_HOST:-0.0.0.0}
LOG_FILE="$HOME/.local/log/vibe-kanban.log"
PID_FILE="$HOME/.local/run/vibe-kanban.pid"

mkdir -p "$HOME/.local/run"
mkdir -p "$HOME/.local/log"

start() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "vibe-kanban is already running (PID: $(cat $PID_FILE))"
        return 1
    fi

    echo "Starting vibe-kanban on $VIBE_KANBAN_HOST:$VIBE_KANBAN_PORT..."
    HOST=$VIBE_KANBAN_HOST PORT=$VIBE_KANBAN_PORT nohup vibe-kanban >> "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"
    echo "vibe-kanban started (PID: $!, Port: $VIBE_KANBAN_PORT)"
    echo "Log file: $LOG_FILE"
}

stop() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 $PID 2>/dev/null; then
            echo "Stopping vibe-kanban (PID: $PID)..."
            kill $PID
            rm -f "$PID_FILE"
            echo "vibe-kanban stopped."
        else
            echo "vibe-kanban is not running (stale PID file)."
            rm -f "$PID_FILE"
        fi
    else
        echo "vibe-kanban is not running."
    fi
}

status() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
        echo "vibe-kanban is running (PID: $(cat $PID_FILE), Port: $VIBE_KANBAN_PORT)"
    else
        echo "vibe-kanban is not running."
    fi
}

restart() {
    stop
    sleep 1
    start
}

case "${1:-start}" in
    start)   start ;;
    stop)    stop ;;
    restart) restart ;;
    status)  status ;;
    *)       echo "Usage: $0 {start|stop|restart|status}" ;;
esac
SCRIPT
chmod +x "$HOME/.local/bin/vibe-kanban-service.sh"

# Create convenience aliases script
cat > "$HOME/.local/bin/vk" << 'SCRIPT'
#!/bin/bash
# Convenience wrapper for vibe-kanban-service
exec "$HOME/.local/bin/vibe-kanban-service.sh" "$@"
SCRIPT
chmod +x "$HOME/.local/bin/vk"

# Start vibe-kanban in background (only in workspace environment)
if [ "${IN_WORKSPACE:-0}" = "1" ]; then
    echo "Starting vibe-kanban service..."
    export VIBE_KANBAN_PORT=$VIBE_KANBAN_PORT
    "$HOME/.local/bin/vibe-kanban-service.sh" start
fi

echo "=== Dotfiles installation complete! ==="
echo ""
echo "Post-install steps:"
echo "  1. Run 'gt auth' to authenticate Graphite"
echo "  2. Restart your shell or run 'source ~/.zshrc'"
echo ""
echo "vibe-kanban commands:"
echo "  vk start   - Start vibe-kanban service"
echo "  vk stop    - Stop vibe-kanban service"
echo "  vk status  - Check service status"
echo "  vk restart - Restart service"
echo ""
echo "Access vibe-kanban at:"
echo "  - http://<workspace-name>.workspace.infra.dog:$VIBE_KANBAN_PORT (via Appgate)"
echo "  - http://localhost:$VIBE_KANBAN_PORT (via SSH tunnel)"
