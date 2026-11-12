# shellcheck shell=sh
# Container-only runtime environment. The host does not source this file.
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.local/share/asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export KERL_CONFIGURE_OPTIONS="${KERL_CONFIGURE_OPTIONS:---without-javac --without-wx}"
