# Chezmoi Setup Guide

This document explains how to use chezmoi with the dotfiles repository.

## Architecture

Chezmoi provides a clean, git-backed approach to dotfile management:

```
Repository (git)
    ↓ chezmoi init
chezmoi/ (versioned state)
    ↓ chezmoi apply
~/.dotfiles, ~/.config, ~/.local/bin (deployed)
```

## Installation

### 1. Install chezmoi

```bash
# macOS/Linux
cargo install chezmoi

# Or via Homebrew
brew install chezmoi
```

### 2. Initialize the repository

```bash
# Clone and apply in one step
sudo chezmoi init git@github.com:lkora/dotfiles.git

# Or clone first, then apply
git clone git@github.com:lkora/dotfiles.git
cd dotfiles
sudo chezmoi apply
```

## Usage

### Check Status

```bash
# See pending changes
chezmoi status

# See what will change
chezmoi diff
```

### Apply Changes

```bash
# Apply all changes
chezmoi apply

# Apply with dry-run (preview)
chezmoi apply --dry-run
```

### Pull/Push

```bash
# Pull latest changes from remote
chezmoi pull

# Push local changes to remote
chezmoi push
```

### Revert

```bash
# Revert the last apply
chezmoi revert

# Revert to a specific commit
chezmoi revert <commit-hash>
```

## File Structure

### Source Files (chezmoi/)
- `source.yaml` - Maps source files to targets
- `targets.yaml` - Defines deployment paths
- Files in `dotfiles/` subdirectory - Actual dotfiles to deploy

### Deployed Files (~/)
- `~/.dotfiles/.zshrc` - ZSH configuration
- `~/.config/zsh/.zshrc` - ZSH configuration (alternative)
- `~/.config/nvim/` - Nvim configuration
- `~/.local/bin/sync` - Dotfiles sync utility
- `~/.local/bin/apply` - Config application script

## Git Workflow

### For Contributors

```bash
# Pull latest changes
chezmoi pull

# Test locally
chezmoi apply --dry-run

# Review changes
chezmoi diff

# Commit
git commit -m "feat: add new configuration"
```

### For Users

```bash
# Update dotfiles
chezmoi pull

# Apply changes
chezmoi apply

# Revert if needed
chezmoi revert
```

## Security Notes

- Chezmoi stores passwords/keyfiles separately from source files
- Use `chezmoi init --password-file ~/.config/chezmoi/chezmoi-password` for password-protected files
- All operations are idempotent and version-controlled

## Troubleshooting

### "chezmoi: command not found"
```bash
# Add to PATH
export PATH="$HOME/.cargo/bin:$PATH"
```

### "source.yaml not found"
```bash
# Check file exists
ls -la ~/.chezmoi/source.yaml
```

### Apply fails with permission errors
```bash
# Check home directory permissions
ls -ld ~
# Should be: drwx------ user user
```

## Migration from Other Tools

### From rsync/scripts
- Replace manual sync scripts with `chezmoi apply`
- Use `chezmoi diff` to review changes before applying
- `chezmoi revert` provides instant rollback

### From dotfiles/git clone
- Use `chezmoi init` instead of `git clone`
- `chezmoi pull` replaces `git pull`
- `chezmoi apply` handles deployment automatically

## Best Practices

1. **Always use `--dry-run`** when testing changes locally
2. **Review diffs** before applying: `chezmoi diff`
3. **Commit meaningful messages** that describe the change
4. **Use branches** for experimental configurations
5. **Keep .chezmoi/** in git (it's versioned state, not secrets)
