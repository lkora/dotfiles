# Dotfiles for Immutable Fedora Sway

A curated collection of dotfiles and configurations for an immutable Fedora Sway Atomic system, managed with chezmoi.

## 🚀 Quick Start

### Fresh System Installation

```bash
sudo chezmoi init git@github.com:lkora/dotfiles.git
```

That's it! Chezmoi will:
- Clone the repository
- Apply all dotfiles to your home directory
- Set up scripts in `~/.local/bin`

### Updating Existing Install

```bash
# Pull latest changes
chezmoi pull

# Apply changes
chezmoi apply

# Or do both in one command
chezmoi pull && chezmoi apply
```

### Validating Installation

```bash
~/bin/dotfiles/sync status
```

## 📦 What's Included

### System Packages (rpm-ostree)
- Shell: zsh with Oh My ZSH
- Productivity: git, curl, wget, jq, tree, fd, ripgrep, eza, bat, fzf
- Monitoring: btop, htop, fastfetch
- Development: podman, docker-cli

### User Applications (Flatpak)
- Browser: Librewolf
- Media: VLC, OBS Studio
- Creative: Krita, Obsidian
- Communication: Mailspring, Telegram, Signal
- Utilities: Discord

### Containerized Apps (Distrobox)
- VS Code
- Steam

### Configuration Files
- **ZSH**: Oh My ZSH with Catppuccin Mocha theme, plugins, aliases
- **LazyVim**: Official LazyVim with modular overrides
- **Fonts**: System-wide JetBrainsMono Nerd Font
- **Wallpaper**: Moon photo from Unsplash

## 🎨 Personalization

### Themes
- **Font**: JetBrainsMono Nerd Font (system-wide)
- **ZSH Theme**: Catppuccin Mocha (default)
- **Selectable**: Kangawa (change in `~/.config/zsh/.zshrc`)

### Wallpaper
- **Source**: Unsplash moon photo
- **Path**: `~/.wallpapers/moon-unsplash.jpg`

## 🔧 Services

### Dotfiles Sync
Chezmoi keeps your dotfiles in sync automatically:
```bash
chezmoi status
chezmoi apply --auto
```

### LazyVim Config
Automatically fetched and merged on bootstrap:
```bash
# Apply LazyVim config
~/bin/dotfiles/sync
```

## 🧪 Testing

```bash
# Check sync status
~/bin/dotfiles/sync status

# Apply all changes
chezmoi apply

# Revert last apply
chezmoi revert
```

## 📂 Repository Structure

```
dotfiles/
├── .chezmoi/              # Chezmoi configuration
│   ├── source.yaml        # Source file mappings
│   └── targets.yaml       # Target deployment paths
├── boot/
│   └── bootstrap.sh       # One-shot bootstrap script
├── configs/               # Legacy configs (for reference)
├── scripts/               # Utility scripts
├── apps/                  # Application setup
├── services/              # Systemd services
├── tests/                 # Automated tests
└── README.md              # This file
```

## 🔄 Update Workflow

### For Developers
```bash
# Pull latest changes
chezmoi pull

# Test locally
chezmoi apply --dry-run

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

## 📄 License

MIT License - See LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test with `chezmoi apply --dry-run`
4. Submit a pull request

## 🆘 Troubleshooting

### Chezmoi not working
```bash
# Check status
chezmoi status

# List pending changes
chezmoi diff

# Apply with verbose output
chezmoi apply -v
```

### Scripts not found
```bash
# Add to PATH in .zshrc
export PATH="$HOME/.local/bin:$PATH"

# Reload
source ~/.zshrc
```
