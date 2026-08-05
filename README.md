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

   [variables]
   ai_model = "GLM-4.7-Flash-UD-Q4_K_XL.gguf"
   ```
   Only include packages relevant to this machine (e.g. skip `sway`/`waybar`/`kickoff` on a non-Sway box), and set any variables the enabled packages require (see [How it works](#how-it-works)).
4. Deploy:
   ```sh
   dotter deploy --dry-run   # preview
   dotter deploy             # symlink/render files into $HOME
   ```

To pull in later changes, `git pull` then `dotter deploy` again. To remove everything this repo deployed, run `dotter undeploy`.

## Packages

| Package  | Deploys                                                        |
|----------|-----------------------------------------------------------------|
| `sway`   | Sway (Wayland compositor) config + background                  |
| `waybar` | Status bar (depends on `sway`)                                  |
| `kickoff`| App launcher (depends on `sway`)                                 |
| `foot`   | Terminal emulator config + theme                                 |
| `tmux`   | tmux config                                                       |
| `nvim`   | Neovim config (lazy.nvim, LSP/DAP setup, per-language configs)   |
| `zsh`    | Shell config (depends on `os`)                                   |
| `zim`    | Zsh plugin manager config (depends on `zsh`)                     |
| `git`    | Global gitconfig + global excludes + local override include      |
| `gnupg`  | GPG agent config                                                  |
| `ssh`    | SSH client config                                                 |
| `opencode`| `opencode` CLI config: providers, MCP servers, custom agents     |
| `os`     | OS-detection variables (e.g. `isArch`) consumed by other packages |
