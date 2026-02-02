# Personal Development Preferences

## Test-Driven Development (TDD)

Follow TDD workflow for all implementation tasks:

1. **Write tests first** - Cover all expected behavior of the API, not implementation details
2. **Wait for approval** - After writing tests, stop and wait for user approval before proceeding. This confirms the expected behavior aligns with what the user has in mind
3. **Implement after approval** - Only proceed with implementation once the user approves the tests
4. **Ensure tests pass** - Run tests and verify they pass after implementation
5. **Communicate test changes** - If tests need to be modified after initial approval, inform the user first and explain why the changes are necessary

## Mocking vs Real Implementation

1. **Prefer real implementations** - Use actual code whenever possible
2. **Don't mock static utilities** - Static utility classes should use the actual implementation
3. **Only mock external dependencies** that are:
   - Slow (network latency)
   - Flaky (unreliable)
   - Have side effects (HTTP APIs, databases, file system)
4. **Mocking is the exception, not the rule**

## Git Worktrees

This repository uses git worktrees to enable working on multiple projects/branches in parallel:

1. **Assume worktree setup** - The current working directory may be a git worktree, not the main repository
2. **Use relative paths** - Avoid assumptions about the repository root location
3. **Check worktree context** - Use `git worktree list` to understand the current worktree layout if needed
4. **Respect worktree boundaries** - Each worktree has its own working directory and index; changes in one worktree don't affect others

## Jira Integration

Use the Atlassian MCP (Model Context Protocol) server to communicate with Jira:

1. **Use MCP tools for Jira** - Prefer Atlassian MCP tools over manual API calls for Jira operations
2. **Common operations** - Use MCP for creating issues, updating tickets, adding comments, and querying Jira
3. **Link commits to issues** - When working on a Jira ticket, reference the issue key in commits

## Graphite for Stacked PRs

Use Graphite (`gt`) for managing stacked pull requests:

1. **Use `gt` commands** - Prefer Graphite CLI over raw git for branch/PR management when stacking
2. **Common commands**:
   - `gt create` - Create a new branch in the stack
   - `gt submit` - Submit the current stack as PRs
   - `gt sync` - Sync the stack with the remote
   - `gt restack` - Rebase the stack after changes
3. **Keep commits atomic** - Each branch in the stack should represent a single logical change
4. **Update dependent branches** - After rebasing or amending, use `gt restack` to update the entire stack
