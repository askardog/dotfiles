# askardog's dotfiles

Personal dotfiles for Datadog Workspaces.

## What's Included

- **Graphite CLI** - For stacked PR workflows
- **vibe-kanban** - Task management
- **Claude Code config** - Personal CLAUDE.md preferences
- **Shell config** - zsh with useful aliases
- **Git config** - Sensible defaults

## Usage with Datadog Workspaces

```bash
workspaces create <name> \
  --repo dd-source \
  --region us-east-1 \
  --dotfiles https://github.com/askardog/dotfiles \
  --shell zsh
```

## Post-Installation

After workspace creation, authenticate Graphite:

```bash
gt auth
```

## Files

| File | Purpose |
|------|---------|
| `install.sh` | Main installation script (runs automatically) |
| `.zshrc` | Shell configuration with aliases |
| `.gitconfig` | Git preferences |
| `.claude/CLAUDE.md` | Claude Code personal instructions |
