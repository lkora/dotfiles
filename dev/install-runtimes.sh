#!/usr/bin/env bash
set -euo pipefail
command -v asdf >/dev/null
# shellcheck source=dev/profile.sh
source /etc/profile.d/dotfiles-dev.sh
for plugin in erlang elixir nodejs; do
    if ! asdf plugin list | grep -Fxq "$plugin"; then
        asdf plugin add "$plugin" "https://github.com/asdf-vm/asdf-$plugin.git"
    fi
done
if [[ ! -f .tool-versions ]]; then
    echo "Add a .tool-versions file to this project, then run install-dev-runtimes again."
    exit 0
fi
asdf install
