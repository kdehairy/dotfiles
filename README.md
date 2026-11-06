# dotfiles

Personal dotfiles, managed with [`dotter`](https://github.com/SuperCuber/dotter).

## Setup

1. Install `dotter`:
   ```sh
   pacman -S dotter        # Arch (if packaged/AUR, e.g. `paru -S dotter`)
   # or
   cargo install dotter
   ```
2. Clone this repo where you want it to live (`dotter` deploys *from* the repo, it doesn't need to be in a fixed location):
   ```sh
   git clone <this-repo> ~/.dotfiles
   cd ~/.dotfiles
   ```
3. Create `.dotter/local.toml` (gitignored — it's machine-specific) picking which packages to deploy on this machine, e.g.:
   ```toml
   packages = ["sway", "zsh", "tmux", "foot", "nvim", "os", "kickoff", "waybar", "gnupg", "ssh", "opencode", "git"]
   ```
   Only include packages relevant to this machine (e.g. skip `sway`/`waybar`/`kickoff` on a non-Sway box), and set any variables the enabled packages require (see [How it works](#how-it-works)).
4. Deploy:
   ```sh
   dotter deploy --dry-run   # preview
   dotter deploy             # symlink/render files into $HOME
   ```

To pull in later changes, `git pull` then `dotter deploy` again. To remove everything this repo deployed, run `dotter undeploy`.

## How it works

`.dotter/global.toml` defines every package: its `files` map (`"repo/path" = "~/target/path"`), its
`variables`, and any `depends` on other packages (pulling one package in pulls its dependencies).
`.dotter/local.toml` is machine-local and gitignored: it lists the packages this machine actually
deploys and can override any variable.

A deployed file is either a **symlink** or a **rendered copy**, and that difference decides whether
an edit is live immediately:

| Arrives as            | Which                                                                                              |
|-----------------------|---------------------------------------------------------------------------------------------------|
| Symlink               | Anything without template tags — `sway/config`, `waybar/*`, `git/*`, `opencode/opencode.json`, `tmux`, `gnupg`, `kickoff`, `ssh/gpg_config`, and **each file inside a mapped directory** (`nvim/lua/` is 18 symlinks into the repo). Editing the repo file is live at once, though the app may need to reload it |
| Rendered copy         | The four files carrying template tags: `zsh/.zshrc`, `ssh/config`, `foot/foot.ini`, `nvim/init.lua`. These stay stale until you run `dotter deploy` |

Variables are written into the template **unqualified** (`{{#if isArch}}`, not `{{#if os.isArch}}`),
even though they are declared per package. A template can also branch on which packages this
machine enables: `dotter.packages.sway` guards the sway autostart and `XDG_CURRENT_DESKTOP` in
`zsh/.zshrc`, and `dotter.packages.gnupg` the `Include ~/.ssh/gpg_config` line in `ssh/config`.
What exists today:

| Variable             | Default | Used by            | Meaning                                                       |
|----------------------|---------|--------------------|---------------------------------------------------------------|
| `os.isArch`          | `true`  | `zsh`              | Arch-only shell bits: pkgfile's command-not-found hook         |
| `zsh.usingZimComp`   | `true`  | `zsh`              | Skip the `compinstall`/`compinit` block; completion comes from elsewhere |
| `zsh.importSecrets`  | `true`  | `zsh`              | Define `rbwenv`, which exports notes from the Bitwarden `env` folder |
| `foot.versionPre1_17`| `false` | `foot`             | Set `true` on foot older than 1.17 to omit the `unicode-input` key |
| `nvim.nvim-go`       | `false` | `nvim`             | Opt in to the Go toolchain config                              |
| `nvim.nvim-tf`       | `false` | `nvim`             | Opt in to the Terraform toolchain config                       |

### Keeping machine-local files out of the repo

Two hooks take per-machine extras, so they never need a commit: `~/.zshrc.d/*.zsh` is sourced by
`.zshrc` (the extension is required — anything else is skipped silently), and `~/.gitconfig`
includes `~/.gitconfig.d/local.config` for identity and other box-specific git settings.

## Packages

| Package    | Deploys                                                          |
|------------|-------------------------------------------------------------------|
| `sway`     | Sway (Wayland compositor) config + background                    |
| `waybar`   | Status bar config, style, and CPU-temperature script (depends on `sway`) |
| `kickoff`  | App launcher (depends on `sway`)                                  |
| `foot`     | Terminal emulator config + theme                                  |
| `tmux`     | tmux config                                                       |
| `nvim`     | Neovim config (lazy.nvim, LSP/DAP setup, per-language configs)     |
| `zsh`      | Shell config: `.zshrc` (depends on `os`)                            |
| `git`      | Global gitconfig + global excludes + local override include       |
| `gnupg`    | GPG agent config                                                  |
| `ssh`      | SSH client config                                                 |
| `opencode` | `opencode` CLI config: local llama.cpp provider and MCP servers    |
| `os`       | No files; OS-detection variables (`isArch`) consumed by other packages |
