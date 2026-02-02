# askardog's dotfiles

Personal dotfiles for Datadog Workspaces.

## What's Included

- **Graphite CLI** - For stacked PR workflows
- **vibe-kanban** - Task management (auto-starts as background service)
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

## vibe-kanban Service

vibe-kanban auto-starts on workspace creation and listens on port **8042**.

### Commands

```bash
vk start    # Start vibe-kanban
vk stop     # Stop vibe-kanban
vk status   # Check if running
vk restart  # Restart service
vk-logs     # Tail the log file
```

### Accessing from Local Machine

**Option 1: Direct via Appgate (recommended)**

Open in your browser:
```
http://<workspace-name>.workspace.infra.dog:8042
```

**Option 2: SSH port forwarding**

```bash
ssh -L 8042:localhost:8042 workspace-<name>
```
Then open http://localhost:8042 in your browser.

## Files

| File | Purpose |
|------|---------|
| `install.sh` | Main installation script (runs automatically) |
| `.zshrc` | Shell configuration with aliases |
| `.gitconfig` | Git preferences |
| `.claude/CLAUDE.md` | Claude Code personal instructions |
