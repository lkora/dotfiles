#!/usr/bin/env python3
"""Exercise real chezmoi deployment without changing the user's home."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[1]

def run(*args, **kwargs):
    return subprocess.run(args, check=True, text=True, capture_output=True, **kwargs).stdout

with tempfile.TemporaryDirectory(prefix="dotfiles-check-") as temporary:
    root = Path(temporary)
    for desktop in (True, False):
        case = root / str(desktop)
        destination = case / "home"
        destination.mkdir(parents=True)
        config = case / "chezmoi.toml"
        config.write_text("[data]\nswayDesktop = " + str(desktop).lower() + "\n")
        command = [
            "chezmoi", "--config", str(config), "--source", str(REPO),
            "--destination", str(destination), "--cache", str(case / "cache"),
            "--persistent-state", str(case / "state.boltdb"),
            "--override-data", json.dumps({"chezmoi": {"os": "linux"}}),
            "--no-tty",
        ]
        local = destination / ".config/nvim/local.lua"
        local.parent.mkdir(parents=True)
        local.write_text("-- Keep this unmanaged file.\n")
        run(*command, "apply")
        run(*command, "apply")
        assert run(*command, "status").strip() == "", "Second apply changed the destination"
        assert local.read_text() == "-- Keep this unmanaged file.\n"
        assert (destination / ".zshrc").is_file()
        assert (destination / ".local/bin/dev").stat().st_mode & 0o111
        assert (destination / ".config/sway/config").exists() == desktop
        assert (destination / ".config/foot/foot.ini").exists() == desktop
        assert not (destination / "README.md").exists()
        assert not (destination / "scripts").exists()
        assert not (destination / "apps").exists()
        # Initialization reuses stored data without asking again.
        run(*command, "init")
        # zsh completion, history, and local includes use only temporary paths.
        env = dict(os.environ, ZDOTDIR=str(case), XDG_CONFIG_HOME=str(destination / ".config"),
                   XDG_STATE_HOME=str(case / "state"))
        run("zsh", "-dfc", 'source "$1"; builtin cd "$2"; cd ..',
            "check", str(destination / ".zshrc"), str(destination), env=env)

    # Unsupported systems do not receive Linux-only configuration.
    output = run(*command[:-3], "--override-data",
                 '{"chezmoi":{"os":"darwin"}}', "--no-tty", "managed")
    assert output.strip() == "", output

    env = dict(os.environ, XDG_CONFIG_HOME=str(root / "config"),
               XDG_DATA_HOME=str(root / "data"), XDG_STATE_HOME=str(root / "state"),
               XDG_CACHE_HOME=str(root / "cache"))
    if shutil.which("nvim"):
        pattern = json.dumps(str(REPO / "home/dot_config/nvim/**/*.lua"))
        run("nvim", "--headless", "-u", "NONE", "-i", "NONE",
            "-c", "lua for _,p in ipairs(vim.fn.glob(" + pattern +
            ",false,true)) do local f,e=loadfile(p); assert(f,e) end", "-c", "qa", env=env)

    # A preview emits commands without invoking Flatpak or downloading VS Code.
    fake_bin = root / "bin"
    fake_bin.mkdir()
    uname = fake_bin / "uname"
    uname.write_text("#!/bin/sh\necho Linux\n")
    uname.chmod(0o755)
    env["PATH"] = str(fake_bin) + os.pathsep + os.environ["PATH"]
    if os.geteuid() != 0:
        plan = run("bash", str(REPO / "scripts/install-apps"), "--dry-run", env=env)
        assert "--user" in plan and "com.valvesoftware.Steam" in plan
        assert "com.discordapp.Discord" in plan and "native VS Code" in plan
print("Passed: isolated apply, repeat apply, desktop selection, init, local files, syntax, app preview.")
