# Personal Linux environment

Chezmoi manages personal files. Separate commands install applications and create development containers.
The current app installer targets Linux with Flatpak. The host baseline comes from Fedora 45 Sway Atomic.

See [the repository boundary](https://github.com/lkora/sway-my-way/blob/main/docs/architecture.md) for ownership and setup order.

## Apply configuration

Run these commands as your normal user:

```sh
chezmoi init https://github.com/lkora/dotfiles.git
chezmoi diff
chezmoi apply
```

Initialization asks whether to apply the personal Sway desktop.
Shared Zsh and Neovim configuration works without the desktop configuration.
Applying configuration does not install applications, create containers, or enable services.

For this local checkout:

```sh
chezmoi --source "$PWD" init
chezmoi --source "$PWD" diff
chezmoi --source "$PWD" apply
```

## Install applications

From the repository directory:

```sh
bash scripts/install-apps --dry-run
bash scripts/install-apps
```

The Flatpak list contains LibreWolf, VLC, OBS, Krita, Obsidian, Mailspring, Telegram, Signal, Discord, and Steam.
Flatpak manages its runtimes and updates.
VS Code uses Microsoft's native Linux archive in the user data directory.
The installer checks its SHA-256 checksum and creates a desktop launcher.
This installation supports host files and container integrations without Flatpak sandbox configuration.

Install or update one group:

```sh
bash scripts/install-apps flatpak
bash scripts/install-apps vscode
flatpak update --user
```

VS Code requires GTK 3, NSS, libsecret, libxkbfile, ALSA, and GBM libraries.
The companion image supplies these libraries.

## Development

```sh
bash scripts/setup-dev
dev
```

The development image contains asdf, uv, GCC, Clang, GDB, Make, CMake, Neovim, and runtime build dependencies.
Distrobox shares your home directory, including this configuration.
Language runtimes remain in user storage. The host does not add their shims unless asdf is installed there.

Use Neovim normally for host files:

```sh
nvim notes.md
dev nvim .
```

Neovim installs LazyVim plugins on its first launch.
The host supports general editing. The development box supplies compilers and language tools for development.
Plugin versions remain in Neovim's generated `lazy-lock.json`.

See [the development guide](docs/development.md) for language versions and VS Code Dev Containers.

## User services

On the Fedora image, enable Syncthing for your user:

```sh
systemctl --user enable --now syncthing.service
```

Syncthing identities and Twingate credentials remain outside this repository.
Chezmoi updates remain manual:

```sh
chezmoi git -- pull --ff-only
chezmoi diff
chezmoi apply
```

## Add or change something

| Change | Location |
|---|---|
| Add a Flatpak app | `apps/linux/flatpak.txt` |
| Add a development package | `dev/Containerfile` |
| Add an asdf plugin | `dev/install-runtimes.sh` |
| Select language versions | Each project's `.tool-versions` |
| Change shell preferences | `home/dot_zshrc` |
| Add Neovim plugins | `home/dot_config/nvim/lua/plugins/` |
| Change desktop preferences | `home/dot_config/{sway,waybar,foot,mako}/` |
| Add a platform installer | A new directory under `apps/` and a script handler |

For a new personal file, use `chezmoi add PATH`.
The root `.chezmoiroot` selects `home/`. Documentation and installer scripts never become home-directory targets.

Machine-only shell changes belong in `~/.config/zsh/local.zsh`.
Machine-only Sway changes belong in `~/.config/sway/local.d/*.conf`.
The Sway profile includes Fedora's system configuration and overrides its bar through the layered include mechanism.
For a wallpaper, add an image and a local `output * bg PATH fill` directive.
The initial desktop uses a solid Catppuccin background and the packaged JetBrains Mono font.

To change the desktop selection, run `chezmoi edit-config` and change `data.swayDesktop`.
Disabling a selection stops management of those files. It does not delete previously deployed files.

Linux is the only implemented platform. Configuration selection and app installation remain separate extension points for future platforms.
Other Linux distributions need the host dependencies installed separately.

## Checks

```sh
shellcheck scripts/* dev/*.sh tests/*.sh home/dot_local/bin/executable_dev
python3 tests/check.py
```

The checks apply configuration twice in a temporary directory and preserve unmanaged files.
They cover desktop selection, stored initialization answers, shell and Lua syntax, and app previews.
CI also builds the development image and runs its tool commands.
The Fedora desktop job uses the real Sway and Foot configuration parsers.

The Neovim bootstrap follows [LazyVim's starter](https://github.com/LazyVim/starter).
Package IDs follow [Flathub](https://flathub.org/).
The runtime workflow follows [asdf](https://asdf-vm.com/manage/versions.html) and [uv](https://docs.astral.sh/uv/guides/projects/).
