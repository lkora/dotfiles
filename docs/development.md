# Development

## Distrobox

Create the development image and box:

```sh
bash scripts/setup-dev
dev
```

The box uses Podman. Docker remains available on the host for VS Code Dev Containers and Compose projects.
The two engines have separate image and container stores.
Rebuilding the image does not replace an existing box.

To replace the box, first preserve any changes outside your shared home directory.
Then run:

```sh
distrobox stop dev
distrobox rm dev
bash scripts/setup-dev
```

## Erlang, Elixir, and Node.js

Inside a project in the development box, add the plugins:

```sh
install-dev-runtimes
```

Choose versions from the plugin lists:

```sh
asdf list all erlang
asdf list all elixir
asdf list all nodejs
```

Write the selected versions with `asdf set TOOL VERSION`.
This command creates or changes the project's `.tool-versions` file.
Select an Elixir build that matches your selected Erlang/OTP version.
Then install the selected versions:

```sh
install-dev-runtimes
mix local.hex
mix local.rebar
```

Commit `.tool-versions` with the project.
The initial Erlang build disables Java and wxWidgets.
For those features, add the required packages and change `KERL_CONFIGURE_OPTIONS` in `dev/profile.sh`.
Additional asdf plugins use the same script and project version file.

## Python

Inside a Python project:

```sh
uv init
uv add requests
uv run python
```

For an existing project, run `uv sync`.
For a standalone environment, run `uv venv`.
Commit `pyproject.toml`, `uv.lock`, and the project's Python version file.
Keep generated environments outside Git.

## C and C++

The image includes GCC, Clang, Make, CMake, Ninja, and GDB.
Project build files select the compiler and build flags.
For additional libraries, add their development packages to `dev/Containerfile`.

## VS Code

Run `code .` on the host for normal files and projects.
Install the Dev Containers extension:

```sh
code --install-extension ms-vscode-remote.remote-containers
```

The Fedora image enables Docker Engine through Fedora's Moby package.
For normal-user Docker access, run this command on the target PC:

```sh
sudo usermod -aG docker "$USER"
```

The docker group grants administrative access to the host.
Log out and log in before you use the new group membership.

The `dev/` directory includes a Dev Container definition for the same toolchain.
Open that directory in VS Code and select **Dev Containers: Reopen in Container**.
Its non-root account is `developer`.
Run `install-dev-runtimes` inside a project to install its selected runtimes.

For another project, copy the `dev/` files into that project or adapt the Dockerfile path and build context.
Each project owns its Dev Container definition.
Docker Dev Containers and the shared Distrobox are independent environments.
Neither workflow forces ordinary host files into a container.
