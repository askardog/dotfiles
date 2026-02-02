# =============================================================================
# askardog's zshrc - Workspace Configuration
# =============================================================================

# Path additions
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Graphite CLI completions (if available)
if command -v gt &> /dev/null; then
    eval "$(gt completion zsh 2>/dev/null || true)"
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
