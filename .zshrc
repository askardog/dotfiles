# =============================================================================
# askardog's zshrc - Workspace Configuration
# =============================================================================

# Path additions
export PATH="$HOME/.fzf/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Graphite CLI completions (if available)
if command -v gt &> /dev/null; then
    eval "$(gt completion zsh 2>/dev/null || true)"
fi

# Auto-authenticate gh and gt on first shell (workspace only)
if [ "${IN_WORKSPACE:-0}" = "1" ]; then
    SECRETS_DIR="/run/user/$(id -u)/secrets"

    # gh auth (silent, only if not authenticated)
    if command -v gh &> /dev/null && ! gh auth status &>/dev/null 2>&1; then
        if [ -f "$SECRETS_DIR/GH_TOKEN" ]; then
            cat "$SECRETS_DIR/GH_TOKEN" | gh auth login --with-token 2>/dev/null
        fi
    fi

    # gt auth (silent, only if not authenticated)
    if command -v gt &> /dev/null && ! gt auth status &>/dev/null 2>&1; then
        if [ -f "$SECRETS_DIR/GT_TOKEN" ]; then
            gt auth --token "$(cat $SECRETS_DIR/GT_TOKEN)" &>/dev/null
        fi
    fi
fi

# Useful aliases
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline -20'
alias gco='git checkout'
alias gcb='git checkout -b'

# Graphite aliases
alias gts='gt status'
alias gtc='gt create'
alias gtsub='gt submit'
alias gtsync='gt sync'
alias gtrs='gt restack'

# Bazel/bzl aliases (for dd-source)
alias bzlb='bzl build'
alias bzlt='bzl test'
alias bzlr='bzl run'

# vibe-kanban
export VIBE_KANBAN_PORT=8042
alias vk='$HOME/.local/bin/vibe-kanban-service.sh'
alias vk-logs='tail -f $HOME/.local/log/vibe-kanban.log'

# fzf configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview 'head -100 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Editor
export EDITOR='vim'

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Enable colors
autoload -U colors && colors

# Prompt (simple, informative)
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%~%f$ '

# Load local overrides if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
