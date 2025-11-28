# AGENTS.md

> Context file for AI agents working with this dotfiles repository

## Repository Overview

This is a **minimal, no-nonsense dotfiles setup** for macOS that follows these principles:
1. Symlink config files to the right places
2. Use `brew bundle` to install applications
3. Keep it simple - no complex frameworks

**Install location**: `~/Developer/github.com/leostera/dotfiles`

## Repository Structure

```
dotfiles/
├── home/                      # Files to symlink to $HOME
│   ├── .bin/                  # Custom scripts (symlinked to ~/.bin)
│   └── .config/               # XDG config files (symlinked to ~/.config)
│       ├── direnv/            # direnv configuration
│       ├── ghostty/           # Terminal emulator config
│       ├── git/               # Git config (not ~/.gitconfig!)
│       ├── nvim/              # Neovim configuration (Lua-based)
│       ├── ssh/               # SSH config
│       ├── tmux/              # Tmux configuration
│       └── zsh/               # Zsh shell configuration
├── obs/                       # OBS streaming configs
├── tools/                     # Setup and utility scripts
├── bootstrap.sh               # Main installation script
├── Brewfile                   # Homebrew packages/casks
└── remote-install.sh          # Remote curl-install script
```

## Key Files & Their Purpose

### Installation Scripts

- **`bootstrap.sh`**: Main setup - installs Homebrew, runs `brew bundle`, symlinks configs
- **`tools/symlink`**: Symlinks all config files from `home/` to `$HOME`
- **`remote-install.sh`**: Downloads and bootstraps dotfiles from GitHub

### Configuration Files

#### Neovim (`home/.config/nvim/`)
- **Fully Lua-based** modern Neovim config (migrated from VimScript)
- **Plugin Manager**: lazy.nvim (auto-installs on first boot)
- **LSP Manager**: Mason (auto-installs language servers)
- **Structure**:
  - `init.lua` - Entry point with lazy.nvim bootstrap
  - `lua/config/options.lua` - Vim settings
  - `lua/config/keymaps.lua` - Key mappings
  - `lua/config/plugins.lua` - Plugin specifications
  - `lua/config/lsp.lua` - LSP server configurations
  - `ftdetect/lore.vim` - Custom filetype detection
  - `syntax/lore.vim` - Custom syntax highlighting

**Leader key**: `,` (comma)
**Key mappings**:
- `,<Tab>` → FZF
- `<C-p>` → Files
- `,f` → Ripgrep search
- `,b` → Buffers

**LSP servers** (auto-installed via Mason):
- `rust_analyzer` - Rust
- `lua_ls` - Lua
- `elixirls` - Elixir
- `denols` - TypeScript/JavaScript
- `zls` - Zig

#### Zsh (`home/.config/zsh/`)
- Split into modular files: `alias`, `env`, `path`, `prompt`, `zshrc`
- **Important**: `~/.zshrc` is symlinked to `~/.config/zsh/zshrc`

**Key aliases**:
- `dotfiles` → `pushd ~/Developer/github.com/leostera/dotfiles`
- `repo()` → Clone and cd into GitHub repos
- `vim` / `v` → `nvim`
- `nvimrc` → Edit nvim config
- `gitconf` → Edit git config
- `reload` → Reload zsh config

#### Git (`home/.config/git/`)
- **Location**: `~/.config/git/config` (NOT `~/.gitconfig`)
- Uses 1Password for SSH signing
- GPG format: SSH
- Many useful aliases (see file for full list)

#### Custom Scripts (`home/.bin/`)
Small utility scripts for git workflows:
- `github-clone` - Clone GitHub repos to `~/Developer/github.com/`
- `fixup`, `squash` - Git workflow helpers
- `git-dirty` - Check if repo has uncommitted changes
- `co` - Interactive branch checkout with fzf

### Package Management

**`Brewfile`**: Contains all Homebrew packages and casks
- CLI tools: bat, fzf, ripgrep, neovim, tmux, etc.
- Apps: 1Password, Arc, Ghostty, Discord, OBS, etc.

## Workflow & Development Patterns

### Directory Structure Convention
GitHub repos are cloned to: `~/Developer/github.com/{owner}/{repo}`
- Enforced by `github-clone` script
- Used by `repo()` function in zsh aliases

### Key Customizations
1. **Custom filetype**: `.lore` files (syntax highlighting defined)
2. **Custom syntax**: `.caramel` → Rust syntax, `.core` → Erlang syntax
3. **Leader key**: Changed from default to `,`
4. **Terminal**: Using Ghostty (replaced Kitty)

## Making Changes

### Adding a New Package
1. Add to `Brewfile`
2. Run `brew bundle` from dotfiles directory

### Modifying Neovim Config
- Edit files in `home/.config/nvim/lua/config/`
- lazy.nvim auto-manages plugins
- Mason auto-installs LSP servers

### Adding Zsh Aliases
- Edit `home/.config/zsh/alias`
- Run `reload` to apply changes

### Symlink New Config
1. Add file/directory to `home/.config/`
2. Optionally update `tools/symlink` if special handling needed
3. Run `./tools/symlink`

## Important Notes for AI Agents

1. **Never create `~/.vimrc` or `~/.vim/`** - This repo uses Neovim with Lua config only
2. **Git config is XDG-compliant** - It's at `~/.config/git/config`, not `~/.gitconfig`
3. **Hardcoded paths are intentional** - The `~/Developer/github.com/` structure is by design
4. **Leader key is `,`** - Not space, not backslash
5. **Minimal philosophy** - Don't add complex frameworks or over-engineer solutions
6. **Auto-install everything** - Neovim plugins and LSP servers install on first boot
7. **No nix for now** - README mentions nix but it's not actively used (ignore nixpkgs dir)

## Bootstrap Process

1. Clone/download to `~/Developer/github.com/leostera/dotfiles`
2. Run `./bootstrap.sh`:
   - Installs Homebrew (if needed)
   - Runs `brew bundle`
   - Runs `kb-remap` (keyboard remapping)
   - Runs `./tools/symlink`
   - Launches new zsh shell
   - Runs `./tools/setup-upstream`
3. First `nvim` run:
   - Installs lazy.nvim
   - Installs all plugins
   - Mason installs LSP servers

## Common Tasks

**Update all packages**: `brew bundle` (in dotfiles dir)
**Update nvim plugins**: Open nvim, run `:Lazy update`
**Update LSP servers**: Open nvim, run `:Mason`
**Reload shell config**: `reload` (alias)
**Edit nvim config**: `nvimrc` (alias)
**Jump to dotfiles**: `dotfiles` (alias)
